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
        if let pureEntityName = String(describing: entity).slice(from: ".", to: ":") {
            print("⚠️ init: \(pureEntityName)")
        } else if let pureEntityName = String(describing: entity).textAfter(str: ".") {
            print("⚠️ init: \(pureEntityName)")
        }
    }
    
    static func deinitialization(entity: AnyObject)  {
        if let pureEntityName = String(describing: entity).slice(from: ".", to: ":") {
            print("❌ deinit: \(pureEntityName)")
        } else if let pureEntityName = String(describing: entity).textAfter(str: ".") {
            print("❌ deinit: \(pureEntityName)")
        }
    }
    
}
