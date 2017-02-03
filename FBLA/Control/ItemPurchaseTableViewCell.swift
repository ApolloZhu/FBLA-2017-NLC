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
    
    @IBOutlet weak var button: MKButton!
    
    var price: Double? {
        willSet {
            button.setTitle("$\(newValue ?? 0)", for: .normal)
        }
    }
    @IBAction func pay() {
        NotificationCenter.default.post(name: .ShouldCheckOutItem, object: nil)
    }
    
}
