//
//  SearchViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/4/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    weak var controller: SearchItemsResultTableViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.returnKeyType = .search
    }
    @IBAction func search() {
        textField.resignFirstResponder()
        controller?.search(key: textField?.text)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifier.SearchItemsResultTableViewControllerSegue, let vc = segue.terminus as? SearchItemsResultTableViewController {
            controller = vc
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        textField.resignFirstResponder()
        return true
    }
}
