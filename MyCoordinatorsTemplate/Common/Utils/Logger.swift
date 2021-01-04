//
//  Logger.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 24.12.2020.
//  Copyright © 2020 Danyl Timofeyev. All rights reserved.
//

import Foundation

/**
 TODO: - Fix when presenting modally and have this kind of msg
 [STACK] Navigation to: ProfileViewController
 
 
 TODO: - Investigate why we have this duplicates while switching to
 feed tab, by first time after starting the app
 
 [NAV TAB] Selected tab with navigation stack: FeedViewController
 [STACK] Navigation to: FeedViewController
 [STACK] Navigation to: FeedViewController
 
 
 TODO: - Try didSet with assignDelegates() when setting navigationController or TabbarController
 */

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
