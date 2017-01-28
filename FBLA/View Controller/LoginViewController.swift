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
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissLoginViewController))
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
                    HUD.show(.labeledProgress(title: "Processing", subtitle: "Click Any Where to Cancel"))
                    loginView.endEditing(true)
                    PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
                } else {
                    HUD.hide()
                    PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
                }
            }
        }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTouch(recognizer:))))
        self.view.addSubview(loginView)
        loginView.snp.makeConstraints { $0.top.bottom.leading.trailing.equalToSuperview() }

        loginView.emailField.delegate = self
        loginView.passwordField.delegate = self
        loginView.loginButton.addTarget(self, action: #selector(clickManualLoginButton), for: .touchUpInside)

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        loginView.gSignInButton.addTarget(self, action: #selector(toggleGButton), for: .touchUpInside)

        loginView.fbLoginButton.delegate = self
        loginView.fbLoginButton.readPermissions = ["email"]
    }

    @objc private func handleTouch(recognizer: UIGestureRecognizer) { if isUIFreezed { isUIFreezed = false } }

    fileprivate func hasInfo() -> Bool {
        return !(loginView.emailField.text?.isBlank ?? true || loginView.passwordField.text?.isBlank ?? true)
    }

    @objc private func clickManualLoginButton() {
        if hasInfo() {
            // Login
        } else {
            loginView.toggleManualInput()
        }
    }

    fileprivate func toggleButton() {
        if hasInfo() {
            loginView.loginButton.setTitle(Localized.LOGIN_REGISTER, for: .normal)
        } else {
            loginView.loginButton.setTitle(Localized.CANCEL, for: .normal)
        }
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
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        toggleButton()
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        toggleButton()
        if !(loginView.emailField.isEditing && loginView.passwordField.isEditing) {

        }
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        toggleButton()
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

extension LoginViewController: GIDSignInUIDelegate { }

extension LoginViewController: FBSDKLoginButtonDelegate {
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        isUIFreezed = false
        if !showError(error) {
            Account.shared.login(with: result)
        }
    }

    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        isUIFreezed = false
        Account.shared.logOut()
    }
}
