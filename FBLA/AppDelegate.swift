//
//  AppDelegate.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/5/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import Braintree

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey("AIzaSyCFuF3tiY2kGcgR4IwcJtvCAgsdUmywmaY")
        GMSServices.provideAPIKey("AIzaSyCFuF3tiY2kGcgR4IwcJtvCAgsdUmywmaY")
        FIROptions.default().deepLinkURLScheme = "io.github.swiftyx.apollo.FBLA-2017-NLC"
        FIRApp.configure()
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        BTAppSwitch.setReturnURLScheme("io.github.swiftyx.apollo.FBLA-2017-NLC.payments")
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func handle(_ dynamicLink: FIRDynamicLink?) {
        if let url = dynamicLink?.url {
            if let iid = url.absoluteString.components(separatedBy: "?iid=").last {
                window?.rootViewController?.displayInSellItemWithIID(iid)
            }
        }
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        var out = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        handle(FIRDynamicLinks.dynamicLinks()?.dynamicLink(fromCustomSchemeURL: url))
        if #available(iOS 9.0, *) {
            out = out || GIDSignIn.sharedInstance().handle(url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
        }
        if url.scheme?.localizedCaseInsensitiveCompare("io.github.swiftyx.apollo.FBLA-2017-NLC.payments") == .orderedSame {
            out = out || BTAppSwitch.handleOpen(url, options: options)
        }
        return out
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        handle(FIRDynamicLinks.dynamicLinks()?.dynamicLink(fromCustomSchemeURL: url))
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
            || FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
            || (url.scheme?.localizedCaseInsensitiveCompare("io.github.swiftyx.apollo.FBLA-2017-NLC.payments") == .orderedSame && BTAppSwitch.handleOpen(url, sourceApplication: sourceApplication))
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        guard let dynamicLinks = FIRDynamicLinks.dynamicLinks() else { return false }
        let handled = dynamicLinks.handleUniversalLink(userActivity.webpageURL!) { dynamicLink, error in
            self.handle(dynamicLink)
        }
        return handled
    }
}
