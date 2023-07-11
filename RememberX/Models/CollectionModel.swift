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

enum UserRelationToCollection: String {
    case owner
    case moderator
    case subscriber
    case unknown
}

struct CollectionModel: Codable {
    let id: String?
    let title: String
    let information: String?
    let image: String?
    let type: String
    let updatedAt: Date?
    let createdAt: Date?
    let events: [EventModel]?
    let owner: UserModel?
    let moderators: [UserModel]?
    let subscribers: [UserModel]?
    let userRelation: String?
    
    
    init(id: String? = nil, title: String, information: String? = nil, image: String? = nil, type: String, updatedAt: Date? = nil, createdAt: Date? = nil, events: [EventModel]? = nil, owner: UserModel? = nil, moderators: [UserModel]? = nil, subscribers: [UserModel]? = nil, userRelation: String? = nil) {
        self.id = id
        self.title = title
        self.information = information
        self.image = image
        self.type = type
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.events = events
        self.owner = owner
        self.moderators = moderators
        self.subscribers = subscribers
        self.userRelation = userRelation
    }
    
    func addRelations(forUserWithID userID: String?) -> CollectionModel {
        var relation: UserRelationToCollection = UserRelationToCollection.unknown
        
        if owner?.id == userID {
            relation = UserRelationToCollection.owner
        } else if moderators?.contains(where: { $0.id == userID }) == true {
            relation = UserRelationToCollection.moderator
        } else if subscribers?.contains(where: { $0.id == userID }) == true {
            relation = UserRelationToCollection.subscriber
        }
        
        return CollectionModel(id: self.id, title: self.title, information: self.information, image: self.image, type: self.type, updatedAt: self.updatedAt, createdAt: self.createdAt, events: self.events, owner: self.owner, moderators: self.moderators, subscribers: self.subscribers, userRelation: relation.rawValue)
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
        return CollectionModel(id: self.id, title: self.title, information: self.information, image: self.image, type: self.type, updatedAt: self.updatedAt, createdAt: self.createdAt, events: events, owner: self.owner, moderators: self.moderators, subscribers: self.subscribers, userRelation: self.userRelation)
    }
    
    func update(event: EventModel) -> CollectionModel {
        var events = self.events ?? []
        events.removeAll(where: { $0.id == event.id })
        events.append(event)
        return CollectionModel(id: self.id, title: self.title,  information: self.information, image: self.image, type: self.type, updatedAt: self.updatedAt, createdAt: self.createdAt, events: events, owner: self.owner, moderators: self.moderators, subscribers: self.subscribers, userRelation: self.userRelation)
    }
    
    func delete(event: EventModel) -> CollectionModel {
        var events = self.events ?? []
        events.removeAll(where: { $0.id == event.id })
        return CollectionModel(id: self.id, title: self.title, information: self.information,  image: self.image, type: self.type, updatedAt: self.updatedAt, createdAt: self.createdAt, events: events, owner: self.owner, moderators: self.moderators, subscribers: self.subscribers, userRelation: self.userRelation)
    }
}
