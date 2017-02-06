//
//  ItemCollectionViewCell.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/5/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    static let identifier = "ItemCollectionViewCell"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var item: Item? {
        didSet {
            nameLabel.text = item?.name
            descriptionLabel.text = item?.description
            item?.fetchImageURL { [weak self] in
                self?.imageView.kf.setImage(with: $0)
            }
        }
    }
}
