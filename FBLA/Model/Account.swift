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
    public func addLoginStateMonitor(_ monitor: @escaping () -> ()) {
        FIRAuth.auth()?.addStateDidChangeListener({ (_, _) in
            monitor()
        })
    }
    
    public var email: String { return user?.email ?? Localized.EMail }
    //TODO: User name from uid
    public var name: String? { return user?.displayName }
    public var photoURL: URL? { return user?.photoURL }

    public var placeID: String {
        get {
            return defaults.string(forKey: Identifier.PlaceIDKey) ?? ""
        }
        set {
            defaults.set(newValue, forKey: Identifier.PlaceIDKey)
        }
    }
    
    public func login(withEmail email: String?, password: String?, completion: FIRAuthResultCallback?) {
        guard let email = email?.content, let password = password?.content else
        { return notifyInternal(handler: completion) }
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (_, _) in
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { [weak self] (user, error) in
                self?.notify(user: user, error: error, handler: completion)
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
            self?.notify(user: $0, error: $1, handler: completion)
        }
    }
    
    public func notifyInternal(handler: FIRAuthResultCallback? = nil) {
        notify(error: Localized.LOGIN_FAILED, handler: handler)
    }
    
    public func notify(user: FIRUser? = nil, error: Error? = nil, handler: FIRAuthResultCallback? = nil) {
        if let handler = handler { return handler(user, error) }
        if showError(error) {
            print(error!)
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
