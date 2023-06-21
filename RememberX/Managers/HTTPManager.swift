//
//  HTTPManager.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 01.06.2023.
//

import Foundation

enum MIMEType: String {
    case JSON = "application/json"
}

enum HTTPHeaders: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

enum HTTPMethods: String {
    case POST, GET, PUT, PATCH, DELETE
}

enum HTTPError: Error {
    case badURL, badResponse, notFound, notDecodable, notAuthorized
}

class HTTPManager {
    func sendRequest(toURL url: URL,
                     withData data: Data? = nil,
                     withHTTPMethod HTTPMethod: String,
                     withloginToken loginToken: String? = nil,
                     withbasicAuthorization basicAuthorization: String? = nil) async throws -> (Data, URLResponse) {
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod
        request.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)
        
        // Add data
        if let data {
            request.httpBody = data
        }
        
        // Add user login and password
        if let basicAuthorization {
            request.addValue("Basic \(basicAuthorization)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
        }
        
        // Add user token
        if let loginToken {
            request.addValue("Bearer \(loginToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
        }
        
        return try await URLSession.shared.data(for: request)
    }
}
