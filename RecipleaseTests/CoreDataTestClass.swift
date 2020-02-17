////
////  CoreDataTestClass.swift
////  RecipleaseTests
////
////  Created by Alexandre Goncalves on 15/02/2020.
////  Copyright © 2020 Alexandre Goncalves. All rights reserved.
////
//
//import XCTest
//@testable import Reciplease
//class CoreDataTestClass: XCTestCase {
//
//    var coreDataStack: TestCoreDataStack!
//    var recipeBook: RecipeBook!
//    
//    private func fillRecipeBook(recipe: RecipeBook) {
//        recipe.image = ""
//        recipe.title = ""
//        recipe.totalTime = 0
//        recipe.uri = ""
//    }
//
//    override func setUp() {
//        coreDataStack = TestCoreDataStack()
//        recipeBook = RecipeBook(context: coreDataStack.managedObjectContext())
//
//    }
//
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//
//    func testGivenNullDatabase_WhenAddingEntity_ThenDatabaseIsNotNill() {
//
//        fillRecipeBook(recipe: recipeBook)
//        XCTAssertTrue(coreDataStack.saveOrUpdate(instance: recipeBook))
//
//    }
//
//
//    func testGivenEmptyDatabase_WhenAddingEntity_ThenDatabasCountEqualOne() {
//
//        fillRecipeBook(recipe: recipeBook)
//        coreDataStack.saveContext()
//        print("On est la \(RecipeBook.all.count)")
//        XCTAssertTrue(RecipeBook.all.count == 2)
//    }
//
//}
