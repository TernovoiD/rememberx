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
    
    private var daysToEventLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemGray4
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.text = "00x99"
        return label
    }()
    
    private var eventLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .bold)
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
    
    
    // MARK: -  UI Setup
    
    func configure(event: EventModel) {
        daysToEventLabel.text = "123"
        eventLabel.text = event.title
        infoLabel.text = event.information
        
        
        addSubview(daysToEventLabel)
        addSubview(eventLabel)
        addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            
            daysToEventLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            daysToEventLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            daysToEventLabel.heightAnchor.constraint(equalToConstant: 70),
            daysToEventLabel.widthAnchor.constraint(equalToConstant: 80),
            
            eventLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            eventLabel.leadingAnchor.constraint(equalTo: daysToEventLabel.trailingAnchor, constant: 16),
            eventLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            infoLabel.topAnchor.constraint(equalTo: eventLabel.bottomAnchor),
            
            infoLabel.leadingAnchor.constraint(equalTo: eventLabel.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: eventLabel.trailingAnchor),
        ])
    }
    
    
    
}
