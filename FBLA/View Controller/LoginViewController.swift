//
//  LoginViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/23/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import SnapKit
import PKHUD
import GoogleSignIn
import FBSDKLoginKit

extension UIViewController {
    func showLoginViewController() {
        let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissLoginViewController))
        self.present(nav, animated: true, completion: nil)
    }
    func dismissLoginViewController() {
        dismiss(animated: true, completion: nil)
    }
}

open class LoginViewController: UIViewController {
    public var loginView = LoginView()
    open var isUIFreezed: Bool = false {
        willSet {
            if (newValue != isUIFreezed) {
                if (newValue) {
                    HUD.show(.progress)
                } else {
                    HUD.hide()
                }
            }
        }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(loginView)
        loginView.snp.makeConstraints { $0.top.bottom.leading.trailing.equalToSuperview() }
        GIDSignIn.sharedInstance().uiDelegate = self
        loginView.gSignInButton.addTarget(self, action: #selector(toggleGButton), for: .touchUpInside)
        loginView.fbLoginButton.delegate = self
        loginView.fbLoginButton.readPermissions = ["email"]
    }

    @objc private func toggleGButton() {
        if !isUIFreezed && !Account.shared.isLogggedIn {
            isUIFreezed = true
            GIDSignIn.sharedInstance().signIn()
        }
    }
}

extension LoginViewController: GIDSignInUIDelegate {
    public func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        isUIFreezed = false
    }
}

extension LoginViewController: FBSDKLoginButtonDelegate {
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        isUIFreezed = false
        guard error != nil else { HUD.flash(.labeledError(title: "Error", subtitle: error?.localizedDescription)); return  }
        Account.shared.login(withFBResult: result)
    }

    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        isUIFreezed = false
        Account.shared.logOut()
    }
}
