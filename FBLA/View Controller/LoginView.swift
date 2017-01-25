//
//  LoginView.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/23/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

open class LoginView: UIView {

    open lazy var shouldNotUpdateUI = false

    open lazy var emailField = UITextField.with(prompt: Localized.EMail)
    open lazy var passwordField = UITextField.with(prompt: Localized.PASSWORD)
    open lazy var fbLoginButton = FBSDKLoginButton()

    open lazy var gSignInButton: GIDSignInButton = {
        let btn = GIDSignInButton()
        btn.addTarget(self, action: #selector(self.toggleGButton), for: .touchUpInside)
        return btn
    }()

    @objc private func toggleGButton() {
        if !shouldNotUpdateUI {
            shouldNotUpdateUI = true
            if Account.shared.isLogggedIn {
                GIDSignIn.sharedInstance().signOut()
            } else {
                GIDSignIn.sharedInstance().signIn()
            }
        }
    }

    override open func willMove(toSuperview newSuperview: UIView?) {
        backgroundColor = .tianyi
        addSubview(emailField)
        addSubview(passwordField)
        addSubview(fbLoginButton)
        addSubview(gSignInButton)

        emailField.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.bottom.equalTo(snp.centerY).offset(4)
            make.width.equalTo(snp.width).offset(-8)
        }
        passwordField.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.top.equalTo(snp.centerY).offset(4)
            make.width.equalTo(snp.width).offset(-8)
        }

        fbLoginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        gSignInButton.snp.makeConstraints { make in
            make.top.equalTo(fbLoginButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
}
