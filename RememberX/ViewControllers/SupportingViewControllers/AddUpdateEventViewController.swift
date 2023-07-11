//
//  AddUpdateEventViewController.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 17.06.2023.
//

import UIKit

class AddUpdateEventViewController: UIViewController {
    
    
    
    // MARK: - Variables
    
    let viewModel: EventsViewModel
    let eventToUpdate: EventModel?
    let collection: CollectionModel?
    
    
    // MARK: -  UI components
    
    private lazy var eventTitleTextField = CustomTextField(fieldType: .title)
    
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
        barButtonItem.action = #selector(saveEvent)
        return barButtonItem
    }()
    
    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.title = "Cancel"
        barButtonItem.target = self
        barButtonItem.action = #selector(dismissView)
        return barButtonItem
    }()
    
    let segmentItems = ["birthday", "event", "anniversary"]
    
    private lazy var eventTypeSegmentControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: segmentItems.map({ $0.capitalized }))
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    // EventDatePicker StackView
    
    private lazy var eventDatePickerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let eventDatePickerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = "Date: "
        return label
    }()
    
    private lazy var eventDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    
    // MARK: -  Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    init(viewModel: EventsViewModel, eventToUpdate: EventModel? = nil, collection: CollectionModel? = nil) {
        self.viewModel = viewModel
        self.eventToUpdate = eventToUpdate
        self.collection = collection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -  UI Setup
    
    
    private func setupUI() {
        self.view.addSubview(eventTypeSegmentControl)
        self.view.addSubview(eventTitleTextField)
        self.view.addSubview(informationLabel)
        self.view.addSubview(informationFieldView)
        self.view.addSubview(eventDatePickerStackView)
        
        eventDatePickerStackView.addArrangedSubview(eventDatePickerLabel)
        eventDatePickerStackView.addArrangedSubview(eventDatePicker)
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.topItem?.title = eventToUpdate == nil ? "Add" : "Update"
        navigationController?.navigationBar.topItem?.rightBarButtonItem = saveBarButtonItem
        navigationController?.navigationBar.topItem?.leftBarButtonItem = cancelBarButtonItem
        
        let tapGestureBackground = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped(_:)))
        self.view.addGestureRecognizer(tapGestureBackground)
        
        NSLayoutConstraint.activate([
            
            eventTypeSegmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            eventTypeSegmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            eventTypeSegmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            eventTitleTextField.topAnchor.constraint(equalTo: eventTypeSegmentControl.bottomAnchor, constant: 16),
            eventTitleTextField.leadingAnchor.constraint(equalTo: eventTypeSegmentControl.leadingAnchor),
            eventTitleTextField.trailingAnchor.constraint(equalTo: eventTypeSegmentControl.trailingAnchor),
            eventTitleTextField.heightAnchor.constraint(equalToConstant: 50),

            informationLabel.topAnchor.constraint(equalTo: eventTitleTextField.bottomAnchor, constant: 16),
            informationLabel.leadingAnchor.constraint(equalTo: eventTypeSegmentControl.leadingAnchor),
            informationLabel.trailingAnchor.constraint(equalTo: eventTypeSegmentControl.trailingAnchor),

            informationFieldView.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 16),
            informationFieldView.leadingAnchor.constraint(equalTo: eventTypeSegmentControl.leadingAnchor),
            informationFieldView.trailingAnchor.constraint(equalTo: eventTypeSegmentControl.trailingAnchor),
            informationFieldView.heightAnchor.constraint(equalToConstant: 120),

            eventDatePickerStackView.topAnchor.constraint(equalTo: informationFieldView.bottomAnchor, constant: 16),
            eventDatePickerStackView.leadingAnchor.constraint(equalTo: eventTypeSegmentControl.leadingAnchor),
            eventDatePickerStackView.trailingAnchor.constraint(equalTo: eventTypeSegmentControl.trailingAnchor),
            eventDatePickerLabel.widthAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    
    // MARK: -  Selectors
    
    @objc func backgroundTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func saveEvent() {
        guard let eventTitle = eventTitleTextField.text else { return }
        Task {
            do {
                try await self.viewModel.createEvent(inCollection: collection, withTitle: eventTitle, andInformation: informationFieldView.text, andDate: eventDatePicker.date)
                self.dismiss(animated: true)
            } catch let error {
                print(error)
            }
        }
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
}


    // MARK: - UIPickerView

//extension AddUpdateEventViewController: UIPickerViewDataSource, UIPickerViewDelegate {
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        TimerEnum.allCases.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return TimerEnum.allCases[row].rawValue
//    }
//
//
//}
