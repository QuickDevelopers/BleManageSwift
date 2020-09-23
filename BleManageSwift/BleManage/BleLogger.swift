//
//  BleLogger.swift
//  BleManageSwift
//
//  Created by RND on 2020/9/23.
//  Copyright © 2020 RND. All rights reserved.
//

import UIKit

public protocol BleLoggerProtocol: class {
    func loggerDidLogString(_ string: String)
}

//internal只能访问自己模块的东西

public struct BleLogger {
    
    internal static weak var delegate: BleLoggerProtocol?
    
    internal static let loggingDateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "HH:mm:ss.SSS"
           return formatter
    }()
    
    public static func log(_ string: String) {
        let date = Date()
        let stringWithDate = "[\(loggingDateFormatter.string(from: date))] \(string)"
        print("<--BleManange--> "+stringWithDate, terminator: "")
        BleLogger.delegate?.loggerDidLogString(stringWithDate)
    }
    
}



