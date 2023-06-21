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
    
    
    let signOutButton = CustomButton(title: "Sign Out", fontSize: .medium)
    
    
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
        self.view.addSubview(signOutButton)
        
        view.backgroundColor = .systemBackground
        
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 200),
            profileImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 16),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            signOutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            signOutButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            signOutButton.heightAnchor.constraint(equalToConstant: 50),
            signOutButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
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
    
    
    
}
