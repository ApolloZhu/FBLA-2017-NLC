//
//  LoginView.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/23/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import MaterialKit
import SnapKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

open class LoginView: UIView {

    open lazy var emailField = CTTextField(prompt: Localized.EMail, type: .email)
    open lazy var passwordField = CTTextField(prompt: Localized.PASSWORD, type: .password)
    open lazy var fbLoginButton = FBSDKLoginButton()
    open lazy var gSignInButton = GIDSignInButton()

    override open func willMove(toSuperview newSuperview: UIView?) {
        backgroundColor = .tianyi
        addSubview(emailField)
        addSubview(passwordField)
        addSubview(fbLoginButton)
        addSubview(gSignInButton)
        emailField.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.bottom.equalTo(passwordField.snp.top).offset(-8)
            make.width.equalTo(snp.width).offset(-16)
        }
        passwordField.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.bottom.equalTo(snp.centerY).offset(-4)
            make.width.equalTo(snp.width).offset(-16)
        }
        fbLoginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        gSignInButton.snp.makeConstraints { make in
            make.top.equalTo(fbLoginButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(fbLoginButton.snp.width)
        }
    }
}
