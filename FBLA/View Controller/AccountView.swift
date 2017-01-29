//
//  AccountView.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/13/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import MaterialKit
import SnapKit

class AccountView: UIView {

    lazy var basicAccountInfoView: BasicAccountInfo = .init()
    lazy var placesPicker: ShippingAddressPicker = .init()
    lazy var logoutButton: MKButton = {
        let btn = MKButton()
        btn.setTitle(Localized.LOGOUT, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.MKColor.Red.P500
        btn.cornerRadius = 3
        btn.shadowOffset = CGSize(width: 1, height: 1)
        return btn
    }()

    func updateInfo() {
        basicAccountInfoView.updateInfo()
        placesPicker.updateInfo()
    }

    var isEditing: Bool {
        get {
            return basicAccountInfoView.isEditing || placesPicker.isEditing
        }
        set {
            basicAccountInfoView.isEditing = newValue
            placesPicker.isEditing = newValue
        }

    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addSubview(basicAccountInfoView)
        addSubview(placesPicker)
        addSubview(logoutButton)

        basicAccountInfoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-16)
        }
        placesPicker.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-16)
            make.top.equalTo(basicAccountInfoView.snp.bottom).offset(8)
        }

        logoutButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8)
        }

        updateInfo()
    }
}
