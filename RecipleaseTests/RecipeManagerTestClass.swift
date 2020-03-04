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

    var recipeManager: RecipeManager!
    var fakeRecipeSession: FakeRecipeSession!
    
    // This variable holds the data from the Recipe.json file in our bundle (The json with a correct format)
    
    var correctData: Data {
        // This variable is used to retrieve the bundle in which the class we are using is located
        let bundle = Bundle(for: FakeResponseRecipe.self)
        
        // This variable is used to get the url of our test json file
        let url = bundle.url(forResource: "Recipe", withExtension: "json")!
        
        // We retrieve the data inside the url
        return try! Data(contentsOf: url)
    }
    
    // This variable holds the data from the RecipeError.json file in our bundle (The json with an incorrect format)
    
    var errorData: Data {
        let bundle = Bundle(for: FakeResponseRecipe.self)
        let url = bundle.url(forResource: "RecipeError", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    // This two variable are used to simulate the data for the images
    
    var imageData = "10n".data(using: .utf8)
    var imageErreur = "erreur".data(using: .utf8)
    
    // This two response simulate a good and wrong http response from a server
    
    let responseOK = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: [:])
    let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: [:])
    
    override func setUp() {
        fakeRecipeSession = FakeRecipeSession(fakeResponseRecipe: FakeResponseRecipe())
    }

    override func tearDown() {
        super.tearDown()
        fakeRecipeSession = nil
        recipeManager = nil
    }
    
    func testGivenIngredientList_WhenCreatingUrl_ThenUrlIsCorrect() {
        
        // Given
        let ingredient = ["chicken", "pasta", "egg"]
        
        // When
        recipeManager = RecipeManager(recipeSession: fakeRecipeSession)
        guard let url = RecipeManager.createUrl(foodList: ingredient, from: 0, to: 2) else { return }
        
        // Then
        XCTAssertTrue(url.absoluteString == "https://api.edamam.com/search?q=chicken,pasta,egg&app_id=ff830871&app_key=437dfce1cdcd0f8db5c6523943729449&from=0&to=2")
    }
    
    func testGivenURL_WhenLoadingRecipe_ThenHttpResultIs200() {
        
        // Given
        let expectation = XCTestExpectation(description: "Waiting for http response")
        fakeRecipeSession.fakeResponseRecipe.response = responseOK
        
        // When
        fakeRecipeSession.request(foodList: ["chicken"], from: 0, to: 2) { (dataResponse) in
            
            // Then
            XCTAssert(dataResponse.response?.statusCode == 200)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    func testGivenURL_WhenLoadingFail_ThenHttpResutIs500() {
        
        // Given
        let expectation = XCTestExpectation(description: "Waiting for callback")
        fakeRecipeSession.fakeResponseRecipe.response = responseKO
        
        // When
        fakeRecipeSession.request(foodList: ["chicken"], from: 0, to: 2) { (dataResponse) in
            
            // Then
            XCTAssert(dataResponse.response?.statusCode == 500)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGivenURl_WhenLoadingRecipe_ThenDataIsNotNil() {
        
        // Given
        let expectation = XCTestExpectation(description: "Waiting for callback")
        
        // When
        fakeRecipeSession.fakeResponseRecipe.data = correctData
        fakeRecipeSession.request(foodList: ["chicken"], from: 0, to: 2) { (dataResponse) in
            
            guard let data = dataResponse.data else { return }
            XCTAssertNotNil(data)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    func testGivenUrl_WhenLoadingRecipe_ThenDataIsNilIfNoData() {
        
        // Given
        let expectation = XCTestExpectation(description: "Waiting for callback")
        
        // When
        fakeRecipeSession.request(foodList: ["chicken"], from: 0, to: 2) { (dataResponse) in
            
            // Then
            XCTAssert(dataResponse.data == nil)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    func testGivenUrl_WhenLoadingRecipe_ThenResultIsRecipe() {
        
        // Given
        let expectation = XCTestExpectation(description: "Waiting for callback")
        
        // When
        fakeRecipeSession.fakeResponseRecipe.response = responseOK
        fakeRecipeSession.fakeResponseRecipe.data = correctData
        recipeManager = RecipeManager(recipeSession: fakeRecipeSession)
        
        recipeManager.launchRequest(foodList: ["chicken"], from: 0, to: 2) { (hits, success) in
            
            // Then
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
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    func testGivenURL_WhenHttpStatusIs500_ThenRecipeIsNil() {
        
        // Given
        let expectation = XCTestExpectation(description: "Waiting for callback")
        
        // When
        fakeRecipeSession.fakeResponseRecipe.response = responseKO
        recipeManager = RecipeManager(recipeSession: fakeRecipeSession)
        
        recipeManager.launchRequest(foodList: ["chicken"], from: 0, to: 2) { (hits, success) in
        
            // Then
            XCTAssertNil(hits)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    func testGivenURL_WhenStatusIsOkAndNoData_ThenRecipeIsNil() {
        
        // Given
        let expectation = XCTestExpectation(description: "Waiting for callback")
        
        // When
        fakeRecipeSession.fakeResponseRecipe.response = responseOK
        fakeRecipeSession.fakeResponseRecipe.data = nil
        recipeManager = RecipeManager(recipeSession: fakeRecipeSession)
        
        recipeManager.launchRequest(foodList: ["chicken"], from: 0, to: 2) { (hits, success) in
            
            // Then
            XCTAssertNil(hits)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    func testGivenURL_WhenDataStructNotOK_ThenRecipeIsNil() {
        
        // Given
        let expectation = XCTestExpectation(description: "Waiting for callback")
        
        // When
        fakeRecipeSession.fakeResponseRecipe.response = responseOK
        fakeRecipeSession.fakeResponseRecipe.data = errorData
        recipeManager = RecipeManager(recipeSession: fakeRecipeSession)
        
        recipeManager.launchRequest(foodList: ["chicken"], from: 0, to: 2) { (hits, success) in
            
            // Then
            XCTAssertNil(hits)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: - Request Image Test
    
    
    
    func testGivenUrl_WhenLoadingImage_ThenStatusIs200() {
        
        // Given
        let expectation = XCTestExpectation(description: "Waiting for callback")
        
        // When
        fakeRecipeSession.fakeResponseRecipe.response = responseOK
        fakeRecipeSession.fakeResponseRecipe.data = imageData
        
        fakeRecipeSession.requestImage(url: "") { (dataResponse) in
            
            // Then
            XCTAssertEqual(dataResponse.response?.statusCode, 200)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.02)
    }
    
    func testGivenUrl_WhenLoadingImage_ThenDataIsNotNil() {
        
        // Given
        let expectation = XCTestExpectation(description: "Waiting for callback")
        
        // When
        fakeRecipeSession.fakeResponseRecipe.response = responseOK
        fakeRecipeSession.fakeResponseRecipe.data = imageData
        
        fakeRecipeSession.requestImage(url: "") { (dataResponse) in
            
            // Then
            XCTAssertNotNil(dataResponse.data)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.02)
    }
    
    
    func testGivenURl_WhenLoadingImage_ThenResultIsImage() {
        
        // Given
        let expectation = XCTestExpectation(description: "waiting for callback")
        
        // When
        fakeRecipeSession.fakeResponseRecipe.response = responseOK
        fakeRecipeSession.fakeResponseRecipe.data = imageData
        recipeManager = RecipeManager(recipeSession: fakeRecipeSession)
        
        recipeManager.getImage(from: "") { (data, success) in
            
            // Then
            
            XCTAssertTrue(success)
            XCTAssertNotNil(data)
            
            let dataFake = "10n".data(using: .utf8)!
            
            XCTAssertEqual(dataFake, data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGivenURl_WhenStatudIsNot200_ThenResultIsNil() {
        
        // Given
        let expectation = XCTestExpectation(description: "waiting for callback")
        
        // When
        fakeRecipeSession.fakeResponseRecipe.response = responseKO
        fakeRecipeSession.fakeResponseRecipe.data = imageData
        recipeManager = RecipeManager(recipeSession: fakeRecipeSession)
        
        recipeManager.getImage(from: "") { (data, success) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(data)
    
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGivenURl_WhenNoData_ThenResultIsNil() {
        
        // Given
        let expectation = XCTestExpectation(description: "waiting for callback")
        
        // When
        fakeRecipeSession.fakeResponseRecipe.response = responseOK
        fakeRecipeSession.fakeResponseRecipe.data = nil
        recipeManager = RecipeManager(recipeSession: fakeRecipeSession)
        
        recipeManager.getImage(from: "") { (data, success) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(data)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    

}
