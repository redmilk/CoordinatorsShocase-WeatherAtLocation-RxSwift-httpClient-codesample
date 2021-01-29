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
    
    private init() { }
}

