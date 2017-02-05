//
//  ItemsTableViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/5/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit

extension UIViewController {
    func itemsTableViewController() -> ItemsTableViewController? {
        return storyboard?.instantiateViewController(withIdentifier: ItemsTableViewController.identifier) as? ItemsTableViewController
    }
}

class ItemsTableViewController: UITableViewController {
    static let identifier = "ItemsTableViewController"
    private var result = [(String,ItemState)]()
    
    func removeAll() { result = []; reloadAll() }
    func add(iid: String, state: ItemState) {
        if !result.contains { $0.0 == iid } {
            result.append((iid, state))
        }
        reloadAll()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    { return 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    { return result.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let iid = result[indexPath.row].0,
        state = result[indexPath.row].1,
        cell = tableView.dequeueReusableCell(withIdentifier: ItemsTableViewCell.identifier) as! ItemsTableViewCell
        if state == .favorited || state == .inSell {
            Item.inSellItemFromIID(iid) {
                if let item = $0 {
                    cell.nameLabel?.text = item.name
                    cell.descriptionLabel?.text = item.description
                    cell.stateLabel?.text = state.description
                    item.fetchImageURL { cell.photoView?.kf.setImage(with: $0) }
                }
            }
        }
        if state != .inSell {
            Item.boughtItemFromIID(iid) {
                if let item = $0 {
                    cell.nameLabel?.text = item.name
                    cell.descriptionLabel?.text = item.description
                    cell.stateLabel?.text = state.description
                    item.fetchImageURL { cell.photoView?.kf.setImage(with: $0) }
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        displayItemWithIID(result[indexPath.row].0)
    }
}
