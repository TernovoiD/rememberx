//
//  ManageCollectionsViewController.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 26.06.2023.
//

import UIKit
import Combine

class ManageCollectionsViewController: UIViewController {
    
    
    
    // MARK: - Variables
    let manageCollectionsVM: ManageCollectionsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: -  UI components
    
    
    private var publicCollectionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SubscriptionTableViewCell.self, forCellReuseIdentifier: SubscriptionTableViewCell.cellID)
        tableView.rowHeight = 60
        return tableView
    }()
    
    // MARK: -  Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    init(manageCollectionsVM: ManageCollectionsViewModel) {
        self.manageCollectionsVM = manageCollectionsVM
        super.init(nibName: nil, bundle: nil)
        manageCollectionsVM.fetchCollections()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -  UI Setup
    
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Subscriptions"
        
        view.addSubview(publicCollectionsTableView)
        publicCollectionsTableView.dataSource = self
        publicCollectionsTableView.delegate = self
        
        
        NSLayoutConstraint.activate([
            publicCollectionsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            publicCollectionsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            publicCollectionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            publicCollectionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupBindings() {
        manageCollectionsVM.$collections
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.publicCollectionsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: -  Selectors
    
    @objc func didTapSubscribeButton(_ sender: UIButton) {
        print(sender.tag)
    }

}

extension ManageCollectionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manageCollectionsVM.collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubscriptionTableViewCell.cellID, for: indexPath) as! SubscriptionTableViewCell
        let collection = manageCollectionsVM.collections[indexPath.row]
        cell.configure(collection: collection)
        cell.selectionStyle = .none
        cell.subscribeButton.tag = indexPath.row
        cell.subscribeButton.addTarget(self, action: #selector(didTapSubscribeButton), for: .touchUpInside)
        return cell
    }
    
    
}
