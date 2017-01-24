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
import FBSDKLoginKit

open class LoginView: UIView {

    open var emailField = UITextField()
    open var passwordField = UITextField()
    open var fbLoginButton = FBSDKLoginButton()

    override open func willMove(toSuperview newSuperview: UIView?) {
        addSubview(emailField)
        addSubview(passwordField)
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

        fbLoginButton.delegate = Account.shared
        fbLoginButton.readPermissions = ["email"]
        addSubview(fbLoginButton)
        fbLoginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
}
