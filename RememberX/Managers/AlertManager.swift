//
//  AlertManager.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 01.07.2023.
//

import UIKit

class AlertManager {
    
     public static func showAlert(onViewController vc: UIViewController, withTitle title: String, andMassage massage: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismess", style: .cancel))
            vc.present(alert, animated: true)
        }
    }
}
