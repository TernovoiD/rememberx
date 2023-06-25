//
//  EventTableViewCell.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 13.06.2023.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    
    
    // MARK: - Variables
    
    static let cellID = "EventTableViewCell"
    
    
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
    
    private var collectionNameTag: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Error"
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        label.backgroundColor = .systemGray2
        return label
    }()
    
    
    // MARK: -  UI Setup
    
    func configure(event: EventModel) {
        
        let encounter = DaysEncounterStackView(daysToShow: event.daysTo, textToShow: event.daysToDescription)
        addSubview(eventLabel)
        addSubview(collectionNameTag)
        addSubview(infoLabel)
        addSubview(encounter)
        
        eventLabel.text = event.title
        infoLabel.text = event.information
        
        if let text = event.collectionName {
            collectionNameTag.text = " " + text
        } else {
            collectionNameTag.text = ""
        }
        
        
        NSLayoutConstraint.activate([
            encounter.centerYAnchor.constraint(equalTo: centerYAnchor),
            encounter.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            encounter.heightAnchor.constraint(equalToConstant: 70),
            encounter.widthAnchor.constraint(equalToConstant: 80),
            
            eventLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            eventLabel.leadingAnchor.constraint(equalTo: encounter.trailingAnchor, constant: 16),
            eventLabel.trailingAnchor.constraint(equalTo: collectionNameTag.leadingAnchor, constant: -10),
            
            collectionNameTag.centerYAnchor.constraint(equalTo: eventLabel.centerYAnchor),
//            collectionNameTag.widthAnchor.constraint(lessThanOrEqualToConstant: 80),
//            collectionNameTag.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            collectionNameTag.widthAnchor.constraint(equalToConstant: 70),
            collectionNameTag.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            infoLabel.topAnchor.constraint(equalTo: eventLabel.bottomAnchor, constant: 2),
            infoLabel.leadingAnchor.constraint(equalTo: eventLabel.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: collectionNameTag.trailingAnchor),
        ])
    }
    
    
    
}
