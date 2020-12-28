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
        if let pureEntityName = String(describing: entity).slice(from: ".", to: ":") {
            print("\(symbol) \(text): \(pureEntityName)")
        } else if let pureEntityName = String(describing: entity).textAfter(str: ".") {
            print("\(symbol) \(text): \(pureEntityName)")
        } else {
            print("\(symbol) \(text): \(String(describing: entity))")
        }
    }
    
    static func initialization(entity: AnyObject, symbol: String = "⚠️") {
        if let pureEntityName = String(describing: entity).slice(from: ".", to: ":") {
            print("\(symbol) init: \(pureEntityName)")
        } else if let pureEntityName = String(describing: entity).textAfter(str: ".") {
            print("\(symbol) init: \(pureEntityName)")
        }
    }
    
    static func deinitialization(entity: AnyObject, symbol: String = "❌")  {
        if let pureEntityName = String(describing: entity).slice(from: ".", to: ":") {
            print("\(symbol) deinit: \(pureEntityName)")
        } else if let pureEntityName = String(describing: entity).textAfter(str: ".") {
            print("\(symbol) deinit: \(pureEntityName)")
        }
    }
    
}
