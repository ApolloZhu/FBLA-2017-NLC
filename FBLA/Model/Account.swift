//
//  Account.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/19/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

public class Account: NSObject {
    override private init() {
        FBSDKLoginManager().logOut()
        try? FIRAuth.auth()?.signOut()
    }
    public static let shared = Account()

    public var isLogggedIn: Bool {
        return FIRAuth.auth()?.currentUser != nil
    }

    public var email: String {
        return FIRAuth.auth()?.currentUser?.email ?? NSLocalizedString("E-MAIL", comment: "Place holder for user email in account page")
    }
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

    public func show(error: Error?) {
        if error != nil {
            print(error!.localizedDescription)
        } else {
            print("optional error")
        }
    }
}


extension Account: FBSDKLoginButtonDelegate {
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        guard error != nil else { return show(error: error) }
        print(result.isCancelled)
        print(FBSDKAccessToken.current().tokenString)
        if let token = result?.token?.tokenString {
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: token)
            FIRAuth.auth()?.signIn(with: credential)
        } else {
            show(error: error)
        }
    }

    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch {
            show(error: error)
        }
    }
}
