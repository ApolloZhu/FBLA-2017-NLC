//
//  ItemView.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/29/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import MaterialKit
import SwiftyStarRatingView
import Kingfisher

class ItemView: UIView {
    open var iid: String? {
        didSet {
            updateInfo()
        }
    }
    
    open lazy var imageView = UIImageView()
    open lazy var nameLabel = UILabel.makeAutoAdjusting().centered()
    open lazy var descriptionLabel = UILabel.makeAutoAdjusting(lines: 3)
    open lazy var conditionLabel = UILabel.makeAutoAdjusting()
    open lazy var buyButton: MKButton = {
        let btn = MKButton()
        btn.tintColor = .tianyi
        btn.cornerRadius = 5
        return btn
    }()
    
    public func updateInfo() {
        if let item = Item.from(iid: iid) {
            imageView.kf.setImage(with: item.imageURL, placeholder: #imageLiteral(resourceName: "ic_card_giftcard_48pt"))
            nameLabel.text = item.name
            descriptionLabel.text = item.description
            conditionLabel.text = "\(item.condition)"
            buyButton.setTitle("$\(item.price)", for: .normal)
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        //!!!: Move this to rating control
        //ratingControl.accurateHalfStars = false
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-16)
            make.height.equalTo(100)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-16)
        }
        buyButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.width.equalToSuperview().dividedBy(5)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(buyButton.snp.leading).offset(-8)
        }
        conditionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(descriptionLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        updateInfo()
    }
    
    
}
