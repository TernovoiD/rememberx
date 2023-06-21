//
//  AuthenticationViewModel.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 01.06.2023.
//

import Foundation
import Combine

class AuthenticationViewModel {
    
    private lazy var userInfoChangeSubject = PassthroughSubject<UserModel, Never>()
    lazy var userInfoChangePublisher = userInfoChangeSubject.eraseToAnyPublisher()
    private var cancellables = Set<AnyCancellable>()
    let authenticationService: AuthenticationService
    @Published var userInfo: UserModel?
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
        userInfo = nil
        
        setupBindings()
    }
    
    func createUser(withUsername username: String, andEmail email: String, andPassword password: String, andPasswordRepeat passwordRepeat: String) async throws -> UserModel {
        let newUserRegistrationModel = UserModel(username: username, email: email, password: password, confirmPassword: passwordRepeat)
        let user = try await authenticationService.register(user: newUserRegistrationModel)
        return user
    }
    
    func loginUser(withEmail email: String, andPassword password: String) async throws {
        try await authenticationService.signIn(withLogin: email, andPassword: password)
    }
    
    func signOut() {
        authenticationService.signOut()
    }
    
    func getUserInfo() {
        userInfo = authenticationService.authenticatedUser
        if let userInfo {
            userInfoChangeSubject.send(userInfo)
        }
    }
    
    private func setupBindings() {
        authenticationService.$authenticatedUser
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.getUserInfo()
            }
            .store(in: &cancellables)
    }
}
