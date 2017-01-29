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

class ShippingAddressPicker: UIButton {
    weak var controller: UIViewController?
    
//    lazy var addressLabel = UILabel.makeAutoAdjusting().centered()
//    lazy var editAddressButton = UIButton(image: #imageLiteral(resourceName: "ic_edit"))
//    lazy var pickAddressButton = UIButton(image: #imageLiteral(resourceName: "ic_place"))
    
    func updateInfo() {
        setTitle(Account.shared.formattedAddress, for: .normal)
//        isEditing = false
    }
    
//    var isEditing: Bool = true {
//        willSet {
//            if isEditing != newValue {
////                editAddressButton.isHidden.toggle()
////                pickAddressButton.isHidden.toggle()
//            }
//        }
//    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addSubview(addressLabel)
        self.addTarget(self, action: #selector(handle), for: .touchUpInside)
//        addSubview(editAddressButton)
//        addSubview(pickAddressButton)
//                editAddressButton.addTarget(self, action: #selector(presentAddressEditor), for: .touchUpInside)
//                pickAddressButton.addTarget(self, action: #selector(scheduleToPresentPlacePicker), for: .touchUpInside)
        addressLabel.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-16)
        }
//        editAddressButton.snp.makeConstraints { make in
//            make.top.equalTo(addressLabel.snp.bottom).offset(8)
//            make.centerX.equalToSuperview().dividedBy(2)
//        }
//        pickAddressButton.snp.makeConstraints { make in
//            make.top.equalTo(addressLabel.snp.bottom).offset(8)
//            make.centerX.equalToSuperview().multipliedBy(1.5)
//        }
        updateInfo()
    }
    
    private func handle() {
    }
    
//    fileprivate var isUIFreezed = false
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
//        if !isUIFreezed, let x = touch?.location(in: self).x {
//            if x < center.x {
//                presentAddressEditor()
//            } else {
//                scheduleToPresentPlacePicker()
//            }
//        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if !isUIFreezed, let x = touches.first?.location(in: self).x {
//            if x < center.x {
//                presentAddressEditor()
//            } else {
//                scheduleToPresentPlacePicker()
//            }
//        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer,
//            tapGestureRecognizer.numberOfTapsRequired == 1 && tapGestureRecognizer.numberOfTouchesRequired == 1 {
//            return false
//        }
//        return true
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
    @objc private func presentAddressEditor() {
        isUIFreezed = true
        let gVC = GMSAutocompleteViewController()
        gVC.delegate = self
        controller?.present(gVC, animated: true, completion: nil)
    }
    
    @objc private func scheduleToPresentPlacePicker() {
        isUIFreezed = true
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
    
//        deinit {
//            editAddressButton.removeTarget(self, action: #selector(presentAddressEditor), for: .touchUpInside)
//            pickAddressButton.removeTarget(self, action: #selector(scheduleToPresentPlacePicker), for: .touchUpInside)
//        }
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
