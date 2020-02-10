//
//  DirectionsController.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 08/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import UIKit

class DirectionsController: UIViewController {

    var directions: [String]?
    
    @IBOutlet weak var directionList: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        addDirections()
    }
  
    private func addDirections() {
        print("on est la")
        guard let directions = directions else { return }
        
        for direction in directions {
            print(direction)
            directionList.text += "-" + direction + "\n"
        }
    }
    
    private func setupBackground() {
        guard let startColor = UIColor(named: "StartBackground") else { return }
        guard let endColor = UIColor(named: "EndBackground") else { return }
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }

}
