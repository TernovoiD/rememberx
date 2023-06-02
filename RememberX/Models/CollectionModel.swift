//
//  CollectionModel.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 01.06.2023.
//

import Foundation


struct CollectionModel: Codable {
    let id: String
    let title: String
    let image: String?
    let isPrivate: Bool
    let updatedAt: Date
    let createdAt: Date
    let events: [EventModel]
}
