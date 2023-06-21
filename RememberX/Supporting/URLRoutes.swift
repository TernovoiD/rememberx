//
//  URLRoutes.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 04.06.2023.
//

import Foundation

enum BaseRoutes {
    static let baseURL = "https://remember-x-2adf6937d50b.herokuapp.com/"
//    static let baseURL = "http://127.0.0.1:8080/"

}

enum Endpoints {
    static let userCollections = "api/v1/user/collections"
    static let userEvents = "/events"
    static let user = "api/v1/user"
    static let collections = "api/v1/collections"
    static let userRegister = "api/v1/register"
    static let userLogin = "api/v1/login"
}
