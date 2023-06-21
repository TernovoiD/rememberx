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
    
    func configure(collection: CollectionModel) {
        collectionTitleLabel.text = collection.title
        
        contentView.addSubview(collectionImage)
        contentView.addSubview(collectionTitleLabel)
        
        
        NSLayoutConstraint.activate([
            
            collectionImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            collectionImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collectionImage.heightAnchor.constraint(equalToConstant: 70),
            collectionImage.widthAnchor.constraint(equalToConstant: 80),
            
            collectionTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            collectionTitleLabel.leadingAnchor.constraint(equalTo: collectionImage.trailingAnchor, constant: 16),
            collectionTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
}
