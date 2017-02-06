//
//  Config.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/5/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

struct Identifier {
    static let HomeItemsSegue = "HomeItemsSegue"
    static let ShowLanguagesSegue = "ShowLanguagesSegue"
    static let ShowItemSegue = "Show Item Segue"
    static let ShowAboutUsSegue = "ShowAboutUsViewControllerSegue"
    static let CommentsViewControllerSegue = "CommentsViewControllerSegue"
    static let SearchItemsResultTableViewControllerSegue = "SearchItemsResultTableViewControllerSegue"
    
    static let ItemDisplayViewController = "ItemDisplayViewControllerID"
    
    static let PlaceIDKey = "placeID"
    static let FormattedAddressKey = "FormattedAddressKey"
}

extension Notification.Name {
    static let ShouldPushAccountViewController = Notification.Name("ShouldPushAccountViewController")
    static let ShouldPushMessagesViewController = Notification.Name("ShouldPushMessagesViewController")
    
    static let ShouldShowFavorites = Notification.Name("ShouldShowFavorites")
    static let ShouldShowBought = Notification.Name("ShouldShowBought")
    static let ShouldShowDonated = Notification.Name("ShouldShowDonated")
    
    static let ShouldPushLanguagesViewController = Notification.Name("ShouldPushLanguagesViewController")
    
    static let ShouldPushAboutUsViewController = Notification.Name("ShouldPushAboutUsViewController")
    static let ShouldPushAcknowledgementsViewController = Notification.Name("ShouldPushAcknowledgementsViewController")
}
