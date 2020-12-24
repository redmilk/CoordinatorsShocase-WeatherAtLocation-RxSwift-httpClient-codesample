//
//  Logger.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 24.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import Foundation

struct Logger {

    static func log(_ text: String = "", entity: AnyObject?, symbol: String = "🌀") {
        print("\(symbol) \(String(describing: entity)): \(text)")
    }
    
    static func initialization(entity: AnyObject) {
        print("⚠️ init: \(String(describing: entity))")
    }
    
    static func deinitialization(entity: AnyObject)  {
        print("❌ deinit: \(String(describing: entity))")
    }
    
}
