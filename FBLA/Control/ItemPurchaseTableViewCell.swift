//
//  ItemPurchaseTableViewCell.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/3/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import MaterialKit

class ItemPurchaseTableViewCell: UITableViewCell {
    static let identifier = "ItemPurchaseCell"
    @IBOutlet weak var button: MKButton!
    weak var delegate: CheckOutPerforming?
    var iid: String!

    var price: Double? {
        willSet {
            button.setTitle(String.localizedStringWithFormat(NSLocalizedString("Buy for %.2f USD", comment: "Text on a button which allows user to buy an item. Indicates the price of item in USD"), newValue ?? 0), for: .normal)
        }
    }

    @IBAction func pay() {
        delegate?.checkOutItem(identifiedBy: iid)
    }
}

extension CheckOutPerforming where Self: UITableViewController {
    func itemPurchaseTableViewCell(for item: Item) -> ItemPurchaseTableViewCell {
        let custom = tableView.dequeueReusableCell(withIdentifier: ItemPurchaseTableViewCell.identifier) as! ItemPurchaseTableViewCell
        custom.price = item.price
        custom.iid = item.iid
        custom.delegate = self
        return custom
    }
}
