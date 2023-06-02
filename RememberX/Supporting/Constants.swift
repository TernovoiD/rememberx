//
//  Constants.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 01.06.2023.
//

import Foundation

enum Constants {
    static let baseURL = "https://e963-151-251-99-74.eu.ngrok.io/"
}

enum Endpoints {
    static let events = "events"
}

enum HTTPMethods: String {
    case POST, GET, PUT, PATCH, DELETE
}

enum HTTPError: Error {
    case badURL, badResponse, notFound, notDecodable
}
