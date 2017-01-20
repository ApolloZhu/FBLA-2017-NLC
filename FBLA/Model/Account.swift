//
//  Account.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/19/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import GooglePlaces

public struct Account {
    public let email: String
    public let password: String
    public let name: String
    public let profileImageKey: String
    public let placeID: String
    public var profileImage: UIImage? {
        return .image(fromKey: profileImageKey)
    }
    public var formattedPlace : String? {
        GMSPlacesClient.shared().lookUpPlaceID(placeID) { (place, _) in
            return place?.formattedAddress
        }
        return nil
    }
}
