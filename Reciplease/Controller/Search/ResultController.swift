//
//  ResultController.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 06/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import UIKit

class ResultController: UIViewController {

    // MARK: - Variables
    
    var hits: Hits?
    var arrayList: [String] = []
    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupDelegate()
        getRecipe()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let destVC: DetailController = segue.destination as! DetailController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            destVC.recipe = hits?.hits?[indexPath.row].recipe
        }
    }
    
    // MARK: - Private
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func getRecipe() {
        RecipeManager().launchRequest(foodList: arrayList) { (recipe, success) in
            if success {
                self.hits = recipe
                self.tableView.reloadData()
            } else {
                debugPrint("Ca marche pas")
            }
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

// MARK: - Extension

extension ResultController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = hits?.hits?.count else {
            return 0
        }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? ResultCell else {
            return UITableViewCell()
        }
        
        guard let hits = hits else {
            return UITableViewCell()
        }
        
        guard let title = hits.hits?[indexPath.row].recipe?.label else {
            return UITableViewCell()
        }
        
        guard let ingredient = hits.hits?[indexPath.row].recipe?.ingredients else {
            return UITableViewCell()
        }
        
        var imageUrl: String = ""
        
        if let url = hits.hits?[indexPath.row].recipe?.image {
            imageUrl = url
        }
        
        cell.configure(title: title, ingredients: ingredient, image: imageUrl)
        return cell
    }
    
    
}
