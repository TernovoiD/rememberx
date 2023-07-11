//
//  ManageCollectionsViewModel.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 26.06.2023.
//

import Foundation
import Combine

class SubscriptionsViewModel {
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
    
    private func setupBindings() {
        collectionsService.$publicCollections
            .receive(on: DispatchQueue.main)
            .sink { loadedCollections in
                let collectionWithUserRelations = self.addUserRelations(toCollections: loadedCollections)
                self.collections = collectionWithUserRelations.filter({ $0.userRelation == UserRelationToCollection.unknown.rawValue })
                self.collectionsChangeSubject.send()
            }
            .store(in: &cancellables)
    }
    
    func subscribe(toCollectionWithIndex index: Int) async throws {
        let collection = collections[index]
        try await collectionsService.subscribe(toCollection: collection)
    }
    
    func fetchCollections() {
        Task {
            do {
                try await collectionsService.fetchPublicCollection()
            } catch let error {
                print(error)
            }
        }
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
