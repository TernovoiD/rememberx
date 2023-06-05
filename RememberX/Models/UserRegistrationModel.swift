//
//  UserRegistrationModel.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 04.06.2023.
//

import Foundation

struct UserRegistrationModel: Codable {
    let username: String
    let email: String
    let password: String
    let confirmPassword: String
    
    init(username: String, email: String, password: String, passwordRepeat: String) {
        self.username = username
        self.email = email
        self.password = password
        self.confirmPassword = passwordRepeat
    }
}
