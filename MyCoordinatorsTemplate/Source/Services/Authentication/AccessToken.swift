//
//  AccessToken.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 05.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

final class AccessToken: NSObject, NSSecureCoding, NSCopying, Codable {

    static var supportsSecureCoding: Bool {
        return true
    }

    var token: String
    var uid: String

    private enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case uid = "uid"
    }

    required init(token: String, uid: String) {
        self.token = token
        self.uid = uid
    }

    required convenience init(coder aDecoder: NSCoder) {
        let token = aDecoder.decodeObject(forKey: "token") as? String ?? ""
        let uid = aDecoder.decodeObject(forKey: "uid") as? String ?? ""

        self.init(token: token, uid: uid)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.token, forKey: "token")
        aCoder.encode(self.uid, forKey: "uid")
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return AccessToken(token: self.token, uid: self.uid)
    }
}
