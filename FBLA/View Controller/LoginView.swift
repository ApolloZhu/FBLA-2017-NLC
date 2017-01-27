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
    open lazy var loginButton: MKButton = {
        let btn = MKButton()
        btn.setTitle(Localized.CANCEL, for: .normal)
        btn.setImage(#imageLiteral(resourceName: "ic_mail_outline_36pt"), for: .normal)
        btn.layer.backgroundColor = UIColor.white.cgColor
        btn.setTitleColor(UIColor.MKColor.Grey.P700, for: .normal)
        btn.frame.size.height = 0
        return btn
    }()
    open lazy var fbLoginButton = FBSDKLoginButton()
    open lazy var gSignInButton = GIDSignInButton()

    override open func willMove(toSuperview newSuperview: UIView?) {
        backgroundColor = UIColor.MKColor.Lime.P500
        addSubview(emailField)
        addSubview(passwordField)
        addSubview(loginButton)
        addSubview(fbLoginButton)
        addSubview(gSignInButton)
        emailField.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.bottom.equalTo(passwordField.snp.top).offset(-8)
            make.width.equalTo(snp.width).offset(-16)
        }
        passwordField.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.bottom.equalTo(loginButton.snp.top).offset(-8).priority(UILayoutPriorityRequired)
            make.bottom.equalTo(snp.centerY).offset(-8).priority(UILayoutPriorityDefaultHigh)
            make.width.equalTo(snp.width).offset(-16)
        }
        loginButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(fbLoginButton.snp.width)
            make.height.equalTo(48)
        }
        fbLoginButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(8).priority(UILayoutPriorityRequired)
            make.top.equalTo(snp.centerY).offset(8).priority(UILayoutPriorityDefaultHigh)
            make.centerX.equalToSuperview()
        }
        gSignInButton.snp.makeConstraints { make in
            make.top.equalTo(fbLoginButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(fbLoginButton.snp.width)
        }
    }
}
