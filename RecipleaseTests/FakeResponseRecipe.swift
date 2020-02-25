//
//  FakeResponse.swift
//  RecipleaseTests
//
//  Created by Alexandre Goncalves on 22/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation

class FakeResponseRecipe {
    // MARK: - Error
    
    class RecipeError: Error {}
    static let error = RecipeError()
    
    var response: HTTPURLResponse?
    var data: Data?
    
    init(response: HTTPURLResponse? = nil, data: Data? = nil) {
        self.response = response
        self.data = data
    }
   
}
