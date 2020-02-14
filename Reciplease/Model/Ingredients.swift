//
//  Ingredients.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 08/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation
import CoreData

class Ingredients: NSManagedObject {
    
    /// Get all the ingredients associated to the recipe
    /// - Parameter recipe: The recipe which we want the ingredient from
    /// - Returns: An array of ingredient
    static func ingredientsFor(recipe: RecipeBook) -> [Ingredients] {
        guard let recipeTitle = recipe.title else { return [] }
        
        let request: NSFetchRequest<Ingredients> = Ingredients.fetchRequest()
        
        // We use NSPredicate to retrieve only the ingredient linked to the recipe
        // belongingRecipe is RecipeBook object so we have access to its title
        
        request.predicate = NSPredicate(format: "belongingRecipe.title = %@", recipeTitle)
        request.returnsObjectsAsFaults = false
        
        guard let ingredients = try? DatabaseManager.shared.managedObjectContext().fetch(request) else { return [] }
        return ingredients
    }
    
    /// Creates an ingredients object (object used in core data not the struct one) and a relation to a RecipeBook object
    /// - Parameter ingredient: An ingredient from the recipe (use the Recipe object to get the ingredients)
    /// - Parameter recipeBook: The recipeBook object we want to create a relation to ( Links the ingredient to the recipe)
    static func createIngredientObject(ingredient: Ingredient, recipeBook: RecipeBook ) {
        let newIngredient = Ingredients(context: DatabaseManager.shared.managedObjectContext())
        newIngredient.text = ingredient.text
        newIngredient.weight = ingredient.weight ?? 0.0
        newIngredient.belongingRecipe = recipeBook
        do {
            try DatabaseManager.shared.managedObjectContext().save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
