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
    let information: String?
    let image: String?
    let type: String
    let updatedAt: Date?
    let createdAt: Date?
    var events: [EventModel]?
    
    init(id: String? = nil, title: String, information: String? = nil, image: String? = nil, type: String, updatedAt: Date? = nil, createdAt: Date? = nil, events: [EventModel]) {
        self.id = id
        self.title = title
        self.information = information
        self.image = image
        self.type = type
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.events = events
    }
    
    func returnEventsWithCollectionName() -> [EventModel] {
        let events = self.events ?? []
        if type == CollectionTypeEnum.defaultCollection.rawValue {
            return events
        } else {
            var updatedEvents: [EventModel] = []
            
            for event in events {
                let updatedEvent = event.addCollectionName(collectionName: self.title)
                updatedEvents.append(updatedEvent)
            }
            return updatedEvents
        }
    }
    
    func add(event: EventModel) -> CollectionModel {
        var events = self.events ?? []
        events.append(event)
        return CollectionModel(id: self.id, title: self.title, information: self.information, image: self.image, type: self.type, updatedAt: self.updatedAt, createdAt: self.createdAt, events: events)
    }
    
    func update(event: EventModel) -> CollectionModel {
        var events = self.events ?? []
        events.removeAll(where: { $0.id == event.id })
        events.append(event)
        return CollectionModel(id: self.id, title: self.title,  information: self.information, image: self.image, type: self.type, updatedAt: self.updatedAt, createdAt: self.createdAt, events: events)
    }
    
    func delete(event: EventModel) -> CollectionModel {
        var events = self.events ?? []
        events.removeAll(where: { $0.id == event.id })
        return CollectionModel(id: self.id, title: self.title, information: self.information,  image: self.image, type: self.type, updatedAt: self.updatedAt, createdAt: self.createdAt, events: events)
    }
}
