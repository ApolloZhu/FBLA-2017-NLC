//
//  SearchViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/4/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import SnapKit

extension Localized {
    static let FILTER = NSLocalizedString("Filter", comment: "Noun, use this to filter search result")
    static let MIN_PRICE = NSLocalizedString("Lowest price in USD", comment: "Filter option, lowest price")
    static let MAX_PRICE = NSLocalizedString("Highest price in USD", comment: "Filter option, highest price")
    // ITEM_CONDITION
    // TRANSFER_METHOD
}

enum Filter {
    case condition(Condition)
    case minPrice(Double)
    case maxPrice(Double)
    case transfer(Transfer)
}

class SearchViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    weak var resultController: SearchItemsResultTableViewController!
    var filterController = FilterViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.returnKeyType = .search
    }
    @IBAction func toggleFilter() {
        navigationController?.pushViewController(filterController, animated: true)
    }
    @IBAction func search() {
        textField.resignFirstResponder()
        resultController.search(key: textField?.text, filters: filterController.filters)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifier.SearchItemsResultTableViewControllerSegue, let vc = segue.terminus as? SearchItemsResultTableViewController {
            resultController = vc
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
