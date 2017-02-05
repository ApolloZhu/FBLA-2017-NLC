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
    func search(key: String?) {
        if let key = key?.content, !key.isBlank {
            removeAll()
            database.child("items/byIID").observe(.childAdded, with: { [weak self] in
                if let json = $0.json, let add = self?.add {
                    if let title = json["name"].string {
                        if title.localizedCaseInsensitiveContains(key) {
                            return add($0.key, .inSell)
                        }
                    }
                    if let description = json["description"].string {
                        if description.localizedCaseInsensitiveContains(key) {
                            return add($0.key, .inSell)
                        }
                    }
                }
            })
            Item.forEachBoughtItemFromUID(Account.shared.uid) { [weak self] in
                if let item = $0, let add = self?.add {
                    if item.name.localizedCaseInsensitiveContains(key) {
                        return add(item.iid, .sold)
                    }
                    if item.description.localizedCaseInsensitiveContains(key) {
                        return add(item.iid, .sold)
                    }
                }
            }
            Item.forEachBoughtItemByUID(Account.shared.uid) { [weak self] in
                if let item = $0, let add = self?.add {
                    if item.name.localizedCaseInsensitiveContains(key) {
                        return add(item.iid, .bought)
                    }
                    if item.description.localizedCaseInsensitiveContains(key) {
                        return add(item.iid, .bought)
                    }
                }
            }
        }
    }
}
