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
    
    private var arrayList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTF.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchResultSegue" {
            let destVC: ResultController = segue.destination as! ResultController
            destVC.arrayList = arrayList
        }
    }

    @IBAction func addToList(_ sender: Any) {
        guard let item = listTF.text else { return }
        list.text += item + "\n"
        arrayList.append(item)
        listTF.text = ""
    }
}

extension SearchController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
