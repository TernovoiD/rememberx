//
//  MainTabBarViewController.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 04.06.2023.
//

import UIKit
import Combine

class MainTabBarViewController: UITabBarController {
    
    // MARK: - Variables
    
    private var cancellables = Set<AnyCancellable>()
    let authenticationService: AuthenticationService
    var authenticationNavigationController: UINavigationController? = nil
    
    
    // MARK: -  Lifecycle
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize view models
        let eventsViewModel = EventsViewModel(authService: authenticationService)
        
        // Initialize view controllers
        let eventsViewController = EventsViewController(eventsViewModel: eventsViewModel)
        setViewControllers([eventsViewController], animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkUserAuthenticationStatus()
    }
    
    
    // MARK: - Functions
    
    private func setupBindings() {
        authenticationService.$isUserAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.checkUserAuthenticationStatus()
            }
            .store(in: &cancellables)
    }
    
    private func checkUserAuthenticationStatus() {
        if authenticationService.isUserAuthenticated == false {
            showAuthenticationViewController()
        } else {
            hideAuthenticationViewController()
        }
    }
    
    private func showAuthenticationViewController() {
        if let authenticationNavigationController {
            authenticationNavigationController.modalPresentationStyle = .fullScreen
            present(authenticationNavigationController, animated: false)
        } else {
            
            // Initialize authentication controller
            let authViewModel = AuthenticationViewModel(authenticationService: authenticationService)
            let authViewController = AuthenticationViewController(authViewModel: authViewModel)
            let authNavigationController = UINavigationController(rootViewController: authViewController)
            self.authenticationNavigationController = authNavigationController
            
            // Present controller
            authNavigationController.modalPresentationStyle = .fullScreen
            present(authNavigationController, animated: false)
        }
    }
    
    private func hideAuthenticationViewController() {
        if let authenticationNavigationController {
            authenticationNavigationController.dismiss(animated: true)
        }
    }
}
