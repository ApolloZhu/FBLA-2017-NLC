//
//  ItemsTableViewCell.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/5/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit

class ItemsTableViewCell: UITableViewCell {
    static let identifier = "ItemsTableViewCell"
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var photoView: UIImageView?
    @IBOutlet weak var stateLabel: UILabel?
}
