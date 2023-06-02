//
//  EventModel.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 01.06.2023.
//

import Foundation

struct EventModel: Codable {
    let id: String
    var title: String
    var information: String?
    var timer: String
    var dateTime: Date
    var updatedAt: Date
    var createdAt: Date
}
