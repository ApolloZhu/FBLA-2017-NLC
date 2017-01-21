//
//  Account.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/19/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import GooglePlaces

public class Account {
    private init() {}
    public static let shared = Account()

    public var email = NSLocalizedString("E-MAIL", comment: "Place holder for user email in account page")
    public var password = ""
    public var name = NSLocalizedString("USERNAME", comment: "Place holder for user name")
    public var profileImageKey = ""
    public var placeID = ""
    public var formattedAddress = NSLocalizedString("SELECT SHIPPING ADDRESS", comment: "Place holder for user shipping address in account page") {
        didSet {
            if formattedAddress.isBlank {
                formattedAddress = oldValue
            }
        }
    }
    
    public var profileImage: UIImage? {
        return .image(fromKey: profileImageKey)
    }
}
