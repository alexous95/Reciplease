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
    
    var recipe: Recipe?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "directionsSegue" {
            let destVC: DirectionsController = segue.destination as! DirectionsController
            guard let recipe = recipe else { return }
            destVC.directions = recipe.ingredientLines
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func makeFavorite() {
        
    }
}
