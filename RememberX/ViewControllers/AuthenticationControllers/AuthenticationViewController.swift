//
//  AuthenticationViewController.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 03.06.2023.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    // MARK: - Variables
    
    let authViewModel: AuthenticationViewModel
    
    
    // MARK: -  UI components
    
    private let headerView = AuthHeaderView(title: "Sign in", subtitle: "Sign in to your account", image: "person.circle")
    private let userEmailField = CustomTextField(fieldType: .email)
    private let userPasswordField = CustomTextField(fieldType: .password)
    private let signInButton = CustomButton(title: "Sign In", color: .systemBlue, fontSize: .medium, textColor: .white)
    private let createNewAccountButton = CustomButton(title: "Don't have an account? Create", color: .clear, fontSize: .small, textColor: .systemBlue)
    private let forgotPasswordButton = CustomButton(title: "Forgot password? Reset", color: .clear, fontSize: .small, textColor: .systemBlue)
    
    let alertController: UIAlertController = {
        let alert = UIAlertController(title: "Title", message: "message", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        return alert
    }()
    
    
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
        self.navigationController?.navigationBar.isHidden = true
        let tapGestureBackground = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped(_:)))
        self.view.addGestureRecognizer(tapGestureBackground)
    }
    
    
    // MARK: -  UI Setup
    
    private func setupUI() {
        self.view.addSubview(headerView)
        self.view.addSubview(userEmailField)
        self.view.addSubview(userPasswordField)
        self.view.addSubview(signInButton)
        self.view.addSubview(createNewAccountButton)
        self.view.addSubview(forgotPasswordButton)
        
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        createNewAccountButton.addTarget(self, action: #selector(createNewAccountButtonDidTap), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(resetPasswordButtonDidTap), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 220),
            
            userEmailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            userEmailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            userEmailField.heightAnchor.constraint(equalToConstant: 50),
            userEmailField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            
            userPasswordField.topAnchor.constraint(equalTo: userEmailField.bottomAnchor, constant: 10),
            userPasswordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            userPasswordField.heightAnchor.constraint(equalTo: userEmailField.heightAnchor),
            userPasswordField.widthAnchor.constraint(equalTo: userEmailField.widthAnchor),
            
            signInButton.topAnchor.constraint(equalTo: userPasswordField.bottomAnchor, constant: 10),
            signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            signInButton.heightAnchor.constraint(equalTo: userEmailField.heightAnchor),
            signInButton.widthAnchor.constraint(equalTo: userEmailField.widthAnchor),
            
            createNewAccountButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 25),
            createNewAccountButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: createNewAccountButton.bottomAnchor, constant: 10),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
        ])
    }
    
    
    // MARK: -  Selectors
    
    @objc func backgroundTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func createNewAccountButtonDidTap() {
        self.navigationController?.pushViewController(AccountRegisterViewController(authViewModel: authViewModel), animated: true)
    }
    
    @objc func resetPasswordButtonDidTap() {
        self.navigationController?.pushViewController(PasswordResetViewController(viewModel: authViewModel, alertController: alertController), animated: true)
    }
    
    @objc func didTapSignInButton() {
        guard let userEmail = userEmailField.text,
              let userPassword = userPasswordField.text else { return }
        if userEmail == "" || userPassword == "" {
            alertController.title = "Error"
            alertController.message = "Field cannot be empty"
            self.present(alertController, animated: true)
            return
        }
        signIn(email: userEmail, password: userPassword)
    }
    
    private func signIn(email: String, password: String) {
        Task {
            do {
                try await authViewModel.loginUser(withEmail: email, andPassword: password)
            } catch HTTPError.notAuthorized {
                alertController.title = "Error"
                alertController.message = "error.localizedDescription"
                self.present(alertController, animated: true)
            } catch let error {
                alertController.title = "Error"
                alertController.message = error.localizedDescription
                self.present(alertController, animated: true)
            }
        }
    }
}
