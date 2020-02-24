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
    
    var response: HTTPURLResponse
    
    init(response: HTTPURLResponse) {
        self.response = response
    }
   
    // MARK: - Data
    
    var exchangeCorrectData: Data? {
        // This variable is used to retrieve the bundle in which the class we are using is located
        let bundle = Bundle(for: FakeResponseRecipe.self)
        
        // This variable is used to get the url of our test json file
        let url = bundle.url(forResource: "Recipe", withExtension: "json")!
        
        // We retrieve the data inside the url
        return try! Data(contentsOf: url)
    }
}
