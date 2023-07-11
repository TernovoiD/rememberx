//
//  ChangePasswordViewController.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 30.06.2023.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    
    
    // MARK: - Variables
    
    let viewModel: AuthenticationViewModel
    
    
    
    // MARK: -  UI components
    
    let headerView = AuthHeaderView(title: "Change password", subtitle: "Change your account password", image: "arrow.triangle.2.circlepath.circle")
    let userPassword = CustomTextField(fieldType: .password)
    let newUserPassword = CustomTextField(fieldType: .newPassword)
    let newUserPasswordConfirm = CustomTextField(fieldType: .newPassword)
    let passwordResetButton = CustomButton(title: "Save", color: .systemBlue, fontSize: .medium, textColor: .white)
    
    
    // MARK: -  Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .systemBackground
        let tapGestureBackground = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped(_:)))
        self.view.addGestureRecognizer(tapGestureBackground)
    }
    
    init(viewModel: AuthenticationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -  UI Setup
    
    private func setupUI() {
        self.view.addSubview(headerView)
        self.view.addSubview(userPassword)
        self.view.addSubview(newUserPassword)
        self.view.addSubview(newUserPasswordConfirm)
        self.view.addSubview(passwordResetButton)
        
        passwordResetButton.addTarget(self, action: #selector(didTapPasswordResetButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 220),
            
            userPassword.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            userPassword.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            userPassword.heightAnchor.constraint(equalToConstant: 50),
            userPassword.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            
            newUserPassword.topAnchor.constraint(equalTo: userPassword.bottomAnchor, constant: 16),
            newUserPassword.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            newUserPassword.heightAnchor.constraint(equalToConstant: 50),
            newUserPassword.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            
            newUserPasswordConfirm.topAnchor.constraint(equalTo: newUserPassword.bottomAnchor, constant: 16),
            newUserPasswordConfirm.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            newUserPasswordConfirm.heightAnchor.constraint(equalToConstant: 50),
            newUserPasswordConfirm.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            
            passwordResetButton.topAnchor.constraint(equalTo: newUserPasswordConfirm.bottomAnchor, constant: 10),
            passwordResetButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            passwordResetButton.heightAnchor.constraint(equalTo: newUserPasswordConfirm.heightAnchor),
            passwordResetButton.widthAnchor.constraint(equalTo: newUserPasswordConfirm.widthAnchor),
        ])
    }
    
    
    
    // MARK: -  Selectors
    
    @objc func backgroundTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func signInButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapPasswordResetButton() {
        Task {
            do {
                let password = userPassword.text ?? ""
                let newPassword = newUserPassword.text ?? ""
                let newPasswordConfirm = newUserPasswordConfirm.text ?? "error"

                try await viewModel.changePassword(userPassword: password,
                                                   newPassword: newPassword,
                                                   newPasswordConfirm: newPasswordConfirm)
                let cgColor = CGColor(red: 10.0/255.0, green: 160.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                headerView.tintColor = UIColor(cgColor: cgColor)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.navigationController?.popViewController(animated: true)
                }
            } catch let error {
                headerView.tintColor = .systemRed
                print(error)
            }
        }
    }
    
    
    

}
