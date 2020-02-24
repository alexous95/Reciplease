//
//  NetworkProtocol.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 22/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkService {
    func request(foodList: [String], from: Int, to: Int, completion: @escaping (DataResponse<Any, AFError>) -> Void)
}
