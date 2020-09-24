//
//  AddDeviceView.swift
//  BleManageSwift
//
//  Created by RND on 2020/9/23.
//  Copyright © 2020 RND. All rights reserved.
//

import UIKit
import CoreBluetooth

class AddDeviceView: UIView {
    
    let ALERTVIEW_HEIGHT = UIScreen.main.bounds.size.height / 1.8
    let ALERTVIEW_WIDTH = UIScreen.main.bounds.size.width - 50
    let HEIGHT = UIScreen.main.bounds.size.height
    let WIDTH = UIScreen.main.bounds.size.width
    
    let CELLIDENTIFITER = "ADDVIEWTABLEVIEWCELL"
    
    var dataList = [BleModel]()
    
    var periperals =  [CBPeripheral]()
    
    //按钮
    var cancelBtn:UIButton?
    
    var commonView:UIView?
    
    //含有TableView
    var tableView:UITableView?
    
    private var refresh = UIRefreshControl()
    
    init(title: String?, name: String?) {
        let frame = CGRect(x: 0, y: 0,
                           width: UIScreen.main.bounds.size.width,
                           height: UIScreen.main.bounds.size.height)
        super.init(frame:frame)
        initView(title: title, name: name)
        initData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(title:String?,name: String?) {
        frame = UIScreen.main.bounds
        commonView = UIView(frame: CGRect(x: 25, y: HEIGHT / 2 - ALERTVIEW_HEIGHT / 2, width: ALERTVIEW_WIDTH, height: ALERTVIEW_HEIGHT))
        commonView!.backgroundColor = UIColor.white
        commonView!.layer.cornerRadius = 8.0
        commonView!.layer.masksToBounds = true
        commonView!.isUserInteractionEnabled = true
        addSubview(commonView!)
        
        let setLb = UILabel.init(frame: CGRect(x: 15, y: 20, width: 180, height: 20))
        setLb.textColor = UIColor.red
        setLb.font = UIFont(name: "Helvetica-Bold", size: 16)
        setLb.textAlignment = .center
        commonView!.addSubview(setLb)
        
        if (title != nil) {
            setLb.text = title
        }
        
        cancelBtn = UIButton.init(frame: CGRect(x: ALERTVIEW_WIDTH-50, y: 10, width: 30, height: 30))
        let image = UIImage(named: "close")
        cancelBtn?.setImage(image, for: .normal)
        commonView!.addSubview(cancelBtn!)
        
        //refresh.tintColor = UIColor.gray
        //refresh.attributedTitle = NSAttributedString(string: "Scanning...")
       // refresh.addTarget(self, action: #selector(loadBle), for: .valueChanged)
        
        tableView = UITableView.init(frame: CGRect(x: 10, y: 60, width: ALERTVIEW_WIDTH-20, height: ALERTVIEW_HEIGHT-80), style: .plain)
        tableView!.delegate = self;
        tableView!.dataSource = self;
        commonView!.addSubview(tableView!)
        
        //加刷新需要更换代码 不能写插入
        //tableView!.refreshControl = refresh
        
        cancelBtn!.addTarget(self, action: #selector(onCloseClick), for: .touchUpInside)
               
        showView()
        
    }
    
    func initData() {
        BleManage.shared.scan()
        BleEventBus.onMainThread(self, name: "bleEvent"){
            result in
            //self.refresh.endRefreshing()
            let model = result?.object as! BleModel
            //可以自定义判断蓝牙为空的时候不能添加进去直接排除
            if model.name != nil && model.name != ""{
                self.changeTableView(model: model)
            }
        }
    }
    
    private func changeTableView(model:BleModel){
        if !periperals.contains(model.peripheral!) {
            
            let positon = IndexPath(row: dataList.count, section: 0)
            var indexPaths = [IndexPath]()
            indexPaths.append(positon)
            
            periperals.append(model.peripheral!)
            dataList.append(model)
            
            tableView!.insertRows(at: indexPaths, with: .automatic)
            
        }
    }
    
    /*@objc func loadBle(){
        BleManager.shared.stopScan()
        
        if dataList.count > 0 {
            dataList.removeAll()
        }
        
        if periperals.count > 0 {
            periperals.removeAll()
        }
        
        //开始扫描
        BleManager.shared.startScan()
        
    }*/
    
    //点击按钮事件触发
    
    @objc func onCloseClick(){
        //停止扫描
        BleManage.shared.stop()
        hideView()
    }
    
    func showView() {
        backgroundColor = UIColor.clear
        UIApplication.shared.keyWindow?.addSubview(self)
        
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 1.0,y: 1.0)
        commonView!.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        commonView!.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveLinear, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            self.commonView!.transform = transform
            self.commonView!.alpha = 1
        }) { finished in
        }
    }
    
    func hideView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.transform = self.transform.translatedBy(x: 0, y: self.ALERTVIEW_HEIGHT)
            self.commonView!.alpha = 0
        }) { isFinished in
            self.commonView!.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
    
}


extension AddDeviceView:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: CELLIDENTIFITER)
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: CELLIDENTIFITER)
            cell!.accessoryType = .disclosureIndicator
        }
        
        if(dataList.count > 0){
            
            let model = dataList[indexPath.row]
            
            cell?.textLabel?.text = model.name
           
            if Date().compare((model.date?.addingTimeInterval(30))!) == .orderedDescending {
                 cell?.detailTextLabel?.text = String(format: "RSSI:%@", model.rssi!)+" ---- "+"OFF-LINE"
            }else{
                 cell?.detailTextLabel?.text = String(format: "RSSI:%@", model.rssi!)+" ---- "+"ON-LINE"
            }
        }
        
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if dataList.count > 0 {
            
            //停止蓝牙扫描
            BleManage.shared.stop()
            
            let model = dataList[indexPath.row]
            
            //连接蓝牙
            BleManage.shared.connect(model)
            
            hideView()
        }
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}

