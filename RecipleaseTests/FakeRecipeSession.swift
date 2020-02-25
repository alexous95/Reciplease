//
//  FakeRecipeSession.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 22/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation
import Alamofire
@testable import Reciplease


class FakeRecipeSession: RecipeSession {

    var fakeResponseRecipe: FakeResponseRecipe
    
    init(fakeResponseRecipe: FakeResponseRecipe) {
        self.fakeResponseRecipe = fakeResponseRecipe
    }
    
    override func request(foodList: [String], from: Int, to: Int, completion: @escaping (DataResponse<Any, AFError>) -> Void) {
        
        let result = Result<Any, AFError>.success("Hello")
        let dataResponse = DataResponse(request: nil, response: fakeResponseRecipe.response, data: fakeResponseRecipe.data, metrics: nil, serializationDuration: 0.5, result: result )
        
        completion(dataResponse)
        
    }
    
    override func requestImage(url: String, completion: @escaping (AFDataResponse<Data>) -> Void) {
        let dummyData = "blabla".data(using: .utf8)
        let result = Result<Data, AFError>.success(dummyData!)
        let dataResponse = AFDataResponse(request: nil, response: fakeResponseRecipe.response, data: fakeResponseRecipe.data, metrics: nil, serializationDuration: 0.5, result: result)
        
        completion(dataResponse)
    }
}

