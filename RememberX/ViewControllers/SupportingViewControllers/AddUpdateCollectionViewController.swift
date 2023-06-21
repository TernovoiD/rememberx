//
//  AddUpdateCollectionViewController.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 19.06.2023.
//

import UIKit

class AddUpdateCollectionViewController: UIViewController {
    
    // MARK: - Variables
    
    let viewModel: CollectionsViewModel
    let collection: CollectionModel?
    
    
    // MARK: -  UI components
    
    let collectionTitleTextField = CustomTextField(fieldType: .title)
    
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "Additional info: "
        return label
    }()
    
    private lazy var informationFieldView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemGray5
        textView.layer.cornerRadius = 10
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    
    private lazy var saveBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.title = "Save"
        barButtonItem.target = self
        barButtonItem.action = #selector(saveCollection)
        return barButtonItem
    }()
    
    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.title = "Cancel"
        barButtonItem.target = self
        barButtonItem.action = #selector(dismissView)
        return barButtonItem
    }()
    
    
    
    // MARK: -  Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    init(viewModel: CollectionsViewModel, collection: CollectionModel? = nil) {
        self.viewModel = viewModel
        self.collection = collection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -  UI Setup
    
    
    private func setupUI() {
        self.view.addSubview(collectionTitleTextField)
        self.view.addSubview(informationLabel)
        self.view.addSubview(informationFieldView)
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.topItem?.title = collection == nil ? "Add" : "Update"
        navigationController?.navigationBar.topItem?.rightBarButtonItem = saveBarButtonItem
        navigationController?.navigationBar.topItem?.leftBarButtonItem = cancelBarButtonItem
        
        let tapGestureBackground = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped(_:)))
        self.view.addGestureRecognizer(tapGestureBackground)
        
        NSLayoutConstraint.activate([
            collectionTitleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionTitleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionTitleTextField.heightAnchor.constraint(equalToConstant: 50),
            collectionTitleTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            informationLabel.topAnchor.constraint(equalTo: collectionTitleTextField.bottomAnchor, constant: 16),
            informationLabel.leadingAnchor.constraint(equalTo: collectionTitleTextField.leadingAnchor),
            informationLabel.trailingAnchor.constraint(equalTo: collectionTitleTextField.trailingAnchor),
            
            informationFieldView.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 16),
            informationFieldView.leadingAnchor.constraint(equalTo: collectionTitleTextField.leadingAnchor),
            informationFieldView.trailingAnchor.constraint(equalTo: collectionTitleTextField.trailingAnchor),
            informationFieldView.heightAnchor.constraint(equalToConstant: 120),
        ])
    }
    
    
    // MARK: -  Selectors
    
    @objc func backgroundTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func saveCollection() {
        guard let title = collectionTitleTextField.text else { return }
        Task {
            do {
                try await self.viewModel.createCollection(withTitle: title, isPrivate: false)
                dismiss(animated: true)
            } catch let error {
                print(error)
            }
        }
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
    
    
}
