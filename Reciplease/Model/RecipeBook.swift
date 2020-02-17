//
//  RecipeBook.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 08/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation
import CoreData

class RecipeBook: NSManagedObject {
    
    /// Returns an array of all the RecipeBook object in core data
    static func all(moc: NSManagedObjectContext) -> [RecipeBook] {
        let request: NSFetchRequest<RecipeBook> = RecipeBook.fetchRequest()
        guard let recipes = try? AppDelegate.mainContext.fetch(request) else { return [] }
        return recipes
    }
    
    /// Creates and saves a RecipeBook object to core data
    /// - Parameter recipe: A Recipe object from the network request
    /// - Parameter ingredients: An array of ingredient from the recipe
    static func saveRecipeBook(recipe: Recipe, ingredients: [Ingredient]) {
        let favRecipe = RecipeBook(context: DatabaseManager.shared.managedObjectContext())
        favRecipe.uri = recipe.uri
        favRecipe.image = recipe.image
        favRecipe.title = recipe.label
        for ingredient in ingredients {
            Ingredients.createIngredientObject(ingredient: ingredient, recipeBook: favRecipe)
        }
        do {
            try AppDelegate.mainContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Returns a tuple containing the recipeBook object from core data and a boolean if there is a duplicated object
    static func checkFav(uri: String) -> (dup: Bool, recipe: RecipeBook?) {
        let recipeBook = RecipeBook.all(moc: AppDelegate.mainContext)
        
        for recipe in recipeBook {
            if recipe.uri == uri {
                return (dup: true, recipe: recipe)
            }
        }
        return (dup: false, recipe: nil)
    }
}
