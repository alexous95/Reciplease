//
//  SearchController.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 04/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import UIKit

class SearchController: UIViewController {

    @IBOutlet weak var listTF: UITextField!
    @IBOutlet weak var list: UITextView!
    @IBOutlet weak var clearButton: UIButton!
    
    private var arrayList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        listTF.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchResultSegue" {
            let destVC: ResultController = segue.destination as! ResultController
            destVC.arrayList = arrayList
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
    
    @IBAction func addToList(_ sender: Any) {
        guard let item = listTF.text else { return }
        list.text += "\t- " + item + "\n"
        arrayList.append(item)
        listTF.text = ""
    }
    
    @IBAction func clearList(_ sender: Any) {
        list.text = ""
        arrayList.removeAll()
    }
}

extension SearchController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
