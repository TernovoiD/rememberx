//
//  EventsViewController.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 02.06.2023.
//

import UIKit

class EventsViewController: UIViewController {
    
    
    
    // MARK: - Variables
    let eventsViewModel: EventsViewModel
    
    
    // MARK: -  UI components
    
    let signOutButton = CustomButton(title: "Sign Out", fontSize: .medium)
    
    
    // MARK: -  Lifecycle
    
    init(eventsViewModel: EventsViewModel) {
        self.eventsViewModel = eventsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemMint
        setupUI()
    }
    
    
    // MARK: -  UI Setup
    
    
    private func setupUI() {
        self.view.addSubview(signOutButton)
        
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            signOutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            signOutButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            signOutButton.heightAnchor.constraint(equalToConstant: 50),
            signOutButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
        ])
    }
    
    
    // MARK: -  Selectors
    
    @objc func signOut() {
        eventsViewModel.signOut()
    }
    
    
    
}
