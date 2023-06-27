//
//  UpcomingEventsViewController.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 27.06.2023.
//

import UIKit
import Combine

class UpcomingEventsViewController: UIViewController {
    
    
    
    // MARK: - Variables
    
    let viewModel: EventsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    
    
    // MARK: -  UI components
    
    private var eventsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 80
        tableView.register(UpcomingEventTableViewCell.self, forCellReuseIdentifier: UpcomingEventTableViewCell.cellID)
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
    
    init(eventsViewModel: EventsViewModel) {
        self.viewModel = eventsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -  UI Setup
    
    private func setupUI() {
        self.view.addSubview(eventsTableView)
        
        
        navigationController?.navigationBar.topItem?.title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.rightBarButtonItem = addEventBarButtonItem
        
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        
        view.backgroundColor = .systemBackground
        eventsTableView.separatorInset = UIEdgeInsets(top: 0, left: 110, bottom: 0, right: 0)
        
        NSLayoutConstraint.activate([
            eventsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            eventsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            eventsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            eventsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.$upcomingEvents
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.eventsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: -  Selectors
    
    @objc func addNewEventAction() {
        let addUpdateEventVC = AddUpdateEventViewController(viewModel: viewModel)
        let addUpdateEventNC = UINavigationController(rootViewController: addUpdateEventVC)
        present(addUpdateEventNC, animated: true)
    }
}

extension UpcomingEventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.upcomingEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventsTableView.dequeueReusableCell(withIdentifier: UpcomingEventTableViewCell.cellID, for: indexPath) as! UpcomingEventTableViewCell
        let event = viewModel.upcomingEvents[indexPath.row]
        cell.configure(event: event)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let event = viewModel.upcomingEvents[indexPath.row]
        
        if event.collectionName == nil {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (myContext, myView, complete) in
                Task {
                    do {
                        try await self.viewModel.deleteEvent(event)
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

