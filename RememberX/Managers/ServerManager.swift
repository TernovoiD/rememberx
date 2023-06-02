//
//  ServerManager.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 01.06.2023.
//

import Foundation

//class ServerManager {
//
//
//
//        func delete(fromURL url: URL) async throws {
//            guard let _ = try? await sendData(data: nil, withHTTPMethod: HTTPMethods.DELETE.rawValue, toURL: url) else {
//                throw HTTPError.badResponse
//            }
//        }
//
//        private func loadData(fromURL url: URL) async throws -> Data {
//            let (data, response) = try await URLSession.shared.data(from: url)
//
//            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
//                throw HTTPError.badResponse
//            }
//
//            return data
//        }
//
//        private func sendData(data: Data?, withHTTPMethod HTTPMethod: String, toURL url: URL) async throws -> URLResponse {
//            var request = URLRequest(url: url)
//
//            if let data {
//                request.httpBody = data
//            }
//            request.httpMethod = HTTPMethod
//            request.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)
//
//            let (_, response) = try await URLSession.shared.data(for: request)
//
//            return response
//        }
//}

