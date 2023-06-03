//
//  AuthHeaderView.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 02.06.2023.
//

import UIKit

class AuthHeaderView: UIView {
    
    // MARK: -  UI components
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowRadius = 3
        imageView.layer.shouldRasterize = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    // MARK: -  Lifecycle
    
    init(title: String, subtitle: String, image: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.logoImage.image = UIImage(systemName: image)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: -  UI Setup
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logoImage)
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            self.logoImage.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -5),
            self.logoImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.logoImage.heightAnchor.constraint(equalToConstant: 90),
            self.logoImage.widthAnchor.constraint(equalTo: logoImage.heightAnchor),
            
            self.titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            self.subtitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            self.subtitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.subtitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.subtitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
}
