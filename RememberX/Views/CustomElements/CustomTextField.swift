//
//  CustomTextField.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 02.06.2023.
//

import UIKit

class CustomTextField: UITextField {
    
    enum CustomTextFieldType {
        case username
        case email
        case password
        case newPassword
        case title
    }
    
    private let fieldType: CustomTextFieldType
    
    init(fieldType: CustomTextFieldType) {
        self.fieldType = fieldType
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 10
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = fieldType == .title ? .sentences : .none
        self.keyboardType = fieldType == .email ? .emailAddress : .default
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.size.height))
        
        switch fieldType {
        case .username:
            self.placeholder = "Username"
        case .email:
            self.placeholder = "Email"
        case .password:
            self.placeholder = "Password"
            self.isSecureTextEntry = true
        case .newPassword:
            self.placeholder = "New password"
            self.isSecureTextEntry = true
        case .title:
            self.placeholder = "Title"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
