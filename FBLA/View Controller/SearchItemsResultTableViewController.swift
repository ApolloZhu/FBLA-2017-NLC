//
//  SearchItemsResultTableViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/4/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import Firebase

extension Item {
    static func forEachInSellItem(limits: [Limit]? = nil, order: Order? = nil, process: @escaping (Item?) -> ()) {
        forEachInSellIID(limits: limits, order: order) {
            Item.inSellItemFromIID($0, process)
        }
    }
    static func forEachInSellIID(limits: [Limit]? = nil, order: Order? = nil, process: @escaping (String) -> ()) {
        forEachRelatedToPath("items/byIID", limits: limits, order: order) {
            process($0.key)
        }
    }
}

class SearchItemsResultTableViewController: ItemsTableViewController {
    func search(key: String?, filters: [Filter]? = nil) {
        if let key = key?.content, !key.isBlank {
            removeAll()
            Item.forEachInSellItem { [weak self] in
                if let item = $0, let add = self?.add {
                    if let filters = filters {
                        for filter in filters {
                            switch filter {
                            case .condition(let condition):
                                if item.condition != condition { return }
                            case .maxPrice(let amount):
                                if item.price > amount { return }
                            case .minPrice(let amount): if item.price < amount { return }
                            case .transfer(let method): if item.transfer != method { return }
                            }
                        }
                    }
                    if item.name.localizedCaseInsensitiveContains(key) {
                        return add(item.iid, .inSell)
                    }
                    if item.description.localizedCaseInsensitiveContains(key) {
                        return add(item.iid, .inSell)
                    }
                }

            }
            //            database.child("items/byIID").observe(.childAdded, with: { [weak self] in
            //                if let json = $0.json, let add = self?.add {
            //                    if let title = json["name"].string {
            //                        if title.localizedCaseInsensitiveContains(key) {
            //                            return add($0.key, .inSell)
            //                        }
            //                    }
            //                    if let description = json["description"].string {
            //                        if description.localizedCaseInsensitiveContains(key) {
            //                            return add($0.key, .inSell)
            //                        }
            //                    }
            //                }
            //            })
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
