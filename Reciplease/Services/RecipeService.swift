//
//  RecipeServices.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 17/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation
import CoreData

public final class RecipeService {
    
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: CoreDataStack
    let ingredientService: IngredientsService
    
    init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
        self.ingredientService = IngredientsService(managedObjectContext: managedObjectContext, coreDataStack: coreDataStack)
    }
    
    /// Creates and saves a RecipeBook object to core data
    /// - Parameter recipe: A Recipe object from the network request
    /// - Parameter ingredients: An array of ingredient from the recipe
    func addRecipeBook(recipe: Recipe, ingredients: [Ingredient]) {
        let favRecipe = RecipeBook(context: managedObjectContext)
        favRecipe.uri = recipe.uri
        favRecipe.image = recipe.image
        favRecipe.title = recipe.label
        favRecipe.url = recipe.url
        for ingredient in ingredients {
            ingredientService.addIngredient(ingredient, recipeBook: favRecipe)
        }
        coreDataStack.saveContext()
    }
    
    /// Returns a tuple containing the recipeBook object from core data and a boolean if there is a duplicated object
    func checkFav(uri: String) -> (dup: Bool, recipe: RecipeBook?) {
        let recipeBook = RecipeBook.all(managedObjectContext: managedObjectContext)
        
        for recipe in recipeBook {
            if recipe.uri == uri {
                return (dup: true, recipe: recipe)
            }
        }
        return (dup: false, recipe: nil)
    }
}
