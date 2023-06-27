//
//  CollectionEventsViewController.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 27.06.2023.
//

import UIKit
import Combine

class CollectionEventsViewController: UIViewController {
    
    
    // MARK: - Variables
    
    let viewModel: EventsViewModel
    var collection: CollectionModel?
    var collectionEvents: [EventModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    
    
    // MARK: -  UI components
    
    private var eventsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 70
        tableView.register(CollectionEventTableViewCell.self, forCellReuseIdentifier: CollectionEventTableViewCell.cellID)
        return tableView
    }()
    
    private lazy var addEventBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.image = UIImage(systemName: "plus")
        barButtonItem.target = self
        barButtonItem.action = #selector(addNewEventAction)
        return barButtonItem
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .center
        label.backgroundColor = .systemGray5
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.text = "Error"
        return label
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
        
        if collection == nil {
            NSLayoutConstraint.activate([
                eventsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                eventsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                eventsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                eventsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        } else {
            self.view.addSubview(label)
            NSLayoutConstraint.activate([
                eventsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                eventsTableView.bottomAnchor.constraint(equalTo: label.topAnchor),
                eventsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                eventsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                
                label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                label.heightAnchor.constraint(equalToConstant: 50),
            ])
        }
        
    }
    
    private func reloadCollection() {
        collection = viewModel.updateCollection(byID: collection?.id)
        if let events = collection?.events {
            self.collectionEvents = events.sorted(by: { $0.daysTo < $1.daysTo })
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

extension CollectionEventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if collection != nil {
            return collectionEvents.count
        } else {
            return viewModel.upcomingEvents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventsTableView.dequeueReusableCell(withIdentifier: CollectionEventTableViewCell.cellID, for: indexPath) as! CollectionEventTableViewCell
        let event = collection == nil ? viewModel.upcomingEvents[indexPath.row] : collectionEvents[indexPath.row]
        cell.configure(event: event)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let event = collection == nil ? viewModel.upcomingEvents[indexPath.row] : collectionEvents[indexPath.row]
        
        if event.collectionName == nil {
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
        } else {
            return nil
        }
    }
}
