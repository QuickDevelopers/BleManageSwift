//
//  BleUtil.swift
//  BleManageSwift
//
//  Created by RND on 2020/9/24.
//  Copyright © 2020 RND. All rights reserved.
//

import Foundation
import CoreBluetooth

public struct BleUtil {
    
    /// 获取所有的特征
    public static func getCharacter(_ character: CBCharacteristic)->BleCharacter {
        let model = BleCharacter()
        model.charater = character
        model.status = getStatus(character)
        return model
    }
    
    /// 获取当前的状态
    public static func getStatus(_ character: CBCharacteristic)->[String]{
        var status = [String]()
        //获取对应的状态
        let p = character.properties
        
        if p.rawValue & CBCharacteristicProperties.broadcast.rawValue != 0 {
            status.append("broadcast")
        }
        
        if p.rawValue & CBCharacteristicProperties.read.rawValue != 0 {
            status.append("read")
        }
        
        if p.rawValue & CBCharacteristicProperties.write.rawValue != 0 {
            status.append("write")
        }
        
        if p.rawValue & CBCharacteristicProperties.writeWithoutResponse.rawValue != 0 {
            status.append("writeWithoutResponse")
        }
        
        if p.rawValue & CBCharacteristicProperties.notify.rawValue != 0 {
            status.append("notify")
        }
        
        if p.rawValue & CBCharacteristicProperties.indicate.rawValue != 0 {
            status.append("indicate")
        }
        
        if p.rawValue & CBCharacteristicProperties.authenticatedSignedWrites.rawValue != 0 {
            status.append("authenticatedSignedWrites")
        }
        
        if p.rawValue & CBCharacteristicProperties.extendedProperties.rawValue != 0 {
            status.append("extendedProperties")
        }
        
        return status
    }
    
}
