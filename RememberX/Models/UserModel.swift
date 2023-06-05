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
