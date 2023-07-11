//
//  CollectionsViewModel.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 05.06.2023.
//

import Foundation
import Combine

class CollectionsViewModel {
    
    private lazy var collectionsChangeSubject = PassthroughSubject<Void, Never>()
    lazy var collectionsChangePublisher = collectionsChangeSubject.eraseToAnyPublisher()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var collections: [CollectionModel] = [ ]
    
    let authService: AuthenticationService
    let collectionsService: CollectionsService
    
    init(authService: AuthenticationService, collectionsService: CollectionsService) {
        self.authService = authService
        self.collectionsService = collectionsService
        
        setupBindings()
    }
    
    func createCollection(withTitle title: String, isPrivate: Bool) async throws {
        let collectionType = isPrivate ? CollectionTypeEnum.privateCollection : CollectionTypeEnum.publicCollection
        try await collectionsService.createCollection(withTitle: title, andType: collectionType)
    }
    
    func deleteCollection(collection: CollectionModel) async throws {
        try await collectionsService.deleteCollection(collection)
    }
    
    func unSubscribe(fromCollection collection: CollectionModel) async throws {
        try await collectionsService.unSubscribe(fromCollection: collection)
    }
    
    private func setupBindings() {
        collectionsService.$userCollections
            .receive(on: DispatchQueue.main)
            .sink { loadedCollections in
                let collectionWithUserRelations = self.addUserRelations(toCollections: loadedCollections)
                self.collections = collectionWithUserRelations
                self.collectionsChangeSubject.send()
            }
            .store(in: &cancellables)
    }
    
    private func addUserRelations(toCollections collections: [CollectionModel]) -> [CollectionModel] {
        var collectionsWithUserRelations: [CollectionModel] = []
        let user = authService.authenticatedUser
        
        for collection in collections {
            collectionsWithUserRelations.append(collection.addRelations(forUserWithID: user?.id))
        }
        return collectionsWithUserRelations
    }
    
}
