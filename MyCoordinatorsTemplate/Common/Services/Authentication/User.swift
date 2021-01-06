//
//  User.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 05.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

final class User: NSObject, NSSecureCoding, NSCopying, Codable {

    static var supportsSecureCoding: Bool {
        return true
    }

    var id: String
    var firstName: String?
    var lastName: String?
    var email: String?
    var accessToken: AccessToken?
    var fullName: String {
        return "\(firstName ?? "") \(lastName ?? "")"
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case accessToken
    }

    required init(instance: User) {
        self.id = instance.id
        self.firstName = instance.firstName
        self.lastName = instance.lastName
        self.email = instance.email
        self.accessToken = instance.accessToken
    }

    required init(_ id: String,
                  _ firstName: String?,
                  _ lastName: String?,
                  _ email: String?,
                  _ accessToken: AccessToken?
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.accessToken = accessToken
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        let lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        let email = try container.decodeIfPresent(String.self, forKey: .email)
        let accessToken = try container.decodeIfPresent(AccessToken.self, forKey: .accessToken)
        self.init(id, firstName, lastName, email, accessToken)
    }

    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        let firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        let lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        let email = aDecoder.decodeObject(forKey: "email") as? String
        let accessToken = aDecoder.decodeObject(forKey: "accessToken") as? AccessToken
        self.init(id, firstName, lastName, email, accessToken)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.firstName, forKey: "firstName")
        aCoder.encode(self.lastName, forKey: "lastName")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.accessToken, forKey: "accessToken")
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return User(self.id, self.firstName, self.lastName, self.email, self.accessToken)
    }

}

