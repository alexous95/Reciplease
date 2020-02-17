//
//  FavoriteController.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 08/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import UIKit
import CoreData

class FavoriteController: UIViewController {
    
    // MARK: - Variables
    
    private var recipes: [RecipeBook] = []
    var managedObjectContext: NSManagedObjectContext?
    var coreDataStack: CoreDataStack?
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupDelegate()
        setupRecipeService()
        setupCoreDataStack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recipes = RecipeBook
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailFavSegue" {
            let destVC: DetailFavoriteController = segue.destination as! DetailFavoriteController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            destVC.recipe = recipes[indexPath.row]
            
        }
    }
    
    // MARK: - Private
    
    private func setupCoreDataStack() {
        self.managedObjectContext = AppDelegate.mainContext
        self.coreDataStack = AppDelegate.stack
    }
    
    private func setupRecipeService() {
        guard let managedObjectContext = self.managedObjectContext,
            let coreDataStack = self.coreDataStack
            else {
                print("la configuration de la stack marche pas")
                return
        }
        recipeService = RecipeService(managedObjectContext: managedObjectContext, coreDataStack: coreDataStack)
    }
    
    /// Setup the background of the viewcontroller
    private func setupBackground() {
        guard let startColor = UIColor(named: "StartBackground") else { return }
        guard let endColor = UIColor(named: "EndBackground") else { return }
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    /// Setup the delegate
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - Extension

extension FavoriteController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as? ResultCell else {
            return UITableViewCell()
        }
        let recipe = recipes[indexPath.row]
        
        guard let title = recipe.title else {
            return UITableViewCell()
        }
        
        guard let image = recipe.image else {
            return UITableViewCell()
        }
        
        let listIngredient = recipe.listIngredients?.allObjects as! [Ingredients]
        cell.configureFromCoreData(title: title, ingredients: listIngredient, image: image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // How to remove an object from core data
            DatabaseManager.shared.managedObjectContext().delete(recipes[indexPath.row])
            do {
                try DatabaseManager.shared.managedObjectContext().save()
            } catch {
                print(error.localizedDescription)
            }
            recipes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    
}
