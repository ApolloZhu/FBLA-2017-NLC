//
//  Account.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/19/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import SwiftyJSON
import GooglePlaces
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

public class Account: NSObject {
    override private init() { }
    public static let shared = Account()

    public var uid: String? { return user?.uid }
    public var user: FIRUser? { return FIRAuth.auth()?.currentUser }
    public var email: String? { return user?.email }
    public var name: String? { return user?.displayName }
    public var photoURL: URL? { return user?.photoURL }

    public var isLogggedIn: Bool { return user != nil }

    public func addLoginStateMonitor(_ monitor: @escaping () -> ()) {
        FIRAuth.auth()?.addStateDidChangeListener({ (_, _) in
            monitor()
        })
    }

    public func requestPlaceID(_ process: @escaping (String?) -> ()) {
        if let uid = uid {
            database.child("/userData/\(uid)/placeID").observeSingleEvent(of: .value, with: { snapshot in
                process(snapshot.value as? String)
            })
        } else {
            process(defaults.string(forKey: Identifier.PlaceIDKey))
        }
    }

    public func setPlaceID(_ id: String) {
        if let uid = uid {
            database.child("/userData/\(uid)/placeID").setValue(id)
        } else {
            defaults.set(id, forKey: Identifier.PlaceIDKey)
        }
    }

    public func login(withEmail email: String?, password: String?, completion: FIRAuthResultCallback?) {
        guard let email = email?.content, let password = password?.content else
        { return notifyInternal(handler: completion) }
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (_, _) in
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { [weak self] (user, error) in
                self?.notifyLoginOf(user: user, error: error, handler: completion)
            }
        }
    }

    public func login(with auth: GIDAuthentication?, completion: FIRAuthResultCallback?) {
        guard let auth = auth else { return notifyInternal(handler: completion) }
        login(with: FIRGoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken), completion: completion)
    }

    @nonobjc
    public func login(with token: String?, completion: FIRAuthResultCallback?) {
        guard let token = token else { return notifyInternal(handler: completion) }
        login(with: FIRFacebookAuthProvider.credential(withAccessToken: token), completion: completion)
    }

    @nonobjc
    public func login(with credential: FIRAuthCredential, completion: FIRAuthResultCallback?) {
        logOut()
        FIRAuth.auth()?.signIn(with: credential) { [weak self] in
            self?.notifyLoginOf(user: $0, error: $1, handler: completion)
        }
    }

    public func notifyInternal(handler: FIRAuthResultCallback? = nil) {
        notifyLoginOf(error: Localized.LOGIN_FAILED, handler: handler)
    }

    // When a new user logged in
    public func notifyLoginOf(user: FIRUser? = nil, error: Error? = nil, handler: FIRAuthResultCallback? = nil) {
        if let handler = handler { handler(user, error) }
        if showError(error) { print(error!) }
        if let user = user {
            database.child("userData/\(user.uid)").runTransactionBlock { currentData in
                if var json = currentData.json {
                    if let email = user.email?.content, !email.isBlank {
                        json["email"].string = email
                    }
                    if !json["name"].exists()  {
                        json["name"].string = user.displayName
                    }
                    if !json["image"].exists() {
                        json["image"].string = user.photoURL?.absoluteString
                    }
                    if !json["lang"].exists() {
                        json["lang"].string = "en"
                    }
                    currentData.value = json.dictionaryObject
                    return .success(withValue: currentData)
                }
                return .abort()
            }
        }
    }

    public func logOut() {
        do {
            try FIRAuth.auth()?.signOut()
            GIDSignIn.sharedInstance().signOut()
            FBSDKLoginManager().logOut()
            defaults.removeObject(forKey: Identifier.PlaceIDKey)
            defaults.removeObject(forKey: Identifier.FormattedAddressKey)
        } catch {
            showError(error)
        }
    }
}
