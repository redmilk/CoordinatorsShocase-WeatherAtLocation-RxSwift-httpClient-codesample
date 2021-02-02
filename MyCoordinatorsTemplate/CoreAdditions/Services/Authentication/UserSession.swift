//
//  UserSessionService.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 05.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

protocol AuthSessionProtocol: class {
    var isAuthorized: Bool { get }
    
    func setupUser(_ user: User, onSuccess: (()->Void)?)
    func fetchUser() -> User?
    func logout(user: User, completion: (() -> Void)?)
    func updateCurrentUser(_ user: User)
}

final class UserSession: AuthSessionProtocol {
    
    typealias UserChangesCallback = (User?) -> Void
    
    private(set) var user: User? {
        didSet {
            notify()
        }
    }
    
    private let serviceName = "MyCoordinatorsTemplate"
    private let kAccount = "kAccount"
    private var callbacks: [UserChangesCallback] = []
    
    init() {
        guard let user = fetchUser() else { return }
        self.user = user
    }
    
    private func notify() {
        for callback in self.callbacks {
            callback(self.user)
        }
    }
    
    // MARK: - Public API
    var isAuthorized: Bool {
        let token = self.user?.accessToken?.token
        return token != nil && token != ""
    }
    
    func subscribeToUserChanges(_ callback: @escaping UserChangesCallback) {
        self.callbacks.append(callback)
    }
    
    func setupUser(_ user: User, onSuccess: (()->Void)? = nil) {
        guard let accessToken = user.accessToken else { fatalError("Internal inconsistency") }
        let account: String = accessToken.uid
        ///user id --> obfuscation --> data --> save to UserDefaults
        let obfuscatingArray: [UInt8] = Obfuscator().bytesByObfuscatingString(string: account)
        do {
            let data: Data = try NSKeyedArchiver.archivedData(withRootObject: obfuscatingArray,
                                                              requiringSecureCoding: true)
            UserDefaults.standard.set(data, forKey: kAccount)
            do {
                /// user --> data --> save to keychain
                let data = try NSKeyedArchiver.archivedData(withRootObject: user,
                                                            requiringSecureCoding: true)
                let item = KeychainService(service: serviceName,
                                           account: account)
                do {
                    try item.save(data)
                    self.user = user
                    onSuccess?()
                    /// debug errors
                } catch {
                    Logger.log(error.localizedDescription,
                               entity: self,
                               symbol: "[⛔️ Saving user as Data to keychain failure")
                }
            } catch {
                Logger.log(error.localizedDescription,
                           entity: self,
                           symbol: "[⛔️ User archiving to Data failure]")
            }
        } catch {
            Logger.log(error.localizedDescription,
                       entity: self,
                       symbol: "[⛔️ Obfuscating array archiving to Data failure]")
        }
    }
    
    func fetchUser() -> User? {
        var user: User?
        /// kAccount(UserDefault key) --> data --> [UInt8] --> obfuscation to userId
        if let data = UserDefaults.standard.object(forKey: kAccount) as? Data {
            do {
                if let obfuscatingArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [UInt8] {
                    let account: String = Obfuscator().reveal(key: obfuscatingArray)
                    let item = KeychainService(service: serviceName,
                                               account: account)
                    do {
                        /// userId request to keychain to get User object as Data
                        /// Data --> User
                        let data: Data = try item.readData()
                        do {
                            user = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? User
                            /// debug errors
                        } catch {
                            Logger.log(error.localizedDescription,
                                       entity: self,
                                       symbol: "[⛔️ Unarchive from Data to User failure]")
                        }
                    } catch {
                        if let error = error as? KeychainService.KeychainError {
                            switch error {
                            case .noObject:
                                Logger.log("Keychain: No object",
                                           entity: nil,
                                           symbol: "❕")
                            case .unexpectedItemData:
                                Logger.log(error.localizedDescription,
                                           entity: self,
                                           symbol: "[⛔️ keychain: Unexpected item data]")
                            case .unexpectedObjectData:
                                Logger.log(error.localizedDescription,
                                           entity: self,
                                           symbol: "[⛔️ keychain: Unexpected object data]")
                            case .unhandledError(let osStatus):
                                Logger.log(error.localizedDescription,
                                           entity: self,
                                           symbol: "[⛔️ keychain: Unhandled error status: \(osStatus)]")
                            }
                        } else {
                            Logger.log(error.localizedDescription,
                                       entity: self,
                                       symbol: "[⛔️ read from keychain]")
                        }
                    }
                }
            } catch {
                Logger.log(error.localizedDescription,
                           entity: self,
                           symbol: "[⛔️ unarchive obfuscating array failure]")
            }
        }
        return user
    }
    
    func logout(_ completion: (() -> Void)? = nil) {
        guard let user = self.user,
              let accessToken = user.accessToken else { return }
        
        let keychain = KeychainService(service: serviceName, account: accessToken.uid)
        do {
            try keychain.delete()
            UserDefaults.standard.removeObject(forKey: kAccount)
            self.user = nil
            completion?()
        } catch {
            Logger.log(error.localizedDescription, entity: self, symbol: "[⛔️ keychain.delete()]")
        }
    }
    
    func logout(user: User,
                completion: (() -> Void)?
    ) {
        if let data = UserDefaults.standard.object(forKey: kAccount) as? Data {
            do {
                if let obfuscatingArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [UInt8] {
                    let account: String = Obfuscator().reveal(key: obfuscatingArray)
                    let item = KeychainService(service: serviceName,
                                               account: account)
                    do {
                        try item.delete() { [weak self] in
                            self?.user = nil
                            completion?()
                        }
                    } catch {
                        Logger.log(error.localizedDescription,
                                   entity: self,
                                   symbol: "[⛔️ keychain delete failure]")
                    }
                }
            } catch {
                Logger.log(error.localizedDescription,
                           entity: self,
                           symbol: "[⛔️ unarchive obfuscating array failure]")
            }
        }
    }
    
    func updateCurrentUser(_ user: User) {
        guard let currentUser = self.user,
              let token = currentUser.accessToken else { return }
        setupUser(user) { [weak self] in
            self?.user?.accessToken = token
        }
    }
}
