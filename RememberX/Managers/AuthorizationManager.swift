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
    
    func deleteToken() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "userToken")
    }
}
