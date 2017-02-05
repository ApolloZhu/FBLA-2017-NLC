//
//  ItemPurchaseTableViewCell.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/3/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import MaterialKit

extension Identifier {
    static let ItemPurchaseCell = "ItemPurchaseCell"
}

class ItemPurchaseTableViewCell: UITableViewCell {

    @IBOutlet weak var button: MKButton!

    var price: Double? {
        willSet {
            button.setTitle(String.localizedStringWithFormat("Buy for %.2f USD", newValue ?? 0), for: .normal)
        }
    }

    @IBAction func pay() {
        postNotificationNamed(.ShouldCheckOutItem)
    }
}

extension UITableViewController {
    func itemPurchaseTableViewCell(for item: Item?) -> ItemPurchaseTableViewCell {
        let custom = tableView.dequeueReusableCell(withIdentifier: Identifier.ItemPurchaseCell) as! ItemPurchaseTableViewCell
        custom.price = item?.price
        return custom
    }
}
