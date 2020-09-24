//
//  ComExtension.swift
//  BleManageSwift
//
//  Created by RND on 2020/9/24.
//  Copyright © 2020 RND. All rights reserved.
//

import UIKit

//颜色
extension UIColor {
    convenience init(hexString: String,transparency: CGFloat = 1.0) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        var trans = transparency
        if trans < 0.0 { trans = 0.0 }
        if trans > 1.0 { trans = 1.0 }
        
        self.init(red: red, green: green, blue: blue, alpha: trans)
    }
    
    // UIColor -> Hex String
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}

extension Data{
    
    func hexString()->String{
        return map{String(format:"-%02x",$0)}.joined().uppercased()
    }
    
    //Data转16进制字符串
    func toHexArray()->[String]{
        return map{String(format: "%2x", $0)}
    }
    
    func toIntArray()->[Int]{
        return map{Int($0)}
    }

}

