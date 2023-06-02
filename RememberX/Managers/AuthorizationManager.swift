//
//  AuthorizationManager.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 01.06.2023.
//

import Foundation

class AuthorizationManager {
    
    func saveToken(_ token: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(token, forKey: "userToken")
    }
    
    func getToken() -> String? {
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: "userToken")
    }
    
    func createBasicAuthorization(login: String, password: String) -> String {
        let loginString = String(format: "%@:%@", login, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        return loginData.base64EncodedString()
    }
}
