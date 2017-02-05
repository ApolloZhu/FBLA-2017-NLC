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
    fileprivate var _shouldSetImage = true
}

extension Identifier {
    static let ItemImageCell = "ItemImageCell"
}

extension Notification.Name {
    static let RequestUpdateImage = Notification.Name("RequestUpdateImage")
}

extension UITableViewController {
    func itemImageTableViewCell(for item: Item?) -> ItemImageTableViewCell {
        let custom = tableView.dequeueReusableCell(withIdentifier: Identifier.ItemImageCell) as! ItemImageTableViewCell
        item?.fetchImageURL {
            custom.itemImageView.kf.setImage(with: $0, placeholder: #imageLiteral(resourceName: "ic_card_giftcard_48pt")) { image,_,_,_ in
                if let size = image?.size, custom._shouldSetImage {
                    custom._shouldSetImage = false
                    custom.itemImageView.frame.size = size
                    postNotificationNamed(.RequestUpdateImage)
                }
            }
        }
        return custom
    }
}
