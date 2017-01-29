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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        Account.shared.addLoginStateMonitor { [weak self] in
            self?.usernameLabel.text = Account.shared.name
            self?.userProfileImageView.image = Account.shared.profileImage ?? #imageLiteral(resourceName: "ic_person_48pt")
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0) {
            NotificationCenter.default.post(name: .ShouldPresentAccountViewController, object: nil)
        }
        // May want to remove this for other items in settings
        revealViewController().revealToggle(animated: true)
    }
    
}
