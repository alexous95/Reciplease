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
    var start = 0
    var end = 30
    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupDelegate()
        setupSpinner()
        loadRecipe(start: start, end: end)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let destVC: DetailController = segue.destination as! DetailController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            destVC.recipe = hits?.hits?[indexPath.row].recipe
        }
    }
    
    // MARK: - Private
    
    /// Setup the delegates for the table view
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /// Setup the spinner appearance on screen
    private func setupSpinner() {
        spinner.isHidden = true
    }
    
    /// Scroll to the top of the tableView
    ///
    /// We use it to scroll to the top of the tableview when we load more recipe
    private func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        guard let hits = hits else { return }
        guard let number = hits.hits?.count  else { return }
        if number == 0 {
            showAlert(title: "Oops", message: "There is no recipes") { _ in
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    /// Start/Stop animating the spinner according to its state
    /// - Parameter state: The state of the spinner before the call of the function
    private func toggleSpinner(state: Bool) {
        if state {
            spinner.isHidden = false
            spinner.startAnimating()
        } else {
            spinner.isHidden = true
            spinner.startAnimating()
        }
    }
    
    /// Load recipe from the edamam API and perform animations on the table view if needed
    /// - Parameter start: First number of the range we want to load our recipes
    /// - Parameter end: Last number of the range we want to load our recipe
    ///
    /// The range created is used to avoid long loading time. It's better to load 30 entries first and then
    /// 30 other entries that 60 in one time.
    ///
    /// By default the start of the range is 0 and the end is 30
    private func loadRecipe(start: Int, end: Int) {
        toggleSpinner(state: spinner.isHidden)
        RecipeManager().launchRequest(foodList: arrayList, from: start, to: end) { (recipe, success) in
            if success {
                self.hits = recipe
                self.tableView.reloadData()
                self.toggleSpinner(state: self.spinner.isHidden)
                self.start = end
                self.end += 30
                self.scrollToFirstRow()
            } else {
                self.toggleSpinner(state: self.spinner.isHidden)
                self.showAlert(title: "Oops", message: "Wait for a minute and retry due to API limitation") { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    /// Setup the background
    private func setupBackground() {
        guard let startColor = UIColor(named: "StartBackground") else { return }
        guard let endColor = UIColor(named: "EndBackground") else { return }
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    @IBAction func loadMore(_ sender: Any) {
        loadRecipe(start: start, end: end)
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
        
        // Here we use several guard let to unwrap our optional for the configuration
        
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
