//
//  CoreDataTestClass.swift
//  RecipleaseTests
//
//  Created by Alexandre Goncalves on 15/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//
//
import XCTest
@testable import Reciplease
class CoreDataTestClass: XCTestCase {
    
    var coreDataStack: TestCoreDataStack!
    var recipeService: RecipeService!
    var ingredientService: IngredientsService!
    
    private func createDummyRecipeBook(number: Int) -> RecipeBook {
        let recipe = RecipeBook(context: recipeService.managedObjectContext)
        recipe.image = "\(number)"
        recipe.title = "\(number)"
        recipe.totalTime = 0
        recipe.uri = "\(number)"
        recipe.url = "\(number)"
        return recipe
    }
    
    private func createDummyIngredient(number: Int) -> Ingredient {
        let ingredient = Ingredient(text: "\(number)", weight: 0.0)
        return ingredient
    }
    
    private func createIngredient(number: Int, weight: Double?) -> Ingredient {
        let ingredient = Ingredient(text: "\(number)", weight: weight)
        return ingredient
    }
    
    private func createDummyRecipe(number: Int) -> Recipe {
        let recipe = Recipe(uri: "\(number)", label: "\(number)", image: "\(number)", url: "\(number)", ingredients: nil, totalTime: 0)
        return recipe
    }
    
    override func setUp() {
        coreDataStack = TestCoreDataStack()
        recipeService = RecipeService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
        ingredientService = IngredientsService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        super.tearDown()
        recipeService = nil
        coreDataStack = nil
    }
    
    
    func testGivenNullRecipeBook_WhenAddingRecipe_ThenRecipeBookIsNotNill() {
        
        // Given
        let recipe = RecipeBook(context: recipeService.managedObjectContext)
        
        // When
        recipe.image = ""
        recipe.title = ""
        recipe.totalTime = 0
        recipe.uri = ""
        recipe.url = ""
        
        // Then
        XCTAssertNotNil(recipe, "Recipe should not be nil")
        XCTAssertTrue(recipe.image == "")
        XCTAssertTrue(recipe.title == "")
        XCTAssertTrue(recipe.totalTime == 0)
        XCTAssertTrue(recipe.uri == "")
        XCTAssertTrue(recipe.url == "")
    }
    
    func testGivenEmptyDataBase_WhenAddingRecipeBook_ThenDatabaseIsNotEmpty() {
        
        // Given
        let recipe = RecipeBook(context: recipeService.managedObjectContext)
        recipe.image = ""
        recipe.title = ""
        recipe.totalTime = 0
        recipe.uri = ""
        recipe.url = ""
        
        // When
        recipeService.coreDataStack.saveContext()
        
        // Then
        let recipes = RecipeBook.all(managedObjectContext: coreDataStack.mainContext)
        XCTAssertTrue(recipes.count == 1)
    }
    
    
    func testGivenDatabase_WhenDeleting_ThenDatabaseCountMinus1() {
        
        // Given
        for num in 1...4 {
            _ = createDummyRecipeBook(number: num)
            recipeService.coreDataStack.saveContext()
        }
        
        // When
        var recipes = RecipeBook.all(managedObjectContext: recipeService.managedObjectContext)
        guard let deletingRecipe = recipes.last else { return }
        XCTAssertTrue(recipes.count == 4)
        recipeService.managedObjectContext.delete(deletingRecipe)
        recipeService.coreDataStack.saveContext()
        
        // Then
        recipes = RecipeBook.all(managedObjectContext: recipeService.managedObjectContext)
        XCTAssertTrue(recipes.count == 3)
    }
    
    func testGivenRecipeBook_WhenAddingIngredient_ThenRelationIsCreated() {
        
        // Given
        let recipeBook = createDummyRecipeBook(number: 1)
        recipeService.coreDataStack.saveContext()
        
        // When
        let ingredient = createDummyIngredient(number: 1)
        ingredientService.addIngredient(ingredient, recipeBook: recipeBook)
        
        // Then
        let listIngredient = recipeBook.listIngredients?.allObjects as! [Ingredients]
        XCTAssertTrue(ingredient.text == "1")
        XCTAssertTrue(ingredient.weight == 0.0)
        XCTAssertTrue(listIngredient[0].belongingRecipe == recipeBook)
    }
    
    
    func testGivenRecipeBook_WhenCreatingIngredient_ThenWeightEquals0IfNotSpecified() {
    
        let recipeBook = createDummyRecipeBook(number: 1)
        recipeService.coreDataStack.saveContext()
        
        let ingredient = createIngredient(number: 1, weight: nil)
        ingredientService.addIngredient(ingredient, recipeBook: recipeBook)
        
        let listIngredient = recipeBook.listIngredients?.allObjects as! [Ingredients]
        XCTAssertTrue(listIngredient[0].text == "1")
        XCTAssertTrue(listIngredient[0].weight == 0.0)
    }
    
    func testGivenRecipeBook_WhenAddingIngredient_ThenIngredientEqualsRecipeBookIngredient() {
        
        // Given
        let recipeBook = createDummyRecipeBook(number: 1)
        recipeService.coreDataStack.saveContext()
        
        // When
        let ingredient = createDummyIngredient(number: 1)
        ingredientService.addIngredient(ingredient, recipeBook: recipeBook)
        
        // Then
        let listIngredient = recipeBook.listIngredients?.allObjects as! [Ingredients]
        XCTAssertTrue(listIngredient[0].text == "1")
        XCTAssertTrue(listIngredient[0].weight == 0.0)
    }
    
    func testGivenRecipe_WhenAddingToRecipeBook_ThenRecipeBooIsValid() {
        
        // Given
        let recipe = createDummyRecipe(number: 1)
        var listIngredients = [Ingredient]()
        
        for number in 0...3 {
            let ingredient = createDummyIngredient(number: number)
            listIngredients.append(ingredient)
        }
        
        // When
        recipeService.addRecipeBook(recipe: recipe, ingredients: listIngredients)
        
        // Then
        let recipes = RecipeBook.all(managedObjectContext: recipeService.managedObjectContext)
        
        XCTAssertTrue(recipes[0].image == "1")
        XCTAssertTrue(recipes[0].title == "1")
        XCTAssertTrue(recipes[0].uri == "1")
        XCTAssertTrue(recipes[0].url == "1")
        
        let ingredientsList = Ingredients.ingredientsFor(recipe: recipes[0], managedObjectContext: recipeService.managedObjectContext)
        
        for num in 0...3 {
            XCTAssertTrue(ingredientsList[num].weight == 0.0)
        }
    }
    
    
    func testGivenRecipes_WhenCheckingForDuplicate_ThenResultIsTrueIfDuplicate() {
        
        // Given
        for number in 0...4 {
            _ = createDummyRecipeBook(number: number)
            recipeService.coreDataStack.saveContext()
        }
        
        // When
        let favorite = recipeService.checkFav(uri: "1")
        
        // Then
        XCTAssertTrue(favorite.dup == true)
    }
    
    func testGivenRecipes_WhenCheckingForDuplicate_ThenResultIsFalseIfNoDuplicate() {
        
        // Given
        for number in 0...4 {
            _ = createDummyRecipeBook(number: number)
            recipeService.coreDataStack.saveContext()
        }
        
        // When
        let favorite = recipeService.checkFav(uri: "5")
        
        // Then
        XCTAssertTrue(favorite.dup == false)
    }
    
    func testGivenRecipes_WhenCheckingForDuplicate_ThenResultIsDuplicateIfTrue() {
        
        // Given
        let recipeBook = createDummyRecipeBook(number: 1)
        recipeService.coreDataStack.saveContext()
        
        // When
        let favorite = recipeService.checkFav(uri: "1")
        
        // Then
        XCTAssertTrue(favorite.dup == true)
        XCTAssertTrue(favorite.recipe == recipeBook)
    }
    
}
