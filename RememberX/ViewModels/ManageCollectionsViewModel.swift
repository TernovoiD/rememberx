//
//  ManageCollectionsViewModel.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 26.06.2023.
//

import Foundation
import Combine

class ManageCollectionsViewModel {
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
                self.collections = loadedCollections
                self.collectionsChangeSubject.send()
            }
            .store(in: &cancellables)
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
}
