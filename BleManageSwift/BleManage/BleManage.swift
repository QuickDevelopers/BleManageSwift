//
//  BleManage.swift
//  BleManageSwift
//
//  Created by RND on 2020/9/23.
//  Copyright © 2020 RND. All rights reserved.
//

import UIKit
import CoreBluetooth


public class BleManage: NSObject{
    
    private var centerManager = CBCentralManager()
    
    //连接成功的蓝牙列表
    var successList = [BleModel]()
    
    var p:CBPeripheral?
    
    //var c:CBCharacteristic?
    
    var d:Data?
    //错误信息
    var e:String?
    
    //单列模式
    public static let shared = BleManage()
    
    //队列管理
    //串行队列
    let queue = DispatchQueue.init(label: "github.blemanage.BleManage")
    
    //定时器
    //var timer: Timer?
    
    override init() {
        super.init()
        //运行蓝牙扫描
        run()
    }
}

extension BleManage{
    
    /// 启动蓝牙加入队列
    public func run(){
        centerManager = CBCentralManager(delegate: self, queue: queue)
    }
    
    /// 开始扫描蓝牙
    public func scan(){
        if centerManager.state.rawValue == CBManagerState.poweredOn.rawValue {
            centerManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    /// 停止扫描蓝牙
    public func stop(){
        centerManager.stopScan()
    }
    
    
    /// 连接蓝牙
    public func connect(_ model:BleModel){
        if centerManager.state.rawValue == CBManagerState.poweredOn.rawValue {
            if model.peripheral != nil {
                
                centerManager.connect(model.peripheral!, options: nil)
                
                model.connect = true
                self.successList.append(model)
                BleEventBus.post("connectEvent", sender: self.successList)
            }
        }
    }
    
    /// 断开蓝牙
    public func discon(_ model:BleModel){
        centerManager.cancelPeripheralConnection(model.peripheral!)
    }
    
    
    /// 断开所有的蓝牙
    public func disall(){
        if successList.count > 0 {
            for model in successList {
                centerManager.cancelPeripheralConnection(model.peripheral!)
            }
            successList.removeAll()
        }
    }
    
    /// 开启通知
    public func nofity(_ model:BleModel?, characteristic: CBCharacteristic?,open:Bool){
        //c = characteristic
        if let model = model,let characteristic = characteristic{
            model.peripheral!.setNotifyValue(open, for: characteristic)
        }
    }
    
    /// 读取蓝牙值
    public func read(_ model:BleModel?,characteristic: CBCharacteristic?){
        //c = characteristic
        if let model = model,let characteristic = characteristic{
            model.peripheral!.readValue(for: characteristic)
        }
    }
    
    
    /// 写入String数据
    public func writes(_ value: String?, for characteristic: CBCharacteristic?, periperalData periperal: CBPeripheral?) {
        let data = value?.data(using: .utf8)
        if (characteristic?.properties.rawValue)! & CBCharacteristicProperties.writeWithoutResponse.rawValue != 0 {
            if let data = data, let characteristic = characteristic {
                periperal?.writeValue(data, for: characteristic, type: .withoutResponse)
            }
        } else {
            if let data = data, let characteristic = characteristic {
                periperal?.writeValue(data, for: characteristic, type: .withResponse)
            }
        }
    }
    
    /// 写入Data数据
    public func writed(_ value: Data?, for characteristic: CBCharacteristic?, periperalData periperal: CBPeripheral?) {
        let data = value
        if (characteristic?.properties.rawValue)! & CBCharacteristicProperties.writeWithoutResponse.rawValue != 0 {
            if let data = data, let characteristic = characteristic {
                periperal?.writeValue(data, for: characteristic, type: .withoutResponse)
            }
        } else {
            if let data = data, let characteristic = characteristic {
                periperal?.writeValue(data, for: characteristic, type: .withResponse)
            }
        }
    }
}


extension BleManage:CBCentralManagerDelegate{
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if #available(iOS 10.0, *) {
            if central.state == .poweredOff {
                BleLogger.log("CoreBluetooth BLE hardware is powered off")
                BleEventBus.post("bleInfoEvent",sender: "CoreBluetooth BLE hardware is powered off")
            } else if central.state == .poweredOn {
                BleLogger.log("CoreBluetooth BLE hardware is powered on and ready")
                BleEventBus.post("bleInfoEvent",sender: "CoreBluetooth BLE hardware is powered on and ready")
                scan()
            } else if central.state == .unauthorized {
                BleLogger.log("CoreBluetooth BLE state is unauthorized")
                BleEventBus.post("bleInfoEvent",sender: "CoreBluetooth BLE state is unauthorized")
            } else if central.state == .unknown {
                BleLogger.log("CoreBluetooth BLE state is unknown")
                BleEventBus.post("bleInfoEvent",sender: "CoreBluetooth BLE state is unknown")
            } else if central.state == .unsupported {
                BleLogger.log("CoreBluetooth BLE hardware is unsupported on this platform")
                BleEventBus.post("bleInfoEvent",sender: "CoreBluetooth BLE hardware is unsupported on this platform")
                e = "CoreBluetooth BLE hardware is unsupported on this platform"
            }
        } else {
            // Fallback on earlier versions
            BleLogger.log("Fallback on earlier versions")
            BleEventBus.post("bleInfoEvent",sender: "Fallback on earlier versions")
        }
    }
    
    
    /// 发现设备
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSS: NSNumber) {
        
        //发送到界面去
        let model = BleModel()
        model.rssi = RSS
        model.name = peripheral.name
        model.advertisementData = advertisementData
        model.peripheral = peripheral
        model.date = Date()
        
        //发送广播数据
        BleEventBus.post("bleEvent",sender: model)
    }
    

    /// 发现服务
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        //停止扫描 这个用于自动连接的时候
        centerManager.stopScan()
        //如果为Ota的时候
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    
    /// 失败
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if successList.count > 0{
            for model in successList {
                if model.peripheral == peripheral {
                    successList.removeAll { $0 as BleModel === model as BleModel }
                }
            }
        }
        BleEventBus.post("connectEvent",sender: successList)
    }
    
    
    /// 断开
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        //断开蓝牙做相对应的处理
        if successList.count > 0{
            for model in successList {
                if model.peripheral == peripheral {
                    successList.removeAll { $0 as BleModel === model as BleModel }
                    //断开蓝牙事件
                    BleEventBus.post("disconnectEvent",sender: model)
                }
            }
        }
        
        BleEventBus.post("connectEvent",sender: successList)
    }
}


extension BleManage:CBPeripheralDelegate{
    
    /// 发现蓝牙服务
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            if let error = error {
                e = "Scan service error, error reason:\(error)"
                BleLogger.log("Scan service error, error reason:\(error)")
                BleEventBus.post("connectBleFailEvent",sender: "Scan service error, error reason:\(error)")
            }
        } else {
            for service in peripheral.services ?? [] {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    
    /// 发现蓝牙特征
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error != nil {
            if let error = error {
                e = "Scan service error, error reason:\(error)"
                BleLogger.log("Scan service error, error reason:\(error)")
                BleEventBus.post("connectBleFailEvent",sender: "Scan service error, error reason:\(error)")
            }
        } else {
            //遍历特征,拿到需要的特征进行处理
            for characteristic in service.characteristics ?? [] {
                //打印 UUID
                BleLogger.log("characteristic is \(characteristic.uuid)")
                for model in successList {
                    //只能同一个设备才能添加 characteristic
                    if model.peripheral == peripheral {
                        //后续可以自定义使用
                        model.service = service
                        
                        model.charaters.append(BleUtil.getCharacter(characteristic))
                        //描述读取
                        //peripheral.discoverDescriptors(for: characteristic)
                        
                    }
                }
            }
            BleEventBus.post("connectEvent",sender: successList)
        }
    }
    
    //读取描述信息
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        print("==描述== \(descriptor.description)")
    }
    
    
    /// 接受通知数据
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            if let error = error {
                e = "did update value \(error)"
                BleLogger.log("write data \(error)")
                BleEventBus.post("didupdateValueError",sender: "did update value \(error)")
            }
        }else{
            for model in successList {
                if model.peripheral == peripheral {
                    //当前的需要等于系统的防止数据错乱
                    for md in model.charaters{
                        if md.charater == characteristic{
                            let m = BleData()
                            m.charater = md.charater
                            m.data = characteristic.value
                            model.datas.append(m)
                        }
                    }
                }
            }
            
            BleEventBus.post("connectEvent",sender: successList)
            
        }
    }
    
    /// 写入蓝牙 *当为错误的时候返回错误的信息
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didWriteValueForCharacteristic")
        if error != nil {
            if let error = error {
                e = "write data \(error)"
                BleLogger.log("write data \(error)")
                BleEventBus.post("writeValueError",sender: "write data \(error)")
            }
            return
        }
    }
    
    /// 特征值更新
    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
//        if error != nil {
//            if let error = error {
//                e = "read characteristic \(error)"
//                BleLogger.log("read characteristic \(error)")
//                BleEventBus.post("readValueError",sender: "read characteristic \(error)")
//            }
//            return
//        }
//        print("\(characteristic.isNotifying)")
//
//        if(characteristic.isNotifying){
//            peripheral.readValue(for: characteristic);
//            print(characteristic.uuid.uuidString);
//        }
    }
}

//不重要回调

//    //写入数据回调
//    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
//
//    }

//    //设备名称修改
//    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
//
//    }
//
//    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
//
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
//
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didOpen channel: CBL2CAPChannel?, error: Error?) {
//
//    }
//
//    //服务名称修改
//    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
//
//    }
//
//    //描述符写入回调
//    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
//
//    }
//
//    //描述符更新
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
//
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
//
//    }
//
//    //发现描述符
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
//
//    }
//
//    //特征值更新
//    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
//
//    }
//
//
