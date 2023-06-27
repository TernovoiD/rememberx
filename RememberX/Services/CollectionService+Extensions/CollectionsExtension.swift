//
//  CollectionsExtension.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 27.06.2023.
//

import Foundation

// MARK: - User collections

extension CollectionsService {
    
    func fetchUserCollections() async throws {
        guard let userToken = authManager.getToken() else { throw HTTPError.notAuthorized }
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.userCollections) else { throw HTTPError.badURL }
        
        let (data, _) = try await httpManager.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.GET.rawValue, withloginToken: userToken)
        userCollections = try dataCoder.decodeItemsArrayFromData(data: data) as [CollectionModel]
        setUserDefaultCollection()
    }
    
    func fetchPublicCollection() async throws {
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.collections) else { throw HTTPError.badURL }
        
        let (data, _) = try await httpManager.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.GET.rawValue)
        publicCollections = try dataCoder.decodeItemsArrayFromData(data: data) as [CollectionModel]
    }
    
    func createCollection(withTitle title: String, andType type: CollectionTypeEnum) async throws {
        guard let userToken = authManager.getToken() else { throw HTTPError.notAuthorized }
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.collections) else { throw HTTPError.badURL }
        
        let newCollection = CollectionModel(id: nil,
                                            title: title,
                                            information: nil,
                                            image: nil,
                                            type: type.rawValue,
                                            updatedAt: nil,
                                            createdAt: nil,
                                            events: [])
        let encodedCollectionData = try dataCoder.encodeItemToData(item: newCollection)
        let (data, _) = try await httpManager.sendRequest(toURL: url, withData: encodedCollectionData, withHTTPMethod: HTTPMethods.POST.rawValue, withloginToken: userToken)
        let createdCollection = try dataCoder.decodeItemFromData(data: data) as CollectionModel
        userCollections.append(createdCollection)
    }
    
    func deleteCollection(_ collection: CollectionModel) async throws {
        guard let userToken = authManager.getToken() else { throw HTTPError.notAuthorized }
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.collections + "/" + (collection.id ?? "")) else { throw HTTPError.badURL }
        let (_, response) = try await httpManager.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.DELETE.rawValue, withloginToken: userToken)
        guard let httpResponse = response as? HTTPURLResponse else { throw HTTPError.badResponse }
        if httpResponse.statusCode == 200,
           let collectionIndex = userCollections.firstIndex(where: { $0.id == collection.id }) {
            userCollections.remove(at: collectionIndex)
        }
    }
    
    private func setUserDefaultCollection() {
        if let defaultCollection = userCollections.first(where: { $0.type == CollectionTypeEnum.defaultCollection.rawValue }) {
            userDefaultCollectionID = defaultCollection.id
        }
    }
}
