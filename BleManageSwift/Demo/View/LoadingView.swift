//
//  LoadingView.swift
//  BleManageSwift
//
//  Created by RND on 2020/9/25.
//  Copyright © 2020 RND. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    var commonView:UIView?

    let ALERTVIEW_HEIGHT = UIScreen.main.bounds.size.height / 1.8
    let ALERTVIEW_WIDTH = UIScreen.main.bounds.size.width - 50
    let HEIGHT = UIScreen.main.bounds.size.height
    let WIDTH = UIScreen.main.bounds.size.width
    
    init(title: String?) {
        let frame = CGRect(x: 0, y: 0,
                           width: UIScreen.main.bounds.size.width,
                           height: UIScreen.main.bounds.size.height)
        super.init(frame:frame)
        initView(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(title:String?) {
        frame = UIScreen.main.bounds
        commonView = UIView(frame: CGRect(x: 25, y: HEIGHT / 2 - ALERTVIEW_HEIGHT / 2, width: ALERTVIEW_WIDTH/2, height: ALERTVIEW_HEIGHT/2))
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
        
        showView()
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
