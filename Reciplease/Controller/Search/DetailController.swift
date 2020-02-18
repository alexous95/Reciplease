//
//  DetailController.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 07/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import UIKit
import CoreData

class DetailController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeIngredients: UITextView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    // MARK: - Variables
    
    var recipe: Recipe?
    var isFavorite = false
    var managedObjectContext: NSManagedObjectContext = AppDelegate.mainContext
    var coreDataStack: CoreDataStack = AppDelegate.stack
    var recipeService: RecipeService?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecipeService()
        setupBackground()
        setup()
        checkFavorite()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "directionSegue" {
            let destVC: DirectionsController = segue.destination as! DirectionsController
            guard let recipe = recipe else { return }
            destVC.directions = recipe.url
        }
    }
    
    // MARK: - Private
    
    private func setupRecipeService() {
        recipeService = RecipeService(managedObjectContext: managedObjectContext, coreDataStack: coreDataStack)
    }
    
    /// Setup for the background view
    private func setupBackground() {
        guard let startColor = UIColor(named: "StartBackground") else { return }
        guard let endColor = UIColor(named: "EndBackground") else { return }
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    /// Setup the different views
    private func setup() {
        guard let recipe = recipe else { return }
        guard let imageUrl = recipe.image else { return }
        guard let ingredients = recipe.ingredients else { return }
        recipeTitle.text = recipe.label
        
        RecipeManager().getImage(from: imageUrl) { (data, success) in
            if success {
                guard let data = data else { return }
                self.recipeImage.image = UIImage(data: data)
            } else {
                debugPrint("Erreur de chargement de l'image")
            }
        }
        getIngredients(list: ingredients)
    }
    
    /// Fill our TextView with the ingredients of the recipe
    /// - Parameter list: An array of Ingredient from a recipe
    private func getIngredients(list: [Ingredient]) {
        for ingredients in list {
            guard let ingredient = ingredients.text else { return }
            recipeIngredients.text += "- " + ingredient + "\n"
        }
    }
    
    /// Checks if the recipe is already a favorite and sets the favorite button accordingly
    private func checkFavorite() {
        guard let recipeService = recipeService else { return }
        guard let recipe = recipe else { return }
        guard let uri = recipe.uri else {
            return
        }
        let favorite = recipeService.checkFav(uri: uri)
        
        if favorite.dup == true {
            favoriteButton.image = UIImage(named: "Selected")
            isFavorite = true
        } else {
            favoriteButton.image = UIImage(named: "Unselected")
            isFavorite = false
        }
    }
    
    // MARK: - Actions
    
    /// Saves or removes a recipe from core data depending if it's already a favorite recipe or not
    @IBAction func makeFavorite() {
        guard let recipeService = recipeService else { return }
        guard let recipe = recipe else { return }
        guard let uri = recipe.uri else { return }
        
        if isFavorite {
            favoriteButton.image = UIImage(named: "Unselected")
            let favoriteRecipe = recipeService.checkFav(uri: uri)
            guard let favRecipe = favoriteRecipe.recipe else { return }
            
            managedObjectContext.delete(favRecipe)
            do {
                try managedObjectContext.save()
            } catch {
                print(error.localizedDescription)
            }
            
            isFavorite = false
            
        } else {
            guard let ingredients = recipe.ingredients else { return }
            recipeService.addRecipeBook(recipe: recipe, ingredients: ingredients)
            favoriteButton.image = UIImage(named: "Selected")
            isFavorite = true
        }
    }
}
