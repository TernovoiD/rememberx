//
//  EventsViewController.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 20.06.2023.
//

import UIKit
import Combine

class EventsViewController: UIViewController {
    
    
    
    // MARK: - Variables
    
    let viewModel: EventsViewModel
    var collection: CollectionModel?
    var collectionEvents: [EventModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    
    
    // MARK: -  UI components
    
    private var eventsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 80
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.cellID)
        return tableView
    }()
    
    private lazy var addEventBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.image = UIImage(systemName: "plus")
        barButtonItem.target = self
        barButtonItem.action = #selector(addNewEventAction)
        return barButtonItem
    }()
    
    
    // MARK: -  Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    init(eventsViewModel: EventsViewModel, collection: CollectionModel? = nil) {
        self.viewModel = eventsViewModel
        self.collection = collection
        if let events = collection?.events {
            self.collectionEvents = events
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -  UI Setup
    
    private func setupUI() {
        self.view.addSubview(eventsTableView)
        
        
        if collection == nil {
            navigationController?.navigationBar.topItem?.title = "Upcoming"
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.topItem?.rightBarButtonItem = addEventBarButtonItem
        } else {
            title = collection?.title
            navigationItem.rightBarButtonItem = addEventBarButtonItem
        }
        
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        
        view.backgroundColor = .systemBackground
        eventsTableView.separatorInset = UIEdgeInsets(top: 0, left: 105, bottom: 0, right: 0)
        
        NSLayoutConstraint.activate([
            eventsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            eventsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            eventsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            eventsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    private func reloadCollection() {
        collection = viewModel.updateCollection(byID: collection?.id)
        if let events = collection?.events {
            self.collectionEvents = events
        }
    }
    
    private func setupBindings() {
        viewModel.$upcomingEvents
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.reloadCollection()
                self.eventsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: -  Selectors
    
    @objc func addNewEventAction() {
        let addUpdateEventVC = AddUpdateEventViewController(viewModel: viewModel, collection: collection)
        let addUpdateEventNC = UINavigationController(rootViewController: addUpdateEventVC)
        present(addUpdateEventNC, animated: true)
    }
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if collection != nil {
            return collectionEvents.count
        } else {
            return viewModel.upcomingEvents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventsTableView.dequeueReusableCell(withIdentifier: EventTableViewCell.cellID, for: indexPath) as! EventTableViewCell
        let event = collection == nil ? viewModel.upcomingEvents[indexPath.row] : collectionEvents[indexPath.row]
        cell.configure(event: event)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let event = collection == nil ? viewModel.upcomingEvents[indexPath.row] : collectionEvents[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (myContext, myView, complete) in
            Task {
                do {
                    try await self.viewModel.deleteEvent(event, fromCollection: self.collection)
                } catch let error {
                    print(error)
                }
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
