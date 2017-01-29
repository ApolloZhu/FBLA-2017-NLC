//
//  BasicAccountInfo.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/28/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import SnapKit

open class BasicAccountInfo: UIControl {
    open lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    open lazy var nameLabel = UILabel.makeAutoAdjusting(fontSize: 40)
    open lazy var emailLabel = UILabel.makeAutoAdjusting()

    open func updateInfo() {
        imageView.image = Account.shared.profileImage ?? #imageLiteral(resourceName: "ic_person_48pt")
        nameLabel.text = Account.shared.name
        emailLabel.text = Account.shared.email
    }

    var isEditing = false {
        willSet {
            if isEditing != newValue {
                // perform changes
            }
        }
    }

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(emailLabel)
        snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.width.height.equalTo(48)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.trailing.equalTo(snp.trailingMargin)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.width.equalTo(nameLabel)
            make.trailing.equalTo(snp.trailingMargin)
        }
        updateInfo()
    }
}
