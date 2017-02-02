//
//  Config.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/5/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

struct Identifier {
    static let ShowItemSegue = "Show Item Segue"
    static let ShowAboutUsSegue = "ShowAboutUsViewControllerSegue"

    static let AccountViewController = "AccountViewControllerID"
    static let ItemDisplayViewController = "ItemDisplayViewControllerID"

    static let PlaceIDKey = "placeID"
    static let FormattedAddressKey = "FormattedAddressKey"
}

extension Notification.Name {
    static let ShouldPushAccountViewController = Notification.Name("ShouldPushAccountViewController")
    static let ShouldPushAboutUsViewController = Notification.Name("ShouldPushAboutUsViewController")
    static let ShouldPushAcknowledgementsViewController = Notification.Name("ShouldPushAcknowledgementsViewController")
}
