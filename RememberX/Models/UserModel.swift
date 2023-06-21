//
//  UserModel.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 01.06.2023.
//

import Foundation

struct UserModel: Codable {
    let id: String?
    let username: String?
    let updatedAt: Date?
    let createdAt: Date?
    let email: String?
    let password: String?
    let confirmPassword: String?
    
    init(id: String? = nil,
         username: String? = nil,
         updatedAt: Date? = nil,
         createdAt: Date? = nil,
         email: String? = nil,
         password: String? = nil,
         confirmPassword: String? = nil) {
        self.id = id
        self.username = username
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
    }
    
}
