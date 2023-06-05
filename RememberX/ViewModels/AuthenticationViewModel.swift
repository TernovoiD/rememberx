//
//  AuthenticationViewModel.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 01.06.2023.
//

import Foundation
import Combine

class AuthenticationViewModel {
    
    let authenticationService: AuthenticationService
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    func createUser(withUsername username: String, andEmail email: String, andPassword password: String, andPasswordRepeat passwordRepeat: String) async throws -> UserModel {
        let newUserRegistrationModel = UserRegistrationModel(username: username, email: email, password: password, passwordRepeat: passwordRepeat)
        let user = try await authenticationService.register(user: newUserRegistrationModel)
        return user
    }
    
    func loginUser(withEmail email: String, andPassword password: String) async throws {
        try await authenticationService.signIn(withLogin: email, andPassword: password)
    }
    
}
