//
//  EventsViewModel.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 01.06.2023.
//

import Foundation
import Combine

class EventsViewModel {
    
    
    // MARK: - Variables
    
    private var cancellables = Set<AnyCancellable>()
    private lazy var collectionsChangeSubject = PassthroughSubject<Void, Never>()
    lazy var collectionsChangePublisher = collectionsChangeSubject.eraseToAnyPublisher()
    
    @Published var upcomingEvents: [EventModel] = []
    
    let authService: AuthenticationService
    let collectionsService: CollectionsService
    
    
    // MARK: - Init
    
    init(authService: AuthenticationService, collectionsService: CollectionsService) {
        self.authService = authService
        self.collectionsService = collectionsService
        setupBindings()
    }
    
    
    // MARK: -  Functions
    
    func createEvent(inCollection collection: CollectionModel? = nil, withTitle title: String, andInformation information: String? = nil, andDate date: Date) async throws {
        let collectionID = collection == nil ? collectionsService.userDefaultCollectionID : collection?.id
        try await collectionsService.createEvent(withTitle: title, andInformation: information, andType: .event, andDateTime: date, inCollectionWithID: collectionID)
    }
    
    func deleteEvent(_ event: EventModel, fromCollection collection: CollectionModel? = nil) async throws {
        let collectionID = collection == nil ? collectionsService.userDefaultCollectionID : collection?.id
        try await collectionsService.deleteEvent(event, fromCollectionWithID: collectionID)
    }
    
    func updateCollection(byID collectionID: String?) -> CollectionModel? {
        return collectionsService.userCollections.first(where: { $0.id == collectionID })
    }
    
    private func setupBindings() {
        collectionsService.$userCollections
            .receive(on: DispatchQueue.main)
            .sink { loadedCollections in
                self.upcomingEvents = self.organizeEvents(from: loadedCollections)
                self.collectionsChangeSubject.send()
            }
            .store(in: &cancellables)
    }
    
    func organizeEvents(from collections: [CollectionModel]) -> [EventModel] {
        var events: [EventModel] = []
        for collection in collections {
            events.append(contentsOf: collection.returnEventsWithCollectionName())
        }
        let sortedEvents = events.sorted(by: { $0.daysTo < $1.daysTo })
        return sortedEvents
    }
}
