//
//  ItemConditionTableViewCell.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/3/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit

class ItemConditionTableViewCell: UITableViewCell {

    var condition: Condition? {
        willSet {
            detailTextLabel?.text = newValue?.description
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.text = Localized.ITEM_CONDITION
    }
    
}
