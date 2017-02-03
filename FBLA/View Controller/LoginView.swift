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

    open lazy var emailField = LoginTextField(prompt: Localized.EMAIL, type: .email)
    open lazy var passwordField = LoginTextField(prompt: Localized.PASSWORD, type: .password)
    open lazy var loginButton: MKButton = {
        let btn = MKButton()
        btn.setImage(#imageLiteral(resourceName: "ic_mail_outline_36pt"), for: .normal)
        btn.layer.backgroundColor = UIColor.white.cgColor
        btn.cornerRadius = 5
        btn.shadowOffset = CGSize(width: 1, height: 1)
        btn.setTitleColor(UIColor.MKColor.Grey.P600, for: .normal)
        return btn
    }()
    open lazy var fbLoginButton = FBSDKLoginButton()
    open lazy var gSignInButton = GIDSignInButton()

    @discardableResult
    open override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return result
    }

    open func toggleManualInput() {
        if !(emailField.isHidden && passwordField.isHidden) { // Should Hide
            emailField.isHidden = true
            passwordField.isHidden = true
            emailField.text = nil
            passwordField.text = nil
            resignFirstResponder()
            loginButton.setTitle(Localized.EMAIL, for: .normal)
            let _y1 = fbLoginButton.frame.minY, _y2 = gSignInButton.frame.minY
            fbLoginButton.frame.origin.y = loginButton.frame.minY
            gSignInButton.frame.origin.y = loginButton.frame.minY
            UIView.animate(withDuration: 0.5) { [weak self] in
                if let this = self {
                    this.fbLoginButton.isHidden = false
                    this.gSignInButton.isHidden = false
                    this.fbLoginButton.frame.origin.y = _y1
                    this.gSignInButton.frame.origin.y = _y2
                }
            }
        } else {
            fbLoginButton.isHidden = true
            gSignInButton.isHidden = true
            loginButton.setTitle(Localized.CANCEL, for: .normal)
            let _y1 = emailField.frame.minY, _y2 = passwordField.frame.minY
            emailField.frame.origin.y = loginButton.frame.minY
            passwordField.frame.origin.y = loginButton.frame.minY
            UIView.animate(withDuration: 0.5) { [weak self] in
                if let this = self {
                    this.emailField.isHidden = false
                    this.passwordField.isHidden = false
                    this.emailField.frame.origin.y = _y1
                    this.passwordField.frame.origin.y = _y2
                }
            }
        }
    }

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
        toggleManualInput()
    }
}
