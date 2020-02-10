//
//  DetailController.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 07/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeIngredients: UITextView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    var recipe: Recipe?
    var isFavorite = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "directionsSegue" {
            let destVC: DirectionsController = segue.destination as! DirectionsController
            guard let recipe = recipe else { return }
            destVC.directions = recipe.ingredientLines
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setup()
    }
    
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
    
    private func getIngredients(list: [Ingredient]) {
        for ingredients in list {
            guard let ingredient = ingredients.text else { return }
            recipeIngredients.text += "- " + ingredient + "\n"
        }
    }
    
    private func createIngredientObject(ingredient: Ingredient, recipeBook: RecipeBook ) {
        let newIngredient = Ingredients(context: AppDelegate.viewContext)
        newIngredient.text = ingredient.text
        newIngredient.weight = ingredient.weight ?? 0.0
        newIngredient.belongingRecipe = recipeBook
        do {
            try AppDelegate.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func makeFavorite() {
        guard let recipe = recipe else { return }
        guard let ingredients = recipe.ingredients else { return }
        let favRecipe = RecipeBook(context: AppDelegate.viewContext)
        favRecipe.image = recipe.image
        favRecipe.title = recipe.label
        for ingredient in ingredients {
            createIngredientObject(ingredient: ingredient, recipeBook: favRecipe)
        }
        do {
            try AppDelegate.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
        if isFavorite {
            favoriteButton.image = UIImage(named: "Unselected")
        } else {
            favoriteButton.image = UIImage(named: "Selected")
        }
    }
    
    private func setupBackground() {
        guard let startColor = UIColor(named: "StartBackground") else { return }
        guard let endColor = UIColor(named: "EndBackground") else { return }
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
}
