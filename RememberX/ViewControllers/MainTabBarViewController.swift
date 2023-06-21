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
    let collectionsService: CollectionsService
    var authenticationNavigationController: UINavigationController? = nil
    
    
    // MARK: -  Lifecycle
    
    init(authenticationService: AuthenticationService, collectionsService: CollectionsService) {
        self.authenticationService = authenticationService
        self.collectionsService = collectionsService
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize view models
        let authenticationViewModel = AuthenticationViewModel(authenticationService: authenticationService)
        let eventsViewModel = EventsViewModel(authService: authenticationService, collectionsService: collectionsService)
        let collectionsViewModel = CollectionsViewModel(authService: authenticationService, collectionsService: collectionsService)
        
        // Initialize TabBarItems
        
        let collectionsTabBarItem = UITabBarItem(title: "Collections",
                                                 image: UIImage(systemName: "folder"),
                                                 selectedImage: UIImage(systemName: "folder.fill"))
        
        let upcomingTabBarItem = UITabBarItem(title: "Upcoming",
                                              image: UIImage(systemName: "calendar"),
                                              selectedImage: UIImage(systemName: "calendar.fill"))
        
        let profileTabBarItem = UITabBarItem(title: "Profile",
                                             image: UIImage(systemName: "person"),
                                             selectedImage: UIImage(systemName: "person.fill"))
        
        // Initialize view controllers
        let profileViewController = ProfileViewController(viewModel: authenticationViewModel)
        let collectionsViewController = CollectionsViewController(collectionsViewModel: collectionsViewModel, eventsViewModel: eventsViewModel)
        let eventsViewController = EventsViewController(eventsViewModel: eventsViewModel)
        let upcomingViewController = UpcomingViewController(eventsViewModel: eventsViewModel)
        
        // Set TabBarItems
        profileViewController.tabBarItem = profileTabBarItem
        collectionsViewController.tabBarItem = collectionsTabBarItem
        upcomingViewController.tabBarItem = upcomingTabBarItem
        eventsViewController.tabBarItem = upcomingTabBarItem
        
        
        // Initialize navigation controllers
        let profileNC = UINavigationController(rootViewController: profileViewController)
        let collectionsNC = UINavigationController(rootViewController: collectionsViewController)
        let upcomingNC = UINavigationController(rootViewController: upcomingViewController)
        let eventsNC = UINavigationController(rootViewController: eventsViewController)
        
        self.viewControllers = [collectionsNC, eventsNC, profileNC]
    }
    
    
    // MARK: - Functions
    
    private func setupBindings() {
        authenticationService.$authenticatedUser
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.checkUserAuthenticationStatus()
            }
            .store(in: &cancellables)
    }
    
    private func checkUserAuthenticationStatus() {
        if authenticationService.authenticatedUser == nil {
            showAuthenticationViewController()
        } else {
            hideAuthenticationViewController()
            Task {
                do {
                    try await collectionsService.fetchUserCollections()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
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
