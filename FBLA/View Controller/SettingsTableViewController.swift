//
//  SettingsTableViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/5/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit

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
            NotificationCenter.default.post(name: .ShouldPushAccountViewController, object: nil)
        case (1, 0):
            NotificationCenter.default.post(name: .ShouldPushAboutUsViewController, object: nil)
        case (1, 1):
            NotificationCenter.default.post(name: .ShouldPushAcknowledgementsViewController, object: nil)
        default: break
        }
        // May want to remove this for other items in settings
        revealViewController().revealToggle(animated: true)
    }
    
}
