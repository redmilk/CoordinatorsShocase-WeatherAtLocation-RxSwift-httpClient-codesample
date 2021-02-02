//
//  Helpers.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 31.10.2020.
//

import UIKit

struct Utils {
    
    static func openSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    static func fetchErrorInfoTitle(_ error: Error) -> String {
        guard let appError = error as? ApplicationError,
              let errorInfo = appError.errorContent else { return "" }
        return errorInfo.0
    }
    
    static var weatherApiKey: String {
        guard let plist = Utils.plistDict(with: Constants.weatherKeyPlistName, isWithinAssets: true),
              let key = plist[Constants.weatherKeyName] else { fatalError("Internal inconsistency") }
        return key
    }
    
    static func plistDict(with name: String, isWithinAssets: Bool) -> [String : String]? {
        guard let asset = NSDataAsset(name: name, bundle: .main),
              let plistDict = (try? PropertyListSerialization.propertyList(from: asset.data,
                                                                           options: .mutableContainersAndLeaves,
                                                                           format: nil)) as? [String : String]
        else { return nil }
        return plistDict
    }
    
    private init() { }
}

