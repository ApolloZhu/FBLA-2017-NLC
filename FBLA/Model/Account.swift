//
//  Account.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/19/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import PKHUD
import GooglePlaces
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

public class Account: NSObject {
    override private init() { }
    public static let shared = Account()

    public var isLogggedIn: Bool {
        return user != nil
    }
    public var user: FIRUser? {
        return FIRAuth.auth()?.currentUser
    }
    public var email: String { return user?.email ?? Localized.EMail }
    public var password = ""
    public var name = NSLocalizedString("USERNAME", comment: "Place holder for user name")
    public var profileImageKey = ""
    public var placeID: String {
        get {
            return UserDefaults.standard.string(forKey: Identifier.PlaceIDKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Identifier.PlaceIDKey)
        }
    }
    public func addLoginStateMonitor(_ monitor: @escaping () -> ()) {
        FIRAuth.auth()?.addStateDidChangeListener({ (_, _) in
            monitor()
        })
    }
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

    @nonobjc
    public func login(with auth: GIDAuthentication?) {
        guard let auth = auth else { showError("No Google Auth"); return }
        Account.shared.login(with: FIRGoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken))
    }

    @nonobjc
    public func login(with token: String?) {
        guard let token = token else { showError("No Token"); return }
        login(with: FIRFacebookAuthProvider.credential(withAccessToken: token))
    }

    @nonobjc
    public func login(with credential: FIRAuthCredential) {
        logOut()
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if !showError(error) {
                print(user ?? "Transient user")
            }
        }
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
