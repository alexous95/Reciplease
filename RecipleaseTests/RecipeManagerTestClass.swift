//
//  RecipeManagerTestClass.swift
//  RecipleaseTests
//
//  Created by Alexandre Goncalves on 22/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import XCTest
import Alamofire
@testable import Reciplease

class RecipeManagerTestClass: XCTestCase {

    var recipeManagerOK: RecipeManager!
    var fakeRecipeSessionOK: FakeRecipeSession!
    var fakeResponseRecipeOK: FakeResponseRecipe!
    
    var recipeManagerKO: RecipeManager!
    var fakeRecipeSessionKO: FakeRecipeSession!
    var fakeResponseRecipeKO: FakeResponseRecipe!
    
    let responseOK = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: [:])!
    let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: [:])!
    
    override func setUp() {
        fakeResponseRecipeOK = FakeResponseRecipe(response: responseOK)
        fakeRecipeSessionOK = FakeRecipeSession(fakeResponseRecipe: fakeResponseRecipeOK)
        recipeManagerOK = RecipeManager(recipeSession: fakeRecipeSessionOK)
        
        fakeResponseRecipeKO = FakeResponseRecipe(response: responseKO)
        fakeRecipeSessionKO = FakeRecipeSession(fakeResponseRecipe: fakeResponseRecipeKO)
        recipeManagerKO = RecipeManager(recipeSession: fakeRecipeSessionKO)
        
    }

    
    func testGivenIngredientList_WhenCreatingUrl_ThenUrlIsCorrect() {
        
        let ingredient = ["chicken", "pasta", "egg"]
        
        let url = RecipeManager.createUrl(foodList: ingredient, from: 0, to: 2)
        
        XCTAssertTrue(url.absoluteString == "https://api.edamam.com/search?q=chicken,pasta,egg&app_id=ff830871&app_key=437dfce1cdcd0f8db5c6523943729449&from=0&to=2")
        
    }
    
    func testGivenURL_WhenLoadingRecipe_ThenHttpResultIs200() {
        
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        
        fakeRecipeSessionOK.request(foodList: ["chicken"], from: 0, to: 2) { (dataResponse) in
            
            XCTAssert(dataResponse.response?.statusCode == 200)
            expectation.fulfill()
        }
    }
    
    
    func testGivenURL_WhenLoadingFail_ThenHttpResutIs500() {
        
        let expectation = XCTestExpectation(description: "Waiting for callback")
        
        fakeRecipeSessionKO.request(foodList: ["chicken"], from: 0, to: 2) { (dataResponse) in
            
            XCTAssert(dataResponse.response?.statusCode == 500)
            expectation.fulfill()
        }
    }
    
    func testGivenURl_WhenLoadingRecipe_ThenDataIsNotNil() {
        
        let expectation = XCTestExpectation(description: "Waiting for callback")
        
        fakeRecipeSessionOK.request(foodList: ["chicken"], from: 0, to: 2) { (dataResponse) in
            
            XCTAssertNotNil(dataResponse.data)
            expectation.fulfill()
        }
    }
    
    
    func testGivenUrl_WhenLoadingRecipe_ThenResultIsRecipe() {
        
        let expectation = XCTestExpectation(description: "Waiting for callback")
        
        recipeManagerOK.launchRequest(foodList: ["chicken"], from: 0, to: 2) { (hits, success) in
            
            if success {
                XCTAssertTrue(hits?.count == 170158)
                XCTAssertTrue(hits?.hits![0].recipe!.url == "http://www.seriouseats.com/recipes/2011/12/chicken-vesuvio-recipe.html")
                XCTAssertTrue(hits?.hits![0].recipe!.uri == "http://www.edamam.com/ontologies/edamam.owl#recipe_b79327d05b8e5b838ad6cfd9576b30b6")
                XCTAssertTrue(hits?.hits![0].recipe!.label == "Chicken Vesuvio")
                XCTAssertTrue(hits?.hits![0].recipe!.image == "https://www.edamam.com/web-img/e42/e42f9119813e890af34c259785ae1cfb.jpg")
                
                let ingredient = hits?.hits![0].recipe!.ingredients
                
                XCTAssertTrue(ingredient![0].text == "1/2 cup olive oil")
                XCTAssertTrue(ingredient![0].weight == 108.0)
                
                XCTAssertTrue(ingredient![1].text == "5 cloves garlic, peeled")
                XCTAssertTrue(ingredient![1].weight == 15.0)
                
                XCTAssertTrue(ingredient![2].text == "2 large russet potatoes, peeled and cut into chunks")
                XCTAssertTrue(ingredient![2].weight == 738.0)
                
                XCTAssertTrue(ingredient![3].text == "1 3-4 pound chicken, cut into 8 pieces (or 3 pound chicken legs)")
                XCTAssertTrue(ingredient![3].weight == 1587.5732950000001)
                
                XCTAssertTrue(ingredient![4].text == "3/4 cup white wine")
                XCTAssertTrue(ingredient![4].weight == 169.5)
                
                XCTAssertTrue(ingredient![5].text == "3/4 cup chicken stock")
                XCTAssertTrue(ingredient![5].weight == 180.0)
                
                XCTAssertTrue(ingredient![6].text == "3 tablespoons chopped parsley")
                XCTAssertTrue(ingredient![6].weight == 11.399999999999999)
                
                XCTAssertTrue(ingredient![7].text == "1 tablespoon dried oregano")
                XCTAssertTrue(ingredient![7].weight == 5.9999999998985585)
                
                XCTAssertTrue(ingredient![8].text == "Salt and pepper")
                XCTAssertTrue(ingredient![8].weight == 17.696839769999393)
                
                XCTAssertTrue(ingredient![9].text == "Salt and pepper")
                XCTAssertTrue(ingredient![9].weight == 8.848419884999696)
                
                XCTAssertTrue(ingredient![10].text == "1 cup frozen peas, thawed")
                XCTAssertTrue(ingredient![10].weight == 134.0)
                
                expectation.fulfill()
            }
        }
    }
    
    
    func testGivenURL_WhenLoadingFail_ThenRecipeIsNil() {
        
        let expectation = XCTestExpectation(description: "Waiting for callback")
        
        recipeManagerKO.launchRequest(foodList: ["chicken"], from: 0, to: 2) { (hits, success) in
            
            XCTAssertNil(hits)
            expectation.fulfill()
        }
    }

}
