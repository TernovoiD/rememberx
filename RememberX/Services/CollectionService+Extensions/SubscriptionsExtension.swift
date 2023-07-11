//
//  SubscriptionsExtension.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 27.06.2023.
//

import Foundation


// MARK: - Subscriptions

extension CollectionsService {
    
    func subscribe(toCollection collection: CollectionModel) async throws {
        guard let userToken = authManager.getToken() else { throw HTTPError.notAuthorized }
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.collections + "/" + (collection.id ?? "error") + "/subscribers") else { throw HTTPError.badURL }
        let (_, response) = try await httpManager.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.POST.rawValue, withloginToken: userToken)
        guard let httpResponse = response as? HTTPURLResponse else { throw HTTPError.badResponse }
        print(httpResponse.statusCode)
        if httpResponse.statusCode == 200,
           let collectionIndex = publicCollections.firstIndex(where: { $0.id == collection.id }) {
            let removedCollection = publicCollections.remove(at: collectionIndex)
            userCollections.append(removedCollection)
        }
    }
    
    func unSubscribe(fromCollection collection: CollectionModel) async throws {
        guard let userToken = authManager.getToken() else { throw HTTPError.notAuthorized }
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.collections + "/" + (collection.id ?? "error") + "/subscribers") else { throw HTTPError.badURL }
        let (_, response) = try await httpManager.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.DELETE.rawValue, withloginToken: userToken)
        guard let httpResponse = response as? HTTPURLResponse else { throw HTTPError.badResponse }
        print(httpResponse.statusCode)
        if httpResponse.statusCode == 200,
           let collectionIndex = userCollections.firstIndex(where: { $0.id == collection.id }) {
            let removedCollection = userCollections.remove(at: collectionIndex)
            publicCollections.append(removedCollection)
        }
    }
}
