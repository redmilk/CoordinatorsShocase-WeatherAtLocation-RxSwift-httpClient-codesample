//
//  DateDecoder.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 17.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

class CustomJSONDecoder: JSONDecoder {
    
    override init() {
        super.init()
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        
        self.dateDecodingStrategy = .formatted(dateFormatter)
        
    }
    
}
