//
//  ItemsTableViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/5/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {
    var result = [String]()
    
    override func numberOfSections(in tableView: UITableView) -> Int
    { return 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    { return result.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let iid = result[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        Item.inSellItemFrom(iid: iid) {
            if let item = $0 {
                cell.textLabel?.text = item.name
                cell.detailTextLabel?.text = item.description
                item.fetchImageURL { cell.imageView?.kf.setImage(with: $0) }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        displayItemWithIID(result[indexPath.row])
    }
}
