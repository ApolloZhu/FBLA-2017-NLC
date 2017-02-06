//
//  SettingsTableViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/5/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import Kingfisher
import PKHUD

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Account.shared.addLoginStateMonitor { [weak self] in
            self?.usernameLabel.text =
                Account.shared.name ??
                (Account.shared.isLogggedIn
                    ? Localized.USERNAME
                    : Localized.LOGIN_REGISTER)

            self?.userProfileImageView.kf.setImage(with: Account.shared.photoURL, placeholder: #imageLiteral(resourceName: "ic_person_48pt"))
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            postNotificationNamed(.ShouldPushAccountViewController)
        case (0, 1):
            postNotificationNamed(.ShouldPushMessagesViewController)

        case (1, 0):
            postNotificationNamed(.ShouldShowFavorites)
        case (1, 1):
            postNotificationNamed(.ShouldShowBought)
        case (1, 2):
            postNotificationNamed(.ShouldShowDonated)

        case (2, 0):
            postNotificationNamed(.ShouldPushLanguagesViewController)
        case (2, 1):
            HUD.show(.labeledProgress(title: Localized.PROCESSING, subtitle: nil))
            ImageCache.default.clearMemoryCache()
            ImageCache.default.clearDiskCache() {
                ImageCache.default.cleanExpiredDiskCache() {
                    HUD.flash(.success)
                }
            }

        case (3, 0):
            postNotificationNamed(.ShouldPushAboutUsViewController)
        case (3, 1):
            postNotificationNamed(.ShouldPushAcknowledgementsViewController)
        default: break
        }
        // May want to remove this for other items in settings
        revealViewController().revealToggle(animated: true)
    }
    
}
