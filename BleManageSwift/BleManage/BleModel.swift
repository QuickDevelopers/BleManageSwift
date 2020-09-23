//
//  BleModel.swift
//  BleManageSwift
//
//  Created by RND on 2020/9/23.
//  Copyright © 2020 RND. All rights reserved.
//

import UIKit
import CoreBluetooth

public class BleModel: NSObject {
    //名字
   public var name:String?
    //mac
   public var mac:String?
    //rssi信号值
   public var rssi:NSNumber?
    //
   public var peripheral:CBPeripheral?
    //特征
   public var charaters = [CBCharacteristic]()
    //是否连接
   public var connect = false
    //接收广播数据
   public var advertisementData: [String : Any]?
    //日期
   public var date:Date?
    //解析的data数据
   public var data:Data?
}
