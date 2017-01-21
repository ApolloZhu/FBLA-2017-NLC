//
//  AccountViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/10/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker

class AccountViewController: UIViewController {

    @IBOutlet weak var accountView: AccountView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        accountView.editAddressButton.addTarget(self, action: #selector(presentAddressEditor), for: .touchUpInside)
        accountView.pickAddressButton.addTarget(self, action: #selector(scheduleToPresentPlacePicker), for: .touchUpInside)
        accountView.addressButton.addTarget(self, action: #selector(setEditing(_:animated:)), for: .touchUpInside)
    }
    
    @objc private func presentAddressEditor() {
        let controller = GMSAutocompleteViewController()
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }

    @objc private func scheduleToPresentPlacePicker() {
        GMSPlacesClient.shared().lookUpPlaceID(Account.shared.placeID) { [weak self] (place, _) in
            if let place = place {
                self?.presentAddressPicker(at: place.coordinate)
            } else {
                GMSPlacesClient.shared().currentPlace() { (possiblePlaces, _) in
                    if let possiblePlaces = possiblePlaces {
                        self?.presentAddressPicker(at: possiblePlaces.likelihoods[0].place.coordinate)
                    } else {
                        self?.presentAddressPicker(at: .random)
                    }
                }
            }
        }
    }

    private func presentAddressPicker(at center: CLLocationCoordinate2D) {
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        print(viewport)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        placePicker.pickPlace(callback: didSelectPlace)
    }

    fileprivate func didSelectPlace(_ place: GMSPlace?, error: Error? = nil) {
        Account.shared.placeID = place?.placeID ?? ""
        Account.shared.formattedAddress = place?.formattedAddress ?? ""
        accountView.updateUserInfo()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(!isEditing, animated: animated)
        accountView.toggleEdit()

    }

    deinit {
        accountView.editAddressButton.removeTarget(self, action: #selector(presentAddressEditor), for: .touchUpInside)
        accountView.pickAddressButton.removeTarget(self, action: #selector(scheduleToPresentPlacePicker), for: .touchUpInside)
        accountView.addressButton.removeTarget(self, action: #selector(setEditing(_:animated:)), for: .touchUpInside)
    }
}

extension AccountViewController: GMSAutocompleteViewControllerDelegate {
    public func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        didSelectPlace(place)
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
