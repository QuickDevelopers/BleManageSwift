//
//  HomeViewController.swift
//  BleManageSwift
//
//  Created by RND on 2020/9/23.
//  Copyright © 2020 RND. All rights reserved.
//

import UIKit
import CoreBluetooth

class HomeViewController: UIViewController {
    
    let CELLIDENTIFITER = "CELLIDENTIFITER"
    
    private var refresh = UIRefreshControl()
    
    private var tableView:UITableView?
    
    private var dataList = [BleModel]()
    
    var periperals =  [CBPeripheral]()
    
    //显示设备的蓝牙列表
    var devicesList = [BleModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        self.navigationController!.navigationBar.barTintColor =  UIColor(hexString: "#353535", transparency: 1.0)
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        self.navigationController!.navigationBar.titleTextAttributes = attributes
        self.navigationItem.title = "Ble List"
        
        initView()
        initData()
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadBle()
    }
    
    
    private func initView(){
        refresh.tintColor = UIColor.gray
        refresh.attributedTitle = NSAttributedString(string: "Scanning...")
        refresh.addTarget(self, action: #selector(loadBle), for: .valueChanged)
        
        tableView = UITableView.init(frame: self.view.frame, style: .plain)
        tableView!.delegate = self;
        tableView!.dataSource = self;
        self.view.addSubview(tableView!)
        
        //加刷新需要更换代码 不能写插入
        tableView!.refreshControl = refresh
        
    }
    
    /// 接收数据
    private func initData(){
       
        //接收列表
        BleEventBus.onMainThread(self, name: "bleEvent"){
            result in
            self.refresh.endRefreshing()
            let model = result?.object as! BleModel
            //可以自定义判断蓝牙为空的时候不能添加进去直接排除
            if model.name != nil && model.name != ""{
                self.changeTableView(model: model)
            }
        }
    }
    
    @objc func loadBle() {
        //首先停止扫描
        BleManage.shared.stop()
        
        if dataList.count > 0 {
            dataList.removeAll()
        }
        
        if periperals.count > 0 {
            periperals.removeAll()
        }
        
        tableView!.reloadData()
        
        BleManage.shared.scan()
        
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
        /*
        此段代码非常卡顿 最好不要去加
        else{
            
            for i in 0..<dataList.count {
                if dataList[i].name == model.name{
                    dataList[i] = model
                    let position = IndexPath(row: i, section: 0)
                    //var indexPaths = [IndexPath]()
                    //indexPaths.append(positon)
                    tableView!.reloadRows(at: [position], with: .none)
                }
            }
        }
        */
    }
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource{
    
    
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
        
        //cell!.selectionStyle = UITableviewcell
        
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
            
            let ota = DetailViewController()
                       
            self.navigationController?.pushViewController(ota, animated:true)
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}


