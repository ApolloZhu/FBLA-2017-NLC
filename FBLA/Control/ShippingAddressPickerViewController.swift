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
        view.backgroundColor = UIColor.MKColor.Lime.P500
        picker.delegate = self
        picker.controller = self
        picker.layout = .wide
        view.addSubview(picker)
        picker.snp.makeConstraints {
            $0.centerX.centerY.width.height.equalToSuperview()
        }
        picker.isEditing = true
    }
    
    func didUpdatePlace(to: GMSPlace) {
        dismissShippingAddressPickerViewController()
    }
}
