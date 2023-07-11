//
//  ProfileViewController.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 20.06.2023.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    
    
    
    // MARK: - Variables
    let viewModel: AuthenticationViewModel
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: -  UI components
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.text = "Error"
        return label
    }()
    
    private lazy var signOutBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.title = "Log out"
        barButtonItem.target = self
        barButtonItem.action = #selector(signOut)
        return barButtonItem
    }()
    
    let changePasswordButton = CustomButton(title: "Change password", color: .systemBlue, fontSize: .medium, textColor: .white)
    let deleteAccountButton = CustomButton(title: "Delete account", color: .systemRed, fontSize: .medium, textColor: .white)
    
    private lazy var accountDeleteAlert: UIAlertController = {
        let alert = UIAlertController(
            title: "Are you sure you want to delete your account?",
            message: "This action will permanently delete your account and the collections you've created. This action cannot be undone.",
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(
            title: "DELETE",
            style: .destructive,
            handler: { _ in
                self.deleteAccount()
            }))
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel))
        return alert
    }()
    
    
    // MARK: -  Lifecycle
    
    init(viewModel: AuthenticationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    
    // MARK: -  UI Setup
    
    
    private func setupUI() {
        self.view.addSubview(profileImage)
        self.view.addSubview(usernameLabel)
        self.view.addSubview(changePasswordButton)
        self.view.addSubview(deleteAccountButton)
        
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = signOutBarButtonItem
        
        changePasswordButton.addTarget(self, action: #selector(showChangePasswordVC), for: .touchUpInside)
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountAlert), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 200),
            profileImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 16),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            changePasswordButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            changePasswordButton.bottomAnchor.constraint(equalTo: deleteAccountButton.topAnchor, constant: -16),
            changePasswordButton.heightAnchor.constraint(equalToConstant: 50),
            changePasswordButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            
            deleteAccountButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            deleteAccountButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            deleteAccountButton.heightAnchor.constraint(equalToConstant: 50),
            deleteAccountButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
        ])
    }
    
    private func setupBindings() {
        viewModel.$userInfo
            .receive(on: DispatchQueue.main)
            .sink { user in
                self.usernameLabel.text = user?.username
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: -  Selectors
    
    @objc func signOut() {
        viewModel.signOut()
    }
    
    @objc func deleteAccountAlert() {
        present(accountDeleteAlert, animated: true)
    }
    
    @objc func showChangePasswordVC() {
        navigationController?.pushViewController(ChangePasswordViewController(viewModel: viewModel), animated: true)
    }
    
    func deleteAccount() {
        Task {
            do {
                try await viewModel.deleteUser()
            } catch let error {
                print(error)
            }
        }
    }
}
