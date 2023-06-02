//
//  DataManager.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 01.06.2023.
//

import Foundation

class DataManager {
    
    let dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    func encodeItemToData<T: Codable>(item: T) throws -> Data {
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        
        let data = try encoder.encode(item)
        return data
    }
    
    func decodeItemsFromData<T: Codable>(data: Data) throws -> [T] {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        guard let items = try? decoder.decode([T].self, from: data) else {
            throw HTTPError.notDecodable
        }
        
        return items
    }
}
