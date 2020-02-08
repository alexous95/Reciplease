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

}
