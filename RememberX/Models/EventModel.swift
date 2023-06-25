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
    var type: String
    var dateTime: Date
    var updatedAt: Date?
    var createdAt: Date?
    var collectionName: String?
    
    init(id: String? = nil, title: String, information: String? = nil, type: String, dateTime: Date, updatedAt: Date? = nil, createdAt: Date? = nil, collectionName: String? = nil) {
        self.id = id
        self.title = title
        self.information = information
        self.type = type
        self.dateTime = dateTime
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.collectionName = collectionName
    }
    
    func addCollectionName(collectionName: String?) -> EventModel {
        return EventModel(id: self.id,
                          title: self.title,
                          information: self.information,
                          type: self.type,
                          dateTime: self.dateTime,
                          updatedAt: self.updatedAt,
                          createdAt: self.createdAt,
                          collectionName: collectionName)
    }
    
    var isFutureEvent: Bool {
        return dateTime >= Date() ? true : false
    }
    
    var anniversaryDate: Date {
        if isFutureEvent {
            return dateTime
        } else {
            let calendar = Calendar.current
            let today: Date = calendar.startOfDay(for: Date())
            let eventDate: Date = calendar.startOfDay(for: dateTime)
            let eventDateDC = calendar.dateComponents([.day, .month], from: eventDate)
            return calendar.nextDate(after: today, matching: eventDateDC, matchingPolicy: .nextTimePreservingSmallerComponents) ?? Date()
        }
    }
    
    var daysTo: Int {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let dateOfEvent = calendar.startOfDay(for: anniversaryDate)
            guard let daysTo = calendar.dateComponents([.day], from: today, to: dateOfEvent).day else { return 999 }
        if daysTo == 366 {
            return 0
        } else {
            return daysTo
        }
    }
    
    var daysToDescription: String {
        switch daysTo {
        case 1:
            return "day"
        default:
            return "days"
        }
    }
    
    var age: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dateOfEvent = calendar.startOfDay(for: dateTime)
        guard let age = calendar.dateComponents([.year], from: today, to: dateOfEvent).year else { return 999 }
        return abs(age)
    }
    
    var ageInDays: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dateOfEvent = calendar.startOfDay(for: dateTime)
        guard let age = calendar.dateComponents([.day], from: today, to: dateOfEvent).day else { return 999 }
        return abs(age)
    }
}
