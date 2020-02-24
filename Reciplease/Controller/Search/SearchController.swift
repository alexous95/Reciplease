//
//  SearchController.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 04/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import UIKit

class SearchController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var listTF: UITextField!
    @IBOutlet weak var list: UITextView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: - Variables
    
    private var arrayList: [String] = []
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupBorder()
        listTF.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchResultSegue" {
            let destVC: ResultController = segue.destination as! ResultController
            destVC.arrayList = arrayList
        }
    }
    
    // MARK: - Private
    
    /// Setup for the background view
    private func setupBackground() {
        guard let startColor = UIColor(named: "StartBackground") else { return }
        guard let endColor = UIColor(named: "EndBackground") else { return }
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    private func setupBorder() {
        listTF.layer.borderWidth = 1.0
        listTF.layer.borderColor = UIColor.white.cgColor
    }
    
    // MARK: - Action
    
    /// Add ingredients query to an array and a textview
    /// - Parameter sender: In this case it's a UIButton
    @IBAction func addToList(_ sender: Any) {
        
        guard var item = listTF.text else { return }
        //item = item.trimmingCharacters(in: .whitespaces)
        //item = item.replacingOccurrences(of: " ", with: "")
        if item == "" {
            showAlert(title: "Oops", message: "You can't add an empty text", completion: nil)
            return 
        }
        list.text += "\t- " + item + "\n"
        arrayList.append(item)
        listTF.text = ""
    }
    
    /// Remove all ingredients from the text view and the array
    /// - Parameter sender: In this case it's a UIButton
    @IBAction func clearList(_ sender: Any) {
        list.text = ""
        arrayList.removeAll()
    }
}

// MARK: - Extension

extension SearchController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
