//
//  UserSessionService.swift
//  MyCoordinatorsTemplate
//
//  Created by Danyl Timofeyev on 05.01.2021.
//  Copyright © 2021 Danyl Timofeyev. All rights reserved.
//

import Foundation

fileprivate let serviceName = "MyCoordinatorsTemplate"

final class AuthSession {

    typealias UserChangesCallback = (User?) -> Void
    
    private(set) var user: User? {
        didSet {
            notify()
        }
    }
    private let kAccount = "kAccount"
    private var callbacks: [UserChangesCallback] = []
    
//    lazy var archiver: NSKeyedArchiver = {
//       let archiver = NSKeyedArchiver()
//        archiver.delegate = self
//    }()
//
//    lazy var unarchiver: NSKeyedUnarchiver = {
//        let unarchiver = NSKeyedUnarchiver()
//        unarchiver.delegate = self
//    }()

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

    func setupUser(_ user: User) {
        guard let accessToken = user.accessToken else { fatalError("Internal inconsistency") }
        let account: String = accessToken.uid
        let obfuscatingArray: [UInt8] = Obfuscator().bytesByObfuscatingString(string: account)
        do {
            let data: Data = try NSKeyedArchiver.archivedData(withRootObject: obfuscatingArray,
                                                              requiringSecureCoding: false)
            /// obfuscted user id --> data --> save to UserDefaults
            UserDefaults.standard.set(data, forKey: kAccount)
            /// user --> data --> save to keychain
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: user,
                                                            requiringSecureCoding: false)
                let item = KeychainService(service: serviceName,
                                           account: account)
                do {
                    try item.save(data)
                    self.user = user
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
        if let data = UserDefaults.standard.object(forKey: kAccount) as? Data {
            do {
                if let obfuscatingArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [UInt8] {
                    let account: String = Obfuscator().reveal(key: obfuscatingArray)
                    let item = KeychainService(service: serviceName,
                                               account: account)
                    do {
                        let data: Data = try item.readData()
                        do {
                            user = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? User
                        } catch {
                            Logger.log(error.localizedDescription, entity: self, symbol: "[⛔️ unarchiveTopLevelObjectWithData(data:)]")
                        }
                    } catch {
                        if let error = error as? KeychainService.KeychainError {
                            switch error {
                            case .noObject:
                                Logger.log(error.localizedDescription,
                                           entity: self,
                                           symbol: "[⛔️ keychain: No object]")
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
        do {
            let keychain = KeychainService(service: serviceName, account: accessToken.uid)
            try keychain.delete()
            UserDefaults.standard.removeObject(forKey: kAccount)
            notify()
        } catch {
            Logger.log(error.localizedDescription, entity: self, symbol: "[⛔️ keychain.delete()]")
        }
    }
    
    func logout(user: User,
                completion: (() -> Void)? = nil
    ) {
        if let data = UserDefaults.standard.object(forKey: kAccount) as? Data {
            do {
                if let obfuscatingArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [UInt8] {
                    let account: String = Obfuscator().reveal(key: obfuscatingArray)
                    let item = KeychainService(service: serviceName,
                                               account: account)
                    do {
                        try item.delete()
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
    
    //    func updateCurrentUser(_ user: User) {
    //        guard let currentUser = self.user,
    //              let token = currentUser.accessToken else { return }
    //        self.user = user
    //        self.user?.accessToken = token
    //        save()
    //    }
}
