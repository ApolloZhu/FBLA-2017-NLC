//
//  AccountViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/10/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import SnapKit

class AccountViewController: UIViewController, AccountViewDataSource {

    @IBOutlet weak var accountView: AccountView!
    var profilePhoto: UIImage {
        get {
            return UIImage.image(fromKey: Identifier.PorfilePhotoKey) ?? #imageLiteral(resourceName: "ic_person_48pt")
        }
        set {
            newValue.save(withKey: Identifier.PorfilePhotoKey)
        }
    }

    var name = "Lorem Ipsum"
    var email = "email@address.com"

    override func viewDidLoad() {
        super.viewDidLoad()
        accountView.dataSource = self
        navigationItem.backBarButtonItem = UIBarButtonItem()
    }

}
