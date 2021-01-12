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
    
    private init() { }
}

