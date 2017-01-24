//
//  LoginViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/23/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import SnapKit

open class LoginViewController: UIViewController {

    open var loginView = LoginView()

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(loginView)
        loginView.snp.makeConstraints { $0.top.bottom.leading.trailing.equalToSuperview() }
    }

    open override func viewWillDisappear(_ animated: Bool) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
