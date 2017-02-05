//
//  Localized.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/25/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit

let EMOJI = "╮(￣▽￣)╭"

struct Localized {}

extension Localized {
    static let DONE = NSLocalizedString("Done", comment: "General completed something")
    static let CANCEL = NSLocalizedString("Cancel", comment: "General Cancel")
    static let PROCESSING = NSLocalizedString("Processing", comment: "Generally doing something")
}

extension Localized {
    static let CHECKOUT_ERROR = NSLocalizedString("Can't check out item", comment: "Show in pop up telling user can't check out item exists")
    static let BUY = NSLocalizedString("Buy", comment: "General buy button")
}

extension Localized {
    static let IN_SELL = NSLocalizedString("In Sell", comment: "State of item, still in sell on the market")
    static let FAVORITED = NSLocalizedString("Favorited", comment: "State of item, favorited")
    static let BOUGHT = NSLocalizedString("Bought", comment: "State of item, bought by user him/her self")
    static let SOLD = NSLocalizedString("SOLD", comment: "State of item, sold to another user already")
}

extension Localized {
    static let ANONYMOUS = NSLocalizedString("Anonymous", comment: "User name for user that did not login")
    static let EMAIL = NSLocalizedString("E-Mail", comment: "Indicate the content will be e-mail")
    static let PASSWORD = NSLocalizedString("PASSWORD", comment: "Indicate the content will be password")
    static let USERNAME = NSLocalizedString("USERNAME", comment: "Place holder for user name")
}

extension Localized {
    static let LOGIN_REGISTER = NSLocalizedString("Login/Register", comment: "Click this button to login/register")
    static let TAP_TO_CANCEL = NSLocalizedString("Tap to Cancel", comment: "Tap on screen to cancel process")
    static let LOGIN_FAILED = NSLocalizedString("Login Failed. Please Try Again.", comment: "Notify user login failed")
    static let LOGOUT = NSLocalizedString("Log Out", comment: "Tap this button to log out")
}
