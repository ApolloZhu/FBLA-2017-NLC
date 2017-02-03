//
//  ItemImageTableViewCell.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/3/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import Kingfisher

class ItemImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    var imageURL: URL? {
        willSet {
            itemImageView.kf.setImage(with: newValue, placeholder: #imageLiteral(resourceName: "ic_card_giftcard_48pt")) { [weak self] _,_,_,_ in
                if let this = self, let size = this.itemImageView.image?.size {
                    this.itemImageView.frame.size = size
                    NotificationCenter.default.post(name: .ShouldUpdate, object: nil)
                }
            }
        }
    }
    
}
