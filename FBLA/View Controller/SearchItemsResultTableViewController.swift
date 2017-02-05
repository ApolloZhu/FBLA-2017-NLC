//
//  SearchItemsResultTableViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/4/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import Firebase

class SearchItemsResultTableViewController: ItemsTableViewController {
    func removeAll() {
        result = []
        reloadAll()
    }
    func add(cid: String) {
        if !result.contains(cid) { result.append(cid) }
        update { [weak self] in if let this = self {
            this.tableView.insertRows(at: [IndexPath(row: this.result.count - 1, section: 0)], with: .automatic)
            }
        }
    }
    func search(key: String?) {
        if let key = key?.content, !key.isBlank {
            removeAll()
            database.child("items/byIID").observe(.childAdded, with: { [weak self] in
                if let json = $0.json, let add = self?.add {
                    if let title = json["name"].string {
                        if title.localizedCaseInsensitiveContains(key) {
                            return add($0.key)
                        }
                    }
                    if let description = json["description"].string {
                        if description.localizedCaseInsensitiveContains(key) {
                            return add($0.key)
                        }
                    }
                }
            })
        }
    }
    
}
