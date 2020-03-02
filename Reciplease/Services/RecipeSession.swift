//
//  RecipeSession.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 22/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation
import Alamofire

class RecipeSession: NetworkService {
    
    func request(foodList: [String], from: Int, to: Int, completion: @escaping (DataResponse<Any, AFError>) -> Void) {
        guard let url = RecipeManager.createUrl(foodList: foodList, from: from, to: to) else {
            return 
        }
        
        // We use the responseJson methode to get a json file
        // The DataResponse<Any, AFError> match any type of the model we want to use to decode our response
        
        AF.request(url).responseJSON { responseData in
            completion(responseData)
        }
    }
    
    func requestImage(url: String, completion: @escaping (AFDataResponse<Data>) -> Void) {
        guard let url = URL(string: url) else { return }
        
        AF.request(url).responseData { responseData in
            completion(responseData)
        }
    }
    
    
}
