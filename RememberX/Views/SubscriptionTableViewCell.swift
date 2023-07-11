//
//  SubscriptionTableViewCell.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 26.06.2023.
//

import UIKit

class SubscriptionTableViewCell: UITableViewCell {
    
    static let cellID = "SubscriptionTableViewCell"
    
    private var collectionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "photo.circle")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let collectionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "Error"
        return label
    }()
    
    private let collectionInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        label.text = "Error"
        return label
    }()
    
    lazy var subscribeButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Subscribe", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 3
        return button
    }()
    
    func configure(collection: CollectionModel) {
        collectionTitleLabel.text = collection.title
        collectionInfoLabel.text = collection.information ?? "No information"
        
        contentView.addSubview(collectionImage)
        contentView.addSubview(collectionTitleLabel)
        contentView.addSubview(collectionInfoLabel)
        contentView.addSubview(subscribeButton)
        
        NSLayoutConstraint.activate([
            
            collectionImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            collectionImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collectionImage.heightAnchor.constraint(equalToConstant: 45),
            collectionImage.widthAnchor.constraint(equalToConstant: 55),
            
            collectionTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            collectionTitleLabel.leadingAnchor.constraint(equalTo: collectionImage.trailingAnchor, constant: 5),
            collectionTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            collectionInfoLabel.topAnchor.constraint(equalTo: collectionTitleLabel.bottomAnchor),
            collectionInfoLabel.leadingAnchor.constraint(equalTo: collectionTitleLabel.leadingAnchor),
            collectionInfoLabel.trailingAnchor.constraint(equalTo: collectionTitleLabel.trailingAnchor),
            
            subscribeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            subscribeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            subscribeButton.heightAnchor.constraint(equalToConstant: 40),
            subscribeButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 110),
        ])
    }
    
    private func defineEventsNumberLabelText(numberOfEvents: Int?) -> String {
        let number = numberOfEvents ?? 0
        
        switch number {
        case 0:
            return "No events"
        case 1:
            return "Include 1 event"
        default:
            return "Include \(number) events"
        }
    }
}
