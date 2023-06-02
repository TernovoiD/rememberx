//
//  UserModel.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 01.06.2023.
//

import Foundation

struct UserModel: Codable {
    let id: String
    let username: String
    let updatedAt: Date
    let createdAt: Date
    
    init(id: String, username: String, updatedAt: Date, createdAt: Date) {
        self.id = id
        self.username = username
        self.updatedAt = updatedAt
        self.createdAt = createdAt
    }
}

struct UserRegistrationModel: Codable {
    let username: String
    let email: String
    let password: String
    let passwordRepeat: String
    
    init(username: String, email: String, password: String, passwordRepeat: String) {
        self.username = username
        self.email = email
        self.password = password
        self.passwordRepeat = passwordRepeat
    }
}
