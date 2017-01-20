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
    public dynamic var email: String
    public dynamic var password: String
    public dynamic var name: String
    public dynamic var profileImageKey: String?
    public dynamic var placeID: String?
    public dynamic var formattedAddress: String?
    
    init(email: String = "", password: String = "", name: String = "", profileImageKey: String? = nil, placeID: String? = nil, formattedAddress: String? = nil) {
        self.email = email
        self.password = password
        self.name = name
        self.profileImageKey = profileImageKey
        self.placeID = placeID
        self.formattedAddress = formattedAddress
    }
    
    public var profileImage: UIImage? {
        return .image(fromKey: profileImageKey ?? "")
    }
}
