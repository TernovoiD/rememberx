//
//  CollectionsService.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 05.06.2023.
//

import Foundation
import Combine

class CollectionsService {
    
    private lazy var collectionsChangeSubject = PassthroughSubject<Void, Never>()
    lazy var collectionsChangePublisher = collectionsChangeSubject.eraseToAnyPublisher()
    
    let authManager: AuthorizationManager
    let httpManager: HTTPManager
    let dataCoder: JSONDataCoder
    
    var userDefaultCollectionID: String? = nil
    @Published var publicCollections: [CollectionModel] = []
    @Published var userCollections: [CollectionModel] = []
    
    init(authManager: AuthorizationManager, httpManager: HTTPManager, dataCoder: JSONDataCoder) {
        self.authManager = authManager
        self.httpManager = httpManager
        self.dataCoder = dataCoder
    }
}
