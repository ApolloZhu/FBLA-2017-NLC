//
//  AccountView.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/13/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol AccountViewDataSource: class {
    @objc optional var profilePhoto: UIImage { get }
    @objc optional var name: String { get }
    @objc optional var email: String { get }
}

class AccountView: UIView {

    weak var dataSource: AccountViewDataSource? {
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

    func updateUserInfo() {
        imageView.image = dataSource?.profilePhoto ?? #imageLiteral(resourceName: "ic_person_48pt")
        nameLabel.text = dataSource?.name ?? "Me"
        emailLabel.text = dataSource?.email ?? ""
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(emailLabel)

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
    }
}
