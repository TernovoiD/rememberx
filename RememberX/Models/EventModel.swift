//
//  EventModel.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 01.06.2023.
//

import Foundation

enum TimerEnum: String, CaseIterable {
    case never
    case daily
    case weekly
    case monthly
    case yearly
}

enum EventType: String, CaseIterable {
    case event
    case anniversary
    case birthday
}

struct EventModel: Codable {
    let id: String?
    var title: String
    var information: String?
    var timer: String
    var dateTime: Date
    var updatedAt: Date?
    var createdAt: Date?
    var something: String?
    
    init(id: String? = nil, title: String, information: String? = nil, timer: String, dateTime: Date, updatedAt: Date? = nil, createdAt: Date? = nil, something: String? = nil) {
        self.id = id
        self.title = title
        self.information = information
        self.timer = timer
        self.dateTime = dateTime
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.something = something
    }
}
