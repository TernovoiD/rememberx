//
//  CollectionDetailViewController.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 20.06.2023.
//

import UIKit

class CollectionDetailViewController: UIViewController {
    
    
    
    // MARK: - Variables
    
    let viewModel: EventsViewModel
    let collection: CollectionModel
    var collectionEvents: [EventModel] = []
    
    
    // MARK: -  UI components
    
    private var eventsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 80
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.cellID)
        return tableView
    }()
    
    
    
    // MARK: -  Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    init(viewModel: EventsViewModel, collection: CollectionModel) {
        self.viewModel = viewModel
        self.collection = collection
        
        if let events = collection.events {
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
        
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            eventsTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            eventsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            eventsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            eventsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    
    // MARK: -  Selectors
    
    
    
}

extension CollectionDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        collectionEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventsTableView.dequeueReusableCell(withIdentifier: EventTableViewCell.cellID, for: indexPath) as! EventTableViewCell
        let event = collectionEvents[indexPath.row]
        cell.configure(event: event)
        cell.selectionStyle = .none
        return cell
    }
}
