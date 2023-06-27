//
//  EventsExtension.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 27.06.2023.
//

import Foundation

extension CollectionsService {
    
    func createEvent(withTitle title: String, andInformation information: String? = nil, andType type: EventType, andDateTime datetime: Date, inCollectionWithID collectionID: String? = nil) async throws {
        guard let userToken = authManager.getToken() else { throw HTTPError.notAuthorized }
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.collections + "/" + (collectionID ?? "") + Endpoints.userEvents) else { throw HTTPError.badURL }
        let newEvent = EventModel(title: title,
                                  information: information,
                                  type: type.rawValue,
                                  dateTime: datetime)
        let encodedEventData = try dataCoder.encodeItemToData(item: newEvent)
        let (data, _) = try await httpManager.sendRequest(toURL: url, withData: encodedEventData, withHTTPMethod: HTTPMethods.POST.rawValue, withloginToken: userToken)
        let createdEvent = try dataCoder.decodeItemFromData(data: data) as EventModel
        if let collectionIndex = userCollections.firstIndex(where: { $0.id == collectionID }) {
            removeThanAdd(collectionWithIndex: collectionIndex, withNewEvent: createdEvent)
        }
    }
    
    func deleteEvent(_ event: EventModel, fromCollectionWithID collectionID: String? = nil) async throws {
        guard let userToken = authManager.getToken() else { throw HTTPError.notAuthorized }
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.collections + "/" + (collectionID ?? "") + Endpoints.userEvents + "/" + (event.id ?? "")) else { throw HTTPError.badURL }
        let (_, response) = try await httpManager.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.DELETE.rawValue, withloginToken: userToken)
        guard let httpResponse = response as? HTTPURLResponse else { throw HTTPError.badResponse }
        if httpResponse.statusCode == 200, let collectionIndex = userCollections.firstIndex(where: { $0.id == collectionID }) {
            removeThanAdd(collectionWithIndex: collectionIndex, withDeletedEvent: event)
        }
    }
    
    // The removeThanAdd() function is needed as @Published will trigger changes in array [CollectionModel] but not in a sub array CollectionModel.events . Therefore to trigger changes and reload interface CollectionModel must be removed, updated and added.
    
    private func removeThanAdd(collectionWithIndex collectionIndex: Int,
                               withNewEvent newEvent: EventModel? = nil,
                               withUpdatedEvent updatedEvent: EventModel? = nil,
                               withDeletedEvent deletedEvent: EventModel? = nil) {
        let removedCollection = userCollections.remove(at: collectionIndex)
        
        // In case of ADD
        if let newEvent {
            let collection = removedCollection.add(event: newEvent)
            userCollections.append(collection)
        }
        
        // In case of UPDATE
        if let updatedEvent {
            let collection = removedCollection.update(event: updatedEvent)
            userCollections.append(collection)
        }
        
        // In case of DELETE
        if let deletedEvent {
            let collection = removedCollection.delete(event: deletedEvent)
            userCollections.append(collection)
        }
    }
}
