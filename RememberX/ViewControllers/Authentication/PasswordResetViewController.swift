//
//  PasswordResetViewController.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 03.06.2023.
//

import UIKit

class PasswordResetViewController: UIViewController {
    
    
    
    // MARK: - Variables
    
    
    
    // MARK: -  UI components
    
    let headerView = AuthHeaderView(title: "Reset", subtitle: "Reset your account password", image: "lock.circle")
    let userEmailField = CustomTextField(fieldType: .email)
    let passwordResetButton = CustomButton(title: "Reset password", fontSize: .medium)
    let signInButton = CustomButton(title: "Remeber your password? Sign In", hasBackground: false, fontSize: .small)
    
    
    // MARK: -  Lifecycle
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        view.backgroundColor = .systemBackground
        let tapGestureBackground = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped(_:)))
        self.view.addGestureRecognizer(tapGestureBackground)
    }
    
    
    // MARK: -  UI Setup
    
    
    private func setupUI() {
        self.view.addSubview(headerView)
        self.view.addSubview(userEmailField)
        self.view.addSubview(passwordResetButton)
        self.view.addSubview(signInButton)
        
        signInButton.addTarget(self, action: #selector(signInButtonDidTap), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 220),
            
            userEmailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            userEmailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            userEmailField.heightAnchor.constraint(equalToConstant: 50),
            userEmailField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            
            passwordResetButton.topAnchor.constraint(equalTo: userEmailField.bottomAnchor, constant: 10),
            passwordResetButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            passwordResetButton.heightAnchor.constraint(equalTo: userEmailField.heightAnchor),
            passwordResetButton.widthAnchor.constraint(equalTo: userEmailField.widthAnchor),
            
            signInButton.topAnchor.constraint(equalTo: passwordResetButton.bottomAnchor, constant: 25),
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
    
    
    
}
