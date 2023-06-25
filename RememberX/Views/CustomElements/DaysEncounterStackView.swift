//
//  DaysEncounterStackView.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 25.06.2023.
//

import UIKit

class DaysEncounterStackView: UIStackView {
    
    private var daysToEventLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "x99"
        return label
    }()
    
    private var daysTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "Error"
        return label
    }()

    init(daysToShow: Int, textToShow: String) {
        super.init(frame: .zero)
        
        switch daysToShow {
        case 0:
            let cgColor = CGColor(red: 10.0/255.0, green: 160.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            self.backgroundColor = UIColor(cgColor: cgColor)
            daysToEventLabel.text = ""
            daysTextLabel.text = "Today!"
        case ...30:
            self.backgroundColor = .orange
            daysToEventLabel.text = String(daysToShow) + " D"
            daysTextLabel.text = ""
        default:
            self.backgroundColor = .systemGray4
            daysToEventLabel.text = String(daysToShow) + " D"
            daysTextLabel.text = ""
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        self.alignment = .center
        self.axis = .vertical
        self.spacing = 1
        
        self.addArrangedSubview(daysToEventLabel)
        self.addArrangedSubview(daysTextLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
