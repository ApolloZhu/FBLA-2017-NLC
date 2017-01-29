//
//  ShippingAddressPicker.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/28/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker

class ShippingAddressPicker: UIControl {

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        editAddressButton.addTarget(self, action: #selector(presentAddressEditor), for: .touchUpInside)
        pickAddressButton.addTarget(self, action: #selector(scheduleToPresentPlacePicker), for: .touchUpInside)
    }

    weak var controller: UIViewController?

    lazy var addressButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.numberOfLines = 3
        return btn
    }()
    lazy var editAddressButton = UIButton(image: #imageLiteral(resourceName: "ic_edit"))
    lazy var pickAddressButton = UIButton(image: #imageLiteral(resourceName: "ic_place"))

    func updateInfo() {
        addressButton.setTitle(Account.shared.formattedAddress, for: .normal)
        isEditing = false
    }

    var isEditing: Bool = false {
        willSet {
            if isEditing != newValue {
                editAddressButton.isHidden.toggle()
                pickAddressButton.isHidden.toggle()
            }
        }
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addSubview(addressButton)
        addSubview(editAddressButton)
        addSubview(pickAddressButton)

        addressButton.snp.makeConstraints { make in
            make.leading.equalTo(snp.leadingMargin)
        }
        editAddressButton.snp.makeConstraints { make in
            make.bottom.equalTo(addressButton.snp.bottom)
            make.leading.equalTo(addressButton.snp.trailing).offset(8)
            make.width.height.equalTo(addressButton.snp.height)
        }
        pickAddressButton.snp.makeConstraints { make in
            make.bottom.equalTo(addressButton.snp.bottom)
            make.leading.equalTo(editAddressButton.snp.trailing).offset(8)
            make.trailing.equalTo(snp.trailingMargin)
            make.width.height.equalTo(addressButton.snp.height)
        }

        updateInfo()
    }

    @objc private func presentAddressEditor() {
        let controller = GMSAutocompleteViewController()
        controller.delegate = self
        controller.present(controller, animated: true, completion: nil)
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
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        placePicker.pickPlace(callback: setPlace)
    }

    open func setPlace(_ place: GMSPlace?, error: Error? = nil) {
        Account.shared.placeID = place?.placeID ?? ""
        Account.shared.formattedAddress = place?.formattedAddress ?? ""
        updateInfo()
    }

    deinit {
        editAddressButton.removeTarget(self, action: #selector(presentAddressEditor), for: .touchUpInside)
        pickAddressButton.removeTarget(self, action: #selector(scheduleToPresentPlacePicker), for: .touchUpInside)
    }
}

extension ShippingAddressPicker: GMSAutocompleteViewControllerDelegate {
    public func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        setPlace(place)
        controller?.animatedDismiss()
    }

    public func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        controller?.animatedDismiss()
    }

    public func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        controller?.animatedDismiss()
    }
}
