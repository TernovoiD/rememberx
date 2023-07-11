//
//  CustomButton.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 03.06.2023.
//

import UIKit

class CustomButton: UIButton {
    
    enum FontSize {
        case big
        case medium
        case small
    }
    
    init(title: String, color: UIColor, fontSize: FontSize, textColor: UIColor) {
        super.init(frame: .zero)
        
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.backgroundColor = color
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 8
        
        switch fontSize {
        case .big:
            self.titleLabel?.font = .systemFont(ofSize: 26, weight: .bold)
        case .medium:
            self.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        case .small:
            self.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
