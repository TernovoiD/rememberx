//
//  CollectionModel.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 01.06.2023.
//

import Foundation

enum CollectionTypeEnum: String {
    case defaultCollection
    case privateCollection
    case publicCollection
}

struct CollectionModel: Codable {
    let id: String?
    let title: String
    let image: String?
    let type: String
    let updatedAt: Date?
    let createdAt: Date?
    let events: [EventModel]?
    
    init(id: String? = nil, title: String, image: String? = nil, type: String, updatedAt: Date? = nil, createdAt: Date? = nil, events: [EventModel]) {
        self.id = id
        self.title = title
        self.image = image
        self.type = type
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.events = events
    }
    
    func add(event: EventModel) -> CollectionModel {
        var events = self.events ?? []
        events.append(event)
        return CollectionModel(id: self.id, title: self.title, image: self.image, type: self.type, updatedAt: self.updatedAt, createdAt: self.createdAt, events: events)
    }
    
    func update(event: EventModel) -> CollectionModel {
        var events = self.events ?? []
        events.removeAll(where: { $0.id == event.id })
        events.append(event)
        return CollectionModel(id: self.id, title: self.title, image: self.image, type: self.type, updatedAt: self.updatedAt, createdAt: self.createdAt, events: events)
    }
    
    func delete(event: EventModel) -> CollectionModel {
        var events = self.events ?? []
        events.removeAll(where: { $0.id == event.id })
        return CollectionModel(id: self.id, title: self.title, image: self.image, type: self.type, updatedAt: self.updatedAt, createdAt: self.createdAt, events: events)
    }
}
