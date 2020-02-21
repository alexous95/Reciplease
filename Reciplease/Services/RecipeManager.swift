//
//  RecipeManager.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 03/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation
import Alamofire

final class RecipeManager {
    
    typealias recipeHandler = (Hits?, Bool) -> ()
    typealias dataHandler = (Data?, Bool) -> ()
    
    // MARK: - Private
    
    private func createUrl(foodList: [String]) -> URL {
        let baseUrl = "https://api.edamam.com/search?q="
        let parameters = foodList.joined(separator: ",")
        let identification = "&app_id=\(APIKey.edamamAppId)&app_key=\(APIKey.edamamKey)"
        let range = "&from=0&to=20"
        
        let url = URL(string: baseUrl + parameters + identification + range)!
        
        return url
    }
    
    // MARK: - Public
    
    /// Launch a request to the edamam API with some parameters
    /// - Parameter foodList: An array of the ingredient we want in our Recipe
    /// - Parameter completion: A closure of type (Hits?, Bool) -> () to transmit data
    func launchRequest(foodList: [String], completion: @escaping recipeHandler) {
        let url = createUrl(foodList: foodList)
        
        // We use the alamofire request methode to get our information
        // We use the validate methode to insure that our httpresponse code is between 200 and 299
        // We use the responsedecodable methode to use our model which conform to the decodable protocol
        // The AFDataResponse<Hits> match the type of the model we want to use to decode our response
        
        AF.request(url, method: .get).validate().responseDecodable { (response: AFDataResponse<Hits>) in
            guard let newResponse = try? response.result.get() else {
                print(response.error?.errorDescription as Any)
                completion(nil, false)
                return
            }
            completion(newResponse, true)
        }
    }
    
    /// Launch a request to the edamam API with some parameters
    /// - Parameter url: An URL with the adress of our image
    /// - Parameter completion: A closure of type (Data?, Bool) -> () to transmit data
    func getImage(from url: String, completion: @escaping dataHandler) {
        guard let url = URL(string: url) else { return }
        
        AF.request(url, method: .get).validate().responseData { response in
            guard let newResponse = try? response.result.get() else {
                print(response.error?.errorDescription as Any)
                completion(nil, false)
                return
            }
            completion(newResponse, true)
        }
    }
}
