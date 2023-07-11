//
//  CollectionEventTableViewCell.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 27.06.2023.
//

import UIKit

class CollectionEventTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    
    static let cellID = "CollectionEventTableViewCell"
    
    
    // MARK: -  UI components
    
    private var eventLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = "Error"
        return label
    }()
    
    private var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = ""
        return label
    }()
    
    private var eventDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.text = "Error"
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        label.backgroundColor = .systemGray2
        return label
    }()
    
    
    // MARK: -  UI Setup
    
    func configure(event: EventModel) {
        
        addSubview(eventLabel)
        addSubview(eventDateLabel)
        addSubview(infoLabel)
        
        infoLabel.text = event.information
        
        eventLabel.text = event.title
        eventDateLabel.text = event.dateTime.formatted(date: .numeric, time: .omitted)
        
        
        NSLayoutConstraint.activate([
            
            eventLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            eventLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            eventLabel.trailingAnchor.constraint(equalTo: eventDateLabel.leadingAnchor, constant: -10),
            
            eventDateLabel.centerYAnchor.constraint(equalTo: eventLabel.centerYAnchor),
            eventDateLabel.widthAnchor.constraint(equalToConstant: 70),
            eventDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            infoLabel.topAnchor.constraint(equalTo: eventLabel.bottomAnchor, constant: 2),
            infoLabel.leadingAnchor.constraint(equalTo: eventLabel.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: eventDateLabel.trailingAnchor),
        ])
    }
    
    
    
}
