//
//  AuthenticationService.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 04.06.2023.
//

import Foundation
import Combine

class AuthenticationService {
    
    private lazy var authenticationStatusChangeSubject = PassthroughSubject<Void, Never>()
    lazy var authenticationStatusChangePublisher = authenticationStatusChangeSubject.eraseToAnyPublisher()
    
    let authManager: AuthorizationManager
    let httpManager: HTTPManager
    let dataCoder: JSONDataCoder
    
    @Published var authenticatedUser: UserModel?
    
    init(authManager: AuthorizationManager, httpManager: HTTPManager, dataCoder: JSONDataCoder) {
        self.authManager = authManager
        self.httpManager = httpManager
        self.dataCoder = dataCoder
        self.authenticatedUser = nil
        
        Task {
            do {
                try await fetchUser()
            } catch let error {
                print(error)
            }
        }
    }
    
    func register(user: UserModel) async throws -> UserModel {
        let encodedUserData = try dataCoder.encodeItemToData(item: user)
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.userRegister) else {
            throw HTTPError.badURL
        }
        let (data, _) = try await httpManager.sendRequest(toURL: url, withData: encodedUserData, withHTTPMethod: HTTPMethods.POST.rawValue)
        
        let user = try dataCoder.decodeItemFromData(data: data) as UserModel
        return user
    }
    
    func signIn(withLogin login: String, andPassword password: String) async throws {
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.userLogin) else {
            throw HTTPError.badURL
        }
        let basicAuth = createBasicAuthorization(login: login, password: password)
        let (data, response) = try await httpManager.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.POST.rawValue, withbasicAuthorization: basicAuth)
        
        guard let httpResponse = response as? HTTPURLResponse else { throw HTTPError.badResponse }
        if httpResponse.statusCode == 200 {
            let userToken = String(decoding: data, as: UTF8.self)
            authManager.saveToken(userToken)
            try await fetchUser()
        }
    }
    
    func signOut() {
        authManager.deleteToken()
        authenticatedUser = nil
    }
    
    private func fetchUser() async throws {
        guard let userToken = authManager.getToken() else { throw HTTPError.notAuthorized }
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.user) else {
            throw HTTPError.badURL
        }
        let (data, response) = try await httpManager.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.GET.rawValue, withloginToken: userToken)
        guard let httpResponse = response as? HTTPURLResponse else { throw HTTPError.badResponse }
        if httpResponse.statusCode == 200 {
            authenticatedUser = try dataCoder.decodeItemFromData(data: data) as UserModel
        }
        
    }
    
    private func createBasicAuthorization(login: String, password: String) -> String {
        let loginString = String(format: "%@:%@", login, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        return loginData.base64EncodedString()
    }
}
