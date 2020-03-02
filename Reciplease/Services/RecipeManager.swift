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
    
    typealias dataHandler = (Data?, Bool) -> ()
    typealias recipeHandler = (Hits?, Bool) -> ()
    
    private var recipeSession: NetworkService
    
    init(recipeSession: NetworkService = RecipeSession()) {
        self.recipeSession = recipeSession
    }
    
    // MARK: - Private
    
    static func createUrl(foodList: [String], from: Int, to: Int) -> URL? {
        let baseUrl = "https://api.edamam.com/search?q="
        let parameters = foodList
            .compactMap({ (food) -> String? in
                return food.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            })
            .joined(separator: ",")
        let identification = "&app_id=\(APIKey.edamamAppId)&app_key=\(APIKey.edamamKey)"
        let range = "&from=\(from)&to=\(to)"
        
        guard let url = URL(string: baseUrl + parameters + identification + range) else {
            return URL(string: "")
        }
        
        return url
    }
    
    // MARK: - Public
    
    /// Launch a request to the edamam API with some parameters
    /// - Parameter foodList: An array of the ingredient we want in our Recipe
    /// - Parameter completion: A closure of type (Hits?, Bool) -> () to transmit data
    func launchRequest(foodList: [String], from: Int, to: Int, completion: @escaping recipeHandler) {
        recipeSession.request(foodList: foodList, from: from, to: to) { dataResponse in
            guard dataResponse.response?.statusCode == 200 else {
                completion(nil, false)
                return
            }
            guard let data = dataResponse.data else {
                completion(nil, false)
                return
            }
            
            do {
                let hits = try JSONDecoder().decode(Hits.self, from: data)
                completion(hits, true)
            } catch {
                print(error)
                completion(nil, false)
            }
            
        }
    }
    
    /// Launch a request to the edamam API with some parameters
    /// - Parameter url: An URL with the adress of our image
    /// - Parameter completion: A closure of type (Data?, Bool) -> () to transmit data
    func getImage(from url: String, completion: @escaping dataHandler) {
        recipeSession.requestImage(url: url) { (data) in
            guard data.response?.statusCode == 200 else {
                completion(nil, false)
                return
            }
            
            guard let data = data.data else {
                completion(nil, false)
                return
            }
            
            completion(data, true)
        }
    }
}
