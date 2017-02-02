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
import Firebase
import GoogleSignIn
import FBSDKLoginKit

extension UIViewController {
    func presentLoginViewController(dismissAction action: Selector? = nil) {
        let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: action ?? #selector(defaultDismissLoginViewController))
        present(nav, animated: true, completion: nil)
    }
    @objc private func defaultDismissLoginViewController() {
        animatedDismiss()
    }
}

open class LoginViewController: UIViewController {

    public var loginView = LoginView()

    private lazy var recognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(handleTouch(recognizer:)))
    }()
    @objc private func handleTouch(recognizer: UIGestureRecognizer) { if isUIFreezed { isUIFreezed = false } }
    open var isUIFreezed: Bool = false {
        willSet {
            if (newValue != isUIFreezed) {
                if (newValue) {
                    HUD.show(.labeledProgress(title: Localized.PROCESSING, subtitle: Localized.TAP_TO_CANCEL))
                    loginView.endEditing(true)
                    view.addGestureRecognizer(recognizer)
                    PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
                } else {
                    HUD.hide()
                    view.removeGestureRecognizer(recognizer)
                    PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
                }
            }
        }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(loginView)
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
}

extension LoginViewController {
    fileprivate func hasInfo() -> Bool {
        return (loginView.emailField.text?.contains("@") ?? false)
            && (loginView.passwordField.content ?? "").length >= 6
    }

    @objc fileprivate func clickManualLoginButton() {
        if hasInfo() {
            loginView.resignFirstResponder()
            isUIFreezed = true
            Account.shared.login(withEmail: loginView.emailField.content, password: loginView.passwordField.content)
            { [weak self] (user, error) in
                if !showError(error) {
                    self?.isUIFreezed = false
                    self?.animatedDismiss()
                }
            }
        } else {
            loginView.toggleManualInput()
        }
    }

    fileprivate func updateManualButtonState() {
        if hasInfo() {
            loginView.loginButton.setTitle(Localized.LOGIN_REGISTER, for: .normal)
        } else {
            loginView.loginButton.setTitle(Localized.CANCEL, for: .normal)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        updateManualButtonState()
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        updateManualButtonState()
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        updateManualButtonState()
        return true
    }
}

extension LoginViewController: GIDSignInDelegate {
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if !showError(error) {
            Account.shared.login(with: user?.authentication) { [weak self] (user, error) in
                if !showError(error) {
                    self?.isUIFreezed = false
                    self?.animatedDismiss()
                }
            }
        }
    }

    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!, withError error: Error!) {
        if !showError(error) {
            Account.shared.logOut()
            isUIFreezed = false
            animatedDismiss(completion: animatedPop)
        }
    }
}

extension LoginViewController: GIDSignInUIDelegate {
    @objc fileprivate func toggleGButton() {
        if !isUIFreezed && !Account.shared.isLogggedIn {
            isUIFreezed = true
        }
    }
}

extension LoginViewController: FBSDKLoginButtonDelegate {
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if !showError(error) {
            Account.shared.login(with: result?.token?.tokenString) { [weak self] (user, error) in
                if !showError(error) {
                    self?.isUIFreezed = false
                    self?.animatedDismiss()
                }
            }
        }
    }

    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        isUIFreezed = false
        Account.shared.logOut()
        animatedDismiss(completion: animatedPop)
    }
}
