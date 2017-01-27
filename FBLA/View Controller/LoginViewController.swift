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
        present(nav, animated: true, completion: nil)
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
                    loginView.endEditing(true)
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

        loginView.emailField.delegate = self
        loginView.passwordField.delegate = self

        GIDSignIn.sharedInstance().delegate = self
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

extension LoginViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LoginViewController: GIDSignInDelegate {
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        isUIFreezed = false
        if !showError(error) {
            Account.shared.login(with: user?.authentication)
        }
    }

    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!, withError error: Error!) {
        isUIFreezed = false
        if !showError(error) {
            Account.shared.logOut()
            dismissLoginViewController()
        }
    }
}

extension LoginViewController: FBSDKLoginButtonDelegate {
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        isUIFreezed = false
        if !showError(error) {
            Account.shared.login(with: result)
            dismissLoginViewController()
        }
    }

    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        isUIFreezed = false
        Account.shared.logOut()
    }
}
