//
//  NetworkProtocol.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 22/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation
import Alamofire

/// Requirements to make call to an API
///
/// All classes making API call must implement this protocol.
/// This is useful to test our network call with a mock
protocol NetworkService {
    func request(foodList: [String], from: Int, to: Int, completion: @escaping (DataResponse<Any, AFError>) -> Void)
    func requestImage(url: String, completion: @escaping (AFDataResponse<Data>) -> Void)
}
