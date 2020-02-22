//
//  NetworkProtocol.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 22/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation

protocol NetworkService {
    typealias recipeHandler = (Hits?, Bool) -> ()
    func request(foodList: [String], from: Int, to: Int, completion: @escaping recipeHandler)
}
