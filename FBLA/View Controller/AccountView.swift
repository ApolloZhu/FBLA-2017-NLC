//
//  AccountView.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/13/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import SnapKit

protocol AccountViewDataSource: class {
    var profilePhoto: UIImage { get }
}

class AccountView: UIView {

    weak var dataSource: AccountViewDataSource?

    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: self.frame)
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.leading.top.equalToSuperview().offset(20)
        }
        if let dataSource = dataSource {
            imageView.image = dataSource.profilePhoto
        } else {
            imageView.image = #imageLiteral(resourceName: "ic_person_48pt")
        }
    }
}
