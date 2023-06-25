//
//  CollectionTableViewCell.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 05.06.2023.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {
    
    static let cellID = "CollectionTableViewCell"
    
    private var collectionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "folder.fill")
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
    
    private let eventsNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Error"
        return label
    }()
    
    private var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.sizeToFit()
        return imageView
    }()
    
    func configure(collection: CollectionModel) {
        collectionTitleLabel.text = collection.title
        
        contentView.addSubview(collectionImage)
        contentView.addSubview(collectionTitleLabel)
        contentView.addSubview(eventsNumberLabel)
        contentView.addSubview(arrowImageView)
        
        eventsNumberLabel.text = defineEventsNumberLabelText(numberOfEvents: collection.events?.count)
        
        NSLayoutConstraint.activate([
            
            collectionImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            collectionImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collectionImage.heightAnchor.constraint(equalToConstant: 45),
            collectionImage.widthAnchor.constraint(equalToConstant: 55),
            
            collectionTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            collectionTitleLabel.leadingAnchor.constraint(equalTo: collectionImage.trailingAnchor, constant: 16),
            collectionTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            eventsNumberLabel.topAnchor.constraint(equalTo: collectionTitleLabel.bottomAnchor),
            eventsNumberLabel.leadingAnchor.constraint(equalTo: collectionTitleLabel.leadingAnchor),
            eventsNumberLabel.trailingAnchor.constraint(equalTo: collectionTitleLabel.trailingAnchor),
            
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            arrowImageView.heightAnchor.constraint(equalToConstant: 30),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20)
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
