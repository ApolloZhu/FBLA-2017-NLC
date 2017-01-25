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
import GoogleSignIn
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

    public func showError(_ error: Error? = nil) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print(NSLocalizedString("Something Went Wrong!", comment: "Display in alert when something went wrong"))
        }
    }

    public func login(withFBResult result: FBSDKLoginManagerLoginResult?) {
        guard let token = result?.token?.tokenString else { return showError() }
        login(withCredential: FIRFacebookAuthProvider.credential(withAccessToken: token))
    }

    public func login(withCredential credential: FIRAuthCredential) {
        logOut()
        FIRAuth.auth()?.signIn(with: credential)
    }

    public func logOut() {
        do {
            try FIRAuth.auth()?.signOut()
            GIDSignIn.sharedInstance().signOut()
            FBSDKLoginManager().logOut()
        } catch {
            showError(error)
        }
    }
}

extension Account: GIDSignInDelegate {
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        guard error != nil, let authentication = user?.authentication else { return showError(error) }
        login(withCredential: FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken))
    }

    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!, withError error: Error!) { logOut() }
}
