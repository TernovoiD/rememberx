//
//  CollectionsService.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 05.06.2023.
//

import Foundation
import Combine

class CollectionsService {
    
    let authManager: AuthorizationManager
    let httpManager: HTTPManager
    let dataCoder: JSONDataCoder
    
    @Published var allCollections: [CollectionModel] = []
    @Published var UserCollections: [CollectionModel] = []
    
    init(authManager: AuthorizationManager, httpManager: HTTPManager, dataCoder: JSONDataCoder) {
        self.authManager = authManager
        self.httpManager = httpManager
        self.dataCoder = dataCoder
    }
    
    func fetchAllCollections() async throws -> [CollectionModel] {
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.events) else {
            throw HTTPError.badURL
        }
        let (data, response) = try await httpManager.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.GET.rawValue)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPError.badResponse
        }
        
        let collections = try dataCoder.decodeItemsArrayFromData(data: data) as [CollectionModel]
        return collections
    }
    
    func fetchUserCollections() {
        if let userToken = authManager.getToken() {
            
        }
    }
    
    func createCollection() {
        
    }
    
    func deleteCollection() {
        
    }
    
    func createEvent() {
        
    }
    
    func deleteEvent() {
        
    }
}
