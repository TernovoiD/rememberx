//
//  AccountRegisterViewController.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 03.06.2023.
//

import UIKit

class AccountRegisterViewController: UIViewController {
    
    
    
    // MARK: - Variables
    
    let authViewModel: AuthenticationViewModel
    
    
    // MARK: -  UI components
    
    let headerView = AuthHeaderView(title: "Sign Up", subtitle: "Create new account", image: "person.text.rectangle")
    let usernameField = CustomTextField(fieldType: .username)
    let userEmailField = CustomTextField(fieldType: .email)
    let userPasswordField = CustomTextField(fieldType: .password)
    let userPasswordRepearField = CustomTextField(fieldType: .password)
    let registerButton = CustomButton(title: "Create account", color: .systemBlue, fontSize: .medium, textColor: .white)
    let signInButton = CustomButton(title: "Already have an account? Sign In", color: .clear, fontSize: .small, textColor: .systemBlue)
    
    
    // MARK: -  Lifecycle
    
    init(authViewModel: AuthenticationViewModel) {
        self.authViewModel = authViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupUI()
        
        let tapGestureBackground = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped(_:)))
        self.view.addGestureRecognizer(tapGestureBackground)
    }
    
    
    // MARK: -  UI Setup
    
    
    private func setupUI() {
        self.view.addSubview(headerView)
        self.view.addSubview(usernameField)
        self.view.addSubview(userEmailField)
        self.view.addSubview(userPasswordField)
        self.view.addSubview(userPasswordRepearField)
        self.view.addSubview(registerButton)
        self.view.addSubview(signInButton)
        
        signInButton.addTarget(self, action: #selector(signInButtonDidTap), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 220),
            
            usernameField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            usernameField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            usernameField.heightAnchor.constraint(equalToConstant: 50),
            usernameField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            
            userEmailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 10),
            userEmailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            userEmailField.heightAnchor.constraint(equalTo: usernameField.heightAnchor),
            userEmailField.widthAnchor.constraint(equalTo: usernameField.widthAnchor),
            
            userPasswordField.topAnchor.constraint(equalTo: userEmailField.bottomAnchor, constant: 10),
            userPasswordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            userPasswordField.heightAnchor.constraint(equalTo: usernameField.heightAnchor),
            userPasswordField.widthAnchor.constraint(equalTo: usernameField.widthAnchor),
            
            userPasswordRepearField.topAnchor.constraint(equalTo: userPasswordField.bottomAnchor, constant: 10),
            userPasswordRepearField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            userPasswordRepearField.heightAnchor.constraint(equalTo: usernameField.heightAnchor),
            userPasswordRepearField.widthAnchor.constraint(equalTo: usernameField.widthAnchor),
            
            registerButton.topAnchor.constraint(equalTo: userPasswordRepearField.bottomAnchor, constant: 10),
            registerButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            registerButton.heightAnchor.constraint(equalTo: usernameField.heightAnchor),
            registerButton.widthAnchor.constraint(equalTo: usernameField.widthAnchor),
            
            signInButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 25),
            signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
        ])
    }
    
    
    // MARK: -  Selectors
    
    @objc func backgroundTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func signInButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapRegisterButton() {
        guard let username = usernameField.text,
              let userEmail = userEmailField.text,
              let userPassword = userPasswordField.text,
              let userPasswordRepeat = userPasswordRepearField.text else { return }
        Task {
            do {
                let user = try await authViewModel.createUser(withUsername: username,
                                                              andEmail: userEmail,
                                                              andPassword: userPassword,
                                                              andPasswordRepeat: userPasswordRepeat)
                print(user)
            } catch {
                print("Error: No response")
            }
        }
    }
}
