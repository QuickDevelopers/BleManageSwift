//
//  DetailViewCell.swift
//  BleManageSwift
//
//  Created by RND on 2020/9/25.
//  Copyright © 2020 RND. All rights reserved.
//

import UIKit


class DetailViewCell: UITableViewCell {
    
    let HEIGHT = UIScreen.main.bounds.size.height
    let WIDTH = UIScreen.main.bounds.size.width

    var mMainVw: UIView?
    
    //数据显示View
    var mDisplayVw:UIView?
    
    //加载
    var mLoadVw:UIView?
    
    //显示加载的中的Label
    var mLoadingLb:UILabel?
    
    var mNameLb:UILabel?
    
    var mConnectLb:UILabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
           super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        mMainVw = UIView.init(frame: CGRect(x: 10, y: 5, width: WIDTH-20, height: 100))
        mMainVw!.backgroundColor = UIColor(hexString: "#EAEAEA", transparency: 1.0)
        mMainVw!.layer.cornerRadius = 5.0
        mMainVw!.clipsToBounds = true
        mMainVw!.layer.shadowColor = UIColor.black.cgColor
        mMainVw!.layer.shadowOffset = CGSize(width: 5.0,height: 5.0);
        mMainVw!.layer.shadowOpacity = 0.5
        mMainVw!.layer.shadowRadius = 5
        self.addSubview(mMainVw!)
        
        
        mDisplayVw = UIView.init(frame: CGRect(x: 0, y: 5, width: WIDTH-20, height: 100))
        mMainVw!.addSubview(mDisplayVw!)
        
        mNameLb = UILabel.init(frame: CGRect(x: 10, y: 10, width: WIDTH-30, height: 30))
        mNameLb?.textColor = UIColor.black
        mNameLb?.font = UIFont(name: "Helvetica-Bold", size: 22)
        mNameLb?.textAlignment = .left
        mDisplayVw!.addSubview(mNameLb!)
        
        mConnectLb = UILabel.init(frame: CGRect(x: 10, y: 50, width: WIDTH-30, height: 30))
        mConnectLb?.textColor = UIColor.black
        mConnectLb?.font = UIFont(name: "Helvetica-Bold", size: 14)
        mConnectLb?.textAlignment = .left
        mDisplayVw!.addSubview(mConnectLb!)
        
        mLoadVw = UIView.init(frame: CGRect(x: 0, y: 5, width: WIDTH-20, height: 100))
        mMainVw!.addSubview(mLoadVw!)
        
        mLoadingLb = UILabel.init(frame: CGRect(x: 10, y: 26, width: WIDTH-30, height: 40))
        mLoadingLb?.textColor = UIColor.black
        mLoadingLb?.text = "Connecting..."
        mLoadingLb?.font = UIFont(name: "Helvetica-Bold", size: 32)
        mLoadingLb?.textAlignment = .left
        mLoadVw!.addSubview(mLoadingLb!)
        
        mDisplayVw?.isHidden = true
        mLoadVw?.isHidden = false
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
