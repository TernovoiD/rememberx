//
//  RemoveThanAddExtension.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 28.06.2023.
//

import Foundation

extension CollectionsService {
    
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
