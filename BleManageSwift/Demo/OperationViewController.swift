//
//  OperationViewController.swift
//  BleManageSwift
//
//  Created by RND on 2020/9/24.
//  Copyright © 2020 RND. All rights reserved.
//  操作界面

import UIKit
import CoreBluetooth


class OperationViewController: UIViewController {
    
    var mmodel:BleModel?
    
    let CELLIDENTIFITER = "CELLIDENTIFITER"
    
    private var tableView:UITableView?
    
    private var dataList = [BleCharacter]()

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
        tableView = UITableView.init(frame: self.view.frame, style: .plain)
        tableView!.delegate = self;
        tableView!.dataSource = self;
        self.view.addSubview(tableView!)
    }
    
    
    func initData(){
        dataList = mmodel!.charaters
    }
    
}

extension OperationViewController: UITableViewDelegate,UITableViewDataSource{
    
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
            let m = dataList[indexPath.row]
            
            cell?.textLabel?.text = String(format:"%@", m.charater!.uuid)
            
            cell?.detailTextLabel!.text = ""
            
            if m.status.count > 0 {
                for mm in m.status {
                     cell?.detailTextLabel!.text = (cell?.detailTextLabel!.text ?? "") + " | " + mm
                }
            }
        }
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if dataList.count > 0 {
            let model = dataList[indexPath.row]
            let data = DataViewController()
            data.model = model
            data.mmodel = mmodel
            self.navigationController?.pushViewController(data, animated:true)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
    
}


