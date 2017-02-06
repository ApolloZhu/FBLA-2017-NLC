//
//  ShippingAddressPickerViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/6/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import Eureka
import GooglePlaces

extension UIViewController {
    func presentShippingAddressPickerViewController() {
        let vc = ShippingAddressPickerViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissShippingAddressPickerViewController))
        vc.title = NSLocalizedString("Shipping Address", comment: "User will either enter or pick shipping address, both for pick up and receive.")
        present(nav, animated: true, completion: nil)
    }
    @objc fileprivate func dismissShippingAddressPickerViewController() {
        animatedDismiss()
    }
}

class ShippingAddressPickerViewController: UIViewController, ShippingAddressPickerDelegate {
    let picker = ShippingAddressPicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(picker)
        picker.snp.makeConstraints {
            $0.centerX.centerY.width.height.equalToSuperview()
        }
        picker.delegate = self
    }
    
    func didUpdatePlace(to: GMSPlace) {
        dismissShippingAddressPickerViewController()
    }
}
