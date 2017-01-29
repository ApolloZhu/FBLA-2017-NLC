//
//  AccountViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/10/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    @IBOutlet weak var accountView: AccountView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !Account.shared.isLogggedIn {
            showLoginViewController()
        }
        Account.shared.addLoginStateMonitor { [weak self] in
            self?.accountView.updateInfo()
        }
        navigationItem.rightBarButtonItem = editButtonItem
        accountView.logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        accountView.updateInfo()
    }
    
    @objc private func logout() {
        Account.shared.logOut()
        animatedPop()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(!isEditing, animated: animated)
        accountView.isEditing = editing
    }
}
