//
//  DataViewController.swift
//  BleManageSwift
//
//  Created by RND on 2020/9/24.
//  Copyright © 2020 RND. All rights reserved.
//  数据处理界面

import UIKit


class DataViewController: UIViewController, UITextFieldDelegate {
    
    let HEIGHT = UIScreen.main.bounds.size.height
    
    let WIDTH = UIScreen.main.bounds.size.width
    
    var model: BleCharacter?
    
    var mmodel: BleModel?
    
    var nameLb:UILabel?
    var chartLb:UILabel?
    var vreadLb:UILabel?
    var readLb:UILabel?
    var tipsLb:UILabel?

    var notifySch:UISwitch?
    var writeTf:UITextField?
    var writeBtn:UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        self.navigationController!.navigationBar.barTintColor =  UIColor(hexString: "#353535", transparency: 1.0)
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        self.navigationController!.navigationBar.titleTextAttributes = attributes
        self.navigationItem.title = "Operation"
        
        initView()
        initData()
        
    }
    
    func initView(){
        
        nameLb = UILabel.init(frame: CGRect(x: 20, y: 80, width: 200, height: 30))
        nameLb?.textColor = UIColor.black
        //nameLb?.text = "-"
        nameLb?.font = UIFont(name: "Helvetica-Bold", size: 20)
        nameLb?.textAlignment = .left
        self.view.addSubview(nameLb!)
        
        chartLb = UILabel.init(frame: CGRect(x: 20, y: 120, width: 200, height: 30))
        chartLb?.textColor = UIColor.black
        //chartLb?.text = "-"
        chartLb?.font = UIFont(name: "Helvetica-Bold", size: 20)
        chartLb?.textAlignment = .left
        self.view.addSubview(chartLb!)
        
        vreadLb = UILabel.init(frame: CGRect(x: 20, y: 170, width: WIDTH-20, height: 30))
        vreadLb?.textColor = UIColor.black
        vreadLb?.text = "Read or Notify"
        vreadLb?.font = UIFont(name: "Helvetica-Bold", size: 20)
        vreadLb?.textAlignment = .left
        self.view.addSubview(vreadLb!)
        
        
        //读取
        readLb = UILabel.init(frame: CGRect(x: 20, y: 200, width: 200, height: 30))
        readLb?.textColor = UIColor.black
        readLb?.font = UIFont(name: "Helvetica", size: 18)
        readLb?.textAlignment = .left
        self.view.addSubview(readLb!)
        
        
        tipsLb = UILabel.init(frame: CGRect(x: 20, y: 240, width: 100, height: 30))
        tipsLb?.textColor = UIColor.black
        tipsLb?.text = "Open Notify"
        tipsLb?.font = UIFont(name: "Helvetica-Bold", size: 16)
        tipsLb?.textAlignment = .left
        self.view.addSubview(tipsLb!)
        
        //通知
        notifySch = UISwitch.init(frame: CGRect(x: 120, y: 240, width: 50, height: 30))
        self.view.addSubview(notifySch!)
        
        notifySch!.addTarget(self, action: #selector(onAction(_:)), for: .valueChanged)
        
        readLb?.isHidden = true
        tipsLb?.isHidden = true
        notifySch?.isHidden = true
        
        
        //发送蓝牙数据
        writeTf = UITextField.init(frame: CGRect(x: 20, y: 300, width: 120, height: 55))
        writeTf!.textColor = UIColor.gray
        writeTf!.font = UIFont(name: "Helvetica", size: 18)
        writeTf!.placeholder = "Please input "
        writeTf?.keyboardType = .webSearch
        self.view.addSubview(writeTf!)
        
        writeBtn = UIButton.init(frame: CGRect(x: 180, y: 300, width: 120, height: 55))
        writeBtn?.backgroundColor = UIColor(hexString: "#999999", transparency: 1.0)
        writeBtn?.layer.cornerRadius = 15
        writeBtn?.setTitle("Send", for: .normal)
        self.view.addSubview(writeBtn!)
        
        writeBtn!.addTarget(self, action: #selector(sureOnClick(sender:)), for: .touchUpInside)
        
    }
    
    //按钮发送数据
    @objc func sureOnClick(sender:UIButton){
        let inpt = writeTf?.text
        if inpt != nil && inpt != "" {
            //let n = Int(inpt!)
            //let st = String(format:"%@", n!)
            //st += "\(n)"
            //print(st)
            
            let bytes: [UInt8] = [0x21,0x55,0x22]
            let byteData: Data = Data.init(bytes)
            
            //let ch:Character = Character(UnicodeScalar(n!)!)
            //print(ch)
            
            //let xq = String(format:"%@", ch as! CVarArg)
            
            //let s = convertToHex(fromASCII: inpt)
            
            BleManage.shared.writed(byteData, for: (model?.charater)!, periperalData: mmodel?.peripheral)
            
            //BleManage.shared.writes(s, for: (model?.charater)!, periperalData: mmodel?.peripheral)
        }
    }
    
    
    func initData(){
        
        //显示和隐藏控件
        nameLb?.text = mmodel?.name
        chartLb?.text = String(format:"%@", model!.charater!.uuid)
        
        let ok = model?.status
       
        for m in ok! {
            
            if m == "read" {
                readLb?.isHidden = false
                
            }

            if m == "notify" {
                readLb?.isHidden = false
                notifySch?.isHidden = false
                tipsLb?.isHidden = false
            }
        }
        
        //读取数据
        BleManage.shared.read(mmodel!, characteristic: (model?.charater)!)
        
        //接收数据
        BleEventBus.onMainThread(self, name: "connectEvent"){
            result in
            let list = result?.object as! [BleModel]
            if list.count > 0{
                for modelx in list {
                    if modelx === self.mmodel {
                        self.updateView(amodel: modelx)
                    }
                }
            }
        }
        
        //断开蓝牙
        BleEventBus.onMainThread(self, name: "disconnectEvent"){
            result in
            let modelx = result?.object as! BleModel
            //类型相当 用 === 去判断
            if modelx === self.mmodel {
                if modelx.peripheral != nil {
                    if modelx.name != nil {
                        //断开返回界面
                        BleLogger.log("Device \(modelx.name!) disconnect!")
                    }
                }
                //断开界面
                self.navigationController?.popViewController(animated: true)
            }else{
                if modelx.name != nil {
                    BleLogger.log("Device \(modelx.name!) disconnect!")
                }
            }
        }
        
    }
    
    
    @objc func onAction(_ sender: UISwitch?) {
        let switchBtn = sender;
        let  unitOn = (switchBtn?.isOn)!
        if unitOn {
            //开启通知
            BleManage.shared.nofity(mmodel!, characteristic: (model?.charater)!, open: true)
            
        }else{
            //关闭通知
            BleManage.shared.nofity(mmodel!, characteristic: model!.charater!, open: false)
        }
    }
    
    //更新按钮显示
    func updateView(amodel:BleModel){

        let q = amodel.data
        if let q = q {
            if q.charater == model!.charater {
                readLb?.text = q.data?.hexString()
            }
        }
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        writeTf?.resignFirstResponder()
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        writeTf?.resignFirstResponder()
        return true
    }
    
    
    func convertToHex(fromASCII ASCIIString: String?) -> String? {

        var hexString = ""

        let data = ASCIIString?.data(using: .utf8)

        var tempHexString: String? = nil
        if let data = data {
            tempHexString = "\(data)".replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        }
        tempHexString = tempHexString?.uppercased()
        var i = 0
        while i < (tempHexString?.count ?? 0) {

            let hexValue = (tempHexString as NSString?)?.substring(with: NSRange(location: i, length: 2))
            hexString = hexString + "0x\(hexValue ?? "") "
            i += 2
        }

        return hexString

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        BleEventBus.unregister(self, name: "connectEvent")
    }


}
