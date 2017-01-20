//
//  AccountView.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/13/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import SnapKit

class AccountView: UIView {

    var dataSource: Account? {
        didSet {
            updateUserInfo()
        }
    }

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var nameLabel = UILabel.makeAutoAdjusting(fontSize: 40)
    lazy var emailLabel = UILabel.makeAutoAdjusting()
    lazy var addressButton = UIButton(type: .system)

    func updateUserInfo() {
        imageView.image = dataSource?.profileImage ?? #imageLiteral(resourceName: "ic_person_48pt")
        nameLabel.text = dataSource?.name ?? NSLocalizedString("USERNAME", comment: "Place holder for user name in account page")
        emailLabel.text = dataSource?.email ?? NSLocalizedString("E-MAIL", comment: "Place holder for user email in account page")
        addressButton.setTitle(dataSource?.formattedAddress ?? NSLocalizedString("SELECT SHIPPING ADDRESS", comment: "Place holder for user shipping address in account page"), for: .normal)
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(emailLabel)
        addSubview(addressButton)

        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(frame.width/5)
            make.top.leading.equalToSuperview().offset(8)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.trailing.equalTo(snp.trailingMargin)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(nameLabel.snp.bottom).offset(8)
            make.bottom.equalTo(imageView.snp.bottom)
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.trailing.equalTo(snp.trailingMargin)
        }
        addressButton.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.leading.equalTo(snp.leadingMargin)
            make.trailing.equalTo(snp.trailingMargin)
        }
        
        updateUserInfo()
    }
}
