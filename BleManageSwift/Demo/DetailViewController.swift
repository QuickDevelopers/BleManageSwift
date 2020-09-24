//
//  DetailViewController.swift
//  BleManageSwift
//
//  Created by RND on 2020/9/23.
//  Copyright © 2020 RND. All rights reserved.
//
import UIKit
import CoreBluetooth

class DetailViewController: UIViewController {
    
    let CELLIDENTIFITER = "CELLIDENTIFITER"
    
    private var tableView:UITableView?
    
    private var dataList = [BleModel]()
    
    private var addView:AddDeviceView?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        self.navigationController!.navigationBar.barTintColor =  UIColor(hexString: "#353535", transparency: 1.0)
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        self.navigationController!.navigationBar.titleTextAttributes = attributes
        self.navigationItem.title = "Detail List"
        
        let item = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(onAddBleClick))
        item.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = item
        
        initView()
        initData()
    }
    
    //点击进入新建界面
    @objc func onAddBleClick(){
       addView = AddDeviceView(title: "Add Connect Bluetooth", name: "")
    }
    
    func initView(){
        tableView = UITableView.init(frame: self.view.frame, style: .plain)
        tableView!.delegate = self;
        tableView!.dataSource = self;
        self.view.addSubview(tableView!)
    }
    
    
    func initData(){
        //断开蓝牙
        BleEventBus.onMainThread(self, name: "disconnectEvent"){
            result in
            let model = result?.object as! BleModel
            BleLogger.log("connect ble is disconnect \(String(describing: model.name))")
            self.tableView?.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //连接成功
        BleEventBus.onMainThread(self, name: "connectEvent"){
            result in
            self.dataList = result?.object as! [BleModel]
            self.tableView?.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        BleEventBus.unregister(self, name: "connectEvent")
    }
}


extension DetailViewController: UITableViewDelegate,UITableViewDataSource{
    
    
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
            
//            var s:String = ""
//
//            if model.charaters.count > 0 {
//                for m in model.charaters {
//
//                    print("characteristic is \(m.uuid)")
//
//                    s += String(format:"UUID is %@", m.uuid)+","
//                }
//            }

            if model.connect{
                cell?.detailTextLabel?.text = "connect"
            }else{
                cell?.detailTextLabel?.text = ""
            }
            
            
        }
        
        return cell!;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if dataList.count > 0 {
            
            let model = dataList[indexPath.row]
            let op = OperationViewController()
            op.mmodel = model
            self.navigationController?.pushViewController(op, animated:true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // TableView编辑的时候
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "DisConnect", handler: { action, indexPath in
            
            if self.dataList.count > 0 {
                let model = self.dataList[indexPath.row]
                BleManage.shared.disconnect(model)
                
                //如果长度只等于1的时候
                /*if self.dataList.count == 1 {
                    //断开所有的蓝牙
                    BleManage.shared.disconnectAll()
                    //并界面销毁
                    self.navigationController?.popViewController(animated: true)
                }*/
            }
        
            //删除之后立即刷新界面
            self.tableView?.reloadData()
        })
        return [delete]
    }
    
    
}
