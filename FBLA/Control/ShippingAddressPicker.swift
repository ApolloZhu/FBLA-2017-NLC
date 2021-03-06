//
//  ShippingAddressPicker.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/28/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import SnapKit
import GooglePlaces
import GooglePlacePicker

protocol ShippingAddressPickerDelegate: class {
    func didUpdatePlace(to: GMSPlace)
}

enum ShippingAddressPickerLayout {
    case narrow
    case wide
}

class ShippingAddressPicker: UIControl {
    weak var controller: UIViewController?
    weak var delegate: ShippingAddressPickerDelegate?
    
    lazy var layout: ShippingAddressPickerLayout = .narrow
    lazy var addressLabel = UILabel.makeAutoAdjusting(fontSize: 20, lines: 0).centered()
    lazy var editAddressButton = UIButton(image: #imageLiteral(resourceName: "ic_edit"))
    lazy var pickAddressButton = UIButton(image: #imageLiteral(resourceName: "ic_place"))
    
    func updateInfo() {
        Account.shared.requestPlaceID { [weak self] id in
            if let id = id {
                GMSPlacesClient.shared().lookUpPlaceID(id) { [weak self] (place, error) in
                    if !showError(error), let place = place {
                        self?.setPlace(place)
                    } else {
                        self?.setFormattedAddress()
                    }
                }
            } else {
                self?.setFormattedAddress()
            }
        }
    }
    
    func setFormattedAddress(_ address: String? = nil) {
        if let content = address?.content, !content.isBlank {
            DispatchQueue.main.async { [weak self] in
                self?.addressLabel.text = content
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.addressLabel.text = NSLocalizedString("No shipping address avaliable", comment: "When can't get shipping address, display this instead, so the user knows there isn't any address avaliable.")
            }
        }
    }
    
    var isEditing: Bool = true {
        didSet {
            if isEditing != oldValue {
                isUIFreezed = false
                editAddressButton.isHidden.toggle()
                pickAddressButton.isHidden.toggle()
                setNeedsUpdateConstraints()
            }
        }
    }
    
    private var addressButtonBottomConstraint: (whileEditing: Constraint?, normal: Constraint?)
    override func updateConstraints() {
        addressLabel.snp.updateConstraints{ make in
            if isEditing {
                addressButtonBottomConstraint.normal?.deactivate()
                addressButtonBottomConstraint.whileEditing?.activate()
            } else {
                addressButtonBottomConstraint.whileEditing?.deactivate()
                addressButtonBottomConstraint.normal?.activate()
            }
        }
        super.updateConstraints()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addSubview(addressLabel)
        addSubview(editAddressButton)
        addSubview(pickAddressButton)
        editAddressButton.addTarget(self, action: #selector(presentAddressEditor), for: .touchUpInside)
        pickAddressButton.addTarget(self, action: #selector(scheduleToPresentPlacePicker), for: .touchUpInside)
        addressLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            addressButtonBottomConstraint.whileEditing = make.bottom.equalTo(editAddressButton.snp.top).offset(-8).constraint
            addressButtonBottomConstraint.normal = make.bottom.equalToSuperview().offset(-8).constraint
            addressButtonBottomConstraint.normal?.deactivate()
            make.horizontallyCenterInSuperview()
            if layout == .wide {
                addressLabel.font = .systemFont(ofSize: addressLabel.font.pointSize + 10)
            }
        }
        editAddressButton.snp.makeConstraints { make in
            if layout == .narrow {
                make.centerX.equalToSuperview().dividedBy(2)
                make.width.equalToSuperview().dividedBy(2).offset(-16)
                make.bottom.equalTo(pickAddressButton)
            } else {
                editAddressButton.setImage(#imageLiteral(resourceName: "ic_edit_48pt"), for: .normal)
                make.horizontallyCenterInSuperview()
                make.height.equalTo(addressLabel)
            }
        }
        pickAddressButton.snp.makeConstraints { make in
            if layout == .narrow {
                make.top.equalTo(addressLabel.snp.bottom).offset(8)
                make.centerX.equalToSuperview().multipliedBy(1.5)
                make.width.equalToSuperview().dividedBy(2).offset(-16)
            } else {
                make.top.equalTo(editAddressButton.snp.bottom).offset(8)
                pickAddressButton.setImage(#imageLiteral(resourceName: "ic_place_48pt"), for: .normal)
                make.horizontallyCenterInSuperview()
                make.height.equalTo(editAddressButton)
            }
            make.bottom.equalToSuperview().offset(-8)
        }
        updateInfo()
        isEditing.toggle()
    }
    
    fileprivate var isUIFreezed = false
    
    @objc func presentAddressEditor() {
        if !isUIFreezed {
            isUIFreezed = true
            let gVC = GMSAutocompleteViewController()
            gVC.delegate = self
            controller?.present(gVC, animated: true, completion: nil)
        }
    }
    
    @objc func scheduleToPresentPlacePicker() {
        if !isUIFreezed {
            isUIFreezed = true
            Account.shared.requestPlaceID { id in
                GMSPlacesClient.shared().lookUpPlaceID(id ?? "") { [weak self] (place, _) in
                    if let place = place {
                        self?.presentAddressPicker(at: place.coordinate)
                    } else {
                        GMSPlacesClient.shared().currentPlace() { (near, _) in
                            self?.presentAddressPicker(at: near?.likelihoods[0].place.coordinate ?? .random)
                        }
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
        isUIFreezed = false
        if !showError(error), let place = place {
            Account.shared.setPlaceID(place.placeID)
            setFormattedAddress(place.formattedAddress)
            delegate?.didUpdatePlace(to: place)
        }
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
        showError(error)
        controller?.animatedDismiss()
        isUIFreezed = false
    }
    
    public func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        controller?.animatedDismiss()
        isUIFreezed = false
    }
}
