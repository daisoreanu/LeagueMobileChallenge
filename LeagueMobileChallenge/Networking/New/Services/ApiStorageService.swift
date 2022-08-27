//
//  ApiStorageService.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import Foundation

fileprivate enum UserDefaultsKeys: String {
    case authToken
}

protocol ApiStorageServiceProtocol: AnyObject {
    func getToken() -> String?
    func updateToken(_ token: String)
}

class ApiStorageService {
    private var authToken: String?
#warning("Discussion - In fully fledged mobile app is recomanded to use KeyChain for sensitive data.")
    private var userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
#warning("Discussion - Since I don't know the AuthToken logic I delete the store.")
        delete()
    }
}

extension ApiStorageService: ApiStorageServiceProtocol {
    func getToken() -> String? {
        if authToken == nil {
            update()
        }
        return authToken
    }
    func updateToken(_ token: String) {
        authToken = token
        save(token: token)
    }
}

private extension ApiStorageService {
    func save(token: AuthToken) {
        userDefaults.set(token, forKey: UserDefaultsKeys.authToken.rawValue)
    }
    
    func update() {
        authToken = userDefaults.string(forKey: UserDefaultsKeys.authToken.rawValue)
    }
    
    func delete() {
        userDefaults.removeObject(forKey: UserDefaultsKeys.authToken.rawValue)
    }
}
