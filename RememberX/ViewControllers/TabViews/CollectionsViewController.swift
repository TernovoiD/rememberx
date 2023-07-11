//
//  CollectionsViewController.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 05.06.2023.
//

import UIKit
import Combine

class CollectionsViewController: UIViewController {
    
    
    
    // MARK: - Variables
    let subscriptionsViewModel: SubscriptionsViewModel
    let collectionsViewModel: CollectionsViewModel
    let eventsViewModel: EventsViewModel
    private var cancellables = Set<AnyCancellable>()
    var collectionsToShow: [CollectionModel] = []
    
    
    // MARK: -  UI components
    
    private var collectionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 60
        tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.cellID)
        return tableView
    }()
    
    private lazy var createCollectionBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.image = UIImage(systemName: "plus")
        barButtonItem.target = self
        barButtonItem.action = #selector(didTapCreateCollectionButton)
        return barButtonItem
    }()
    
    private lazy var manageCollectionsBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.title = "Subscriptions"
        barButtonItem.target = self
        barButtonItem.action = #selector(didTapManageButton)
        return barButtonItem
    }()
    
    
    // MARK: -  Lifecycle
    
    init(collectionsViewModel: CollectionsViewModel, eventsViewModel: EventsViewModel, manageCollectionsViewModel: SubscriptionsViewModel) {
        self.collectionsViewModel = collectionsViewModel
        self.eventsViewModel = eventsViewModel
        self.subscriptionsViewModel = manageCollectionsViewModel
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
        self.view.addSubview(collectionsTableView)
        
        navigationController?.navigationBar.topItem?.title = "Collections"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.rightBarButtonItem = createCollectionBarButtonItem
        navigationController?.navigationBar.topItem?.leftBarButtonItem = manageCollectionsBarButtonItem
        view.backgroundColor = .systemBackground
        collectionsTableView.separatorInset = UIEdgeInsets(top: 0, left: 87, bottom: 0, right: 0)
        
        collectionsTableView.dataSource = self
        collectionsTableView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupBindings() {
        collectionsViewModel.$collections
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.filterCollections()
                self.collectionsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func filterCollections() {
        collectionsToShow = collectionsViewModel.collections.filter({ $0.type != CollectionTypeEnum.defaultCollection.rawValue })
    }
    
    // MARK: -  Selectors
    
    @objc func didTapCreateCollectionButton() {
        let addUpdateCollectionNC = UINavigationController(rootViewController: AddUpdateCollectionViewController(viewModel: collectionsViewModel))
        present(addUpdateCollectionNC, animated: true)
    }
    
    @objc func didTapManageButton() {
        navigationController?.pushViewController(SubscriptionsViewController(manageCollectionsVM: subscriptionsViewModel), animated: true)
    }
    
}

extension CollectionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        collectionsToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.cellID, for: indexPath) as! CollectionTableViewCell
        let collection = collectionsToShow[indexPath.row]
        cell.configure(collection: collection)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collection = collectionsToShow[indexPath.row]
        let collectionEventsVC = CollectionEventsViewController(eventsViewModel: eventsViewModel, collection: collection)
        navigationController?.pushViewController(collectionEventsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let collection = collectionsToShow [indexPath.row]
        
        if collection.userRelation == UserRelationToCollection.owner.rawValue {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (myContext, myView, complete) in
                Task {
                    do {
                        try await self.collectionsViewModel.deleteCollection(collection: collection)
                    } catch let error {
                        print(error)
                    }
                }
            }
            return UISwipeActionsConfiguration(actions: [deleteAction])
        } else {
            let unsubscribeAction = UIContextualAction(style: .normal, title: "Unsubscribe") { (myContext, myView, complete) in
                Task {
                    do {
                        try await self.collectionsViewModel.unSubscribe(fromCollection: collection)
                    } catch let error {
                        print(error)
                    }
                }
            }
            return UISwipeActionsConfiguration(actions: [unsubscribeAction])
        }
    }
}
