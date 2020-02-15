//
//  CoreDataTestClass.swift
//  RecipleaseTests
//
//  Created by Alexandre Goncalves on 15/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import XCTest
@testable import Reciplease
class CoreDataTestClass: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testGivenNullDatabase_WhenAddingEntity_ThenDatabaseIsNotNill() {
        
        let mockDatabase = MockDatabaseManager()
        let recipeBook = RecipeBook(context: mockDatabase.managedObjectContext())
        recipeBook.image = ""
        recipeBook.title = ""
        recipeBook.totalTime = 0
        recipeBook.uri = ""
        
        XCTAssertTrue(mockDatabase.saveOrUpdate(instance: recipeBook))
        
    }

}
