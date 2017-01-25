//
//  LoginViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/23/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import SnapKit
import GoogleSignIn
import FBSDKLoginKit

open class LoginViewController: UIViewController {

    open var loginView = LoginView()

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(loginView)
        loginView.snp.makeConstraints { $0.top.bottom.leading.trailing.equalToSuperview() }
        GIDSignIn.sharedInstance().uiDelegate = self
        loginView.fbLoginButton.delegate = self
        loginView.fbLoginButton.readPermissions = ["email"]
    }

    fileprivate func allowUIUpdate() {
        loginView.shouldNotUpdateUI = false
    }
}

extension LoginViewController: GIDSignInUIDelegate {
    public func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        allowUIUpdate()
    }
}

extension LoginViewController: FBSDKLoginButtonDelegate {
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        allowUIUpdate()
        guard error != nil else { return Account.shared.showError(error) }
        Account.shared.login(withFBResult: result)
    }

    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        allowUIUpdate()
        Account.shared.logOut()
    }
}
