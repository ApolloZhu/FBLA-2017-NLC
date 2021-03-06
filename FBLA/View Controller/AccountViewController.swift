//
//  AccountViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/10/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit

extension UIViewController {
    func pushAccountViewController(animated: Bool = true) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: AccountViewController.identifier), let navigationController = navigationController {
            navigationController.pushViewController(vc, animated: animated)
        }
    }
}

class AccountViewController: UIViewController {
    static let identifier = "AccountViewControllerID"
    @IBOutlet weak var accountView: AccountView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !Account.shared.isLogggedIn {
            presentLoginViewController(dismissAction: #selector(dismissLoginViewController))
        }
        Account.shared.addLoginStateMonitor { [weak self] in
            self?.accountView.updateInfo()
        }
        navigationItem.rightBarButtonItem = editButtonItem
        accountView.placesPicker.controller = self
        accountView.logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    @objc private func dismissLoginViewController() {
        animatedDismiss(completion: Account.shared.isLogggedIn ? nil : animatedPop)
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
