//
//  KeyChain.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 05.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

final class KeychainService {

    enum KeychainError: Error {
        case noObject
        case unexpectedObjectData
        case unexpectedItemData
        case unhandledError(status: OSStatus)
    }

    func readData() throws -> Data {
        var query = KeychainService.query(withService: service, account: account, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue

        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        guard status != errSecItemNotFound else {
            throw KeychainError.noObject
        }
        guard status == noErr else {
            throw KeychainError.unhandledError(status: status)
        }
        guard let existingItem = queryResult as? [String: AnyObject],
              let data = existingItem[kSecValueData as String] as? Data
                else {
            throw KeychainError.unexpectedObjectData
        }

        return data
    }

    func save(_ data: Data) throws {
        do {
            try _ = readData()

            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = data as AnyObject?

            let query = KeychainService.query(withService: service, account: account, accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)

            guard status == noErr else {
                throw KeychainError.unhandledError(status: status)
            }
        } catch KeychainError.noObject {
            var newItem = KeychainService.query(withService: service, account: account, accessGroup: accessGroup)
            newItem[kSecValueData as String] = data as AnyObject?

            let status = SecItemAdd(newItem as CFDictionary, nil)

            guard status == noErr else {
                throw KeychainError.unhandledError(status: status)
            }
        }
    }

    func delete(onSuccess: (()->Void)? = nil) throws {
        let query = KeychainService.query(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)

        guard status == noErr || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
        onSuccess?()
    }

    private static func query(withService service: String,
                              account: String? = nil,
                              accessGroup: String? = nil
    ) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?

        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }

        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }

        return query
    }
    
    init(service: String, account: String, accessGroup: String? = nil) {
        self.service = service
        self.account = account
        self.accessGroup = accessGroup
    }

    
    private let service: String
    private let accessGroup: String?
    private(set) var account: String
}
