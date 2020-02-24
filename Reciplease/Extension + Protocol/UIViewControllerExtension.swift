//
//  UIViewControllerExtension.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 24/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String?, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: completion)
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}
