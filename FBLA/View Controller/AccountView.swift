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

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var nameLabel = UILabel.makeAutoAdjusting(fontSize: 40)
    lazy var emailLabel = UILabel.makeAutoAdjusting()
    lazy var addressButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.numberOfLines = 3
        return btn
    }()
    lazy var editAddressButton = UIButton(image: #imageLiteral(resourceName: "ic_edit"))
    lazy var pickAddressButton = UIButton(image: #imageLiteral(resourceName: "ic_place"))

    func updateUserInfo() {
        imageView.image = Account.shared.profileImage ?? #imageLiteral(resourceName: "ic_person_48pt")
        nameLabel.text = Account.shared.name
        emailLabel.text = Account.shared.email
        addressButton.setTitle(Account.shared.formattedAddress, for: .normal)
    }
    
    public func toggleEdit() {
        editAddressButton.isHidden = !editAddressButton.isHidden
        pickAddressButton.isHidden = !pickAddressButton.isHidden
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(emailLabel)
        addSubview(addressButton)
        addSubview(editAddressButton)
        addSubview(pickAddressButton)

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
        }
        editAddressButton.snp.makeConstraints { make in
            make.bottom.equalTo(addressButton.snp.bottom)
            make.leading.equalTo(addressButton.snp.trailing).offset(8)
            make.width.height.equalTo(addressButton.snp.height)
        }
        pickAddressButton.snp.makeConstraints { make in
            make.bottom.equalTo(addressButton.snp.bottom)
            make.leading.equalTo(editAddressButton.snp.trailing).offset(8)
            make.trailing.equalTo(snp.trailingMargin)
            make.width.height.equalTo(addressButton.snp.height)
        }
        
        updateUserInfo()
        toggleEdit()
    }
}
