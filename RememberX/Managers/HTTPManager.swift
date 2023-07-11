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
    case serverError
    case clientError
    case informationaResponse
    case redirectionMessage
    case unknownResponse
    case badURL
    case badResponse
    case notFound
    case notDecodable
    case notAuthorized
    case forbidden
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
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try verifyResponse(response)
        return (data, response)
        
    }
    
    
    private func verifyResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else { return }
        
        switch httpResponse.statusCode {
        case 100...199:
            throw HTTPError.informationaResponse
        case 200...299:
            return
        case 300...399:
            throw HTTPError.redirectionMessage
        case 401:
            throw HTTPError.notAuthorized
        case 403:
            throw HTTPError.forbidden
        case 404:
            throw HTTPError.notFound
        case 400, 402, 405...499:
            throw HTTPError.clientError
        case 500...599:
            throw HTTPError.serverError
        default:
            throw HTTPError.unknownResponse
        }
    }
}
