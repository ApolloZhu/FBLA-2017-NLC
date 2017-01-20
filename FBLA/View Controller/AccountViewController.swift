//
//  AccountViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/10/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import GooglePlaces

class AccountViewController: UIViewController {

    @IBOutlet weak var accountView: AccountView!

    override func viewDidLoad() {
        super.viewDidLoad()
        accountView.dataSource = Account(email: "test@example.com", password: "123", name: "Lorem Ipsum", profileImageKey: "", placeID: "")
        accountView.addressButton.addTarget(self, action: #selector(presentAddressPicker), for: .touchUpInside)
    }
    
    @objc private func presentAddressPicker() {
        let controller = GMSAutocompleteViewController()
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    deinit {
        accountView.addressButton.removeTarget(self, action: #selector(presentAddressPicker), for: .touchUpInside)
    }
}

extension AccountViewController: GMSAutocompleteViewControllerDelegate {
    public func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        accountView.dataSource?.placeID = place.placeID
        accountView.dataSource?.formattedAddress = place.formattedAddress
        accountView.updateUserInfo()
        dismiss()
    }
    
    public func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        dismiss()
    }

    public func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss()
    }
    
    private func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
