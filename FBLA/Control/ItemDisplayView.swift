//
//  ItemDisplayView.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/29/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import MaterialKit
import SwiftyStarRatingView
import Kingfisher

open class ItemDisplayView: UIView {
    open var iid: String? {
        didSet {
            updateInfo()
        }
    }

    open weak var controller: UIViewController?
    open lazy var imageView = UIImageView()
    open lazy var nameLabel = UILabel.makeAutoAdjusting().centered()
    open lazy var descriptionLabel = UILabel.makeAutoAdjusting(lines: 3)
    open lazy var conditionLabel = UILabel.makeAutoAdjusting()
    open lazy var buyButton: MKButton = {
        let btn = MKButton()
        btn.tintColor = .tianyi
        btn.layer.borderColor = UIColor.tianyi.cgColor
        btn.setTitleColor(.tianyi, for: .normal)
        btn.layer.borderWidth = 3
        btn.cornerRadius = 5
        btn.rippleLayerColor = UIColor.MKColor.Lime.P400
        btn.addTarget(self, action: #selector(pay), for: .touchUpInside)
        return btn
    }()
    
    public func updateInfo() {
        Item.from(iid: iid) { [weak self] item in
            if let this = self, let item = item {
                this.imageView.kf.setImage(with: item.imageURL, placeholder: #imageLiteral(resourceName: "ic_card_giftcard_48pt"))
                this.nameLabel.text = item.name
                this.descriptionLabel.text = item.description
                this.conditionLabel.text = "\(item.condition)"
                this.buyButton.setTitle("$\(item.price)", for: .normal)
            }
        }
    }

    @objc private func pay() {
        Item.from(iid: iid) { [weak self] item in
            if let controller = self?.controller, let item = item {
                controller.checkOut(item: item)
            } else {
                showError(NSLocalizedString("No Such Item", comment: "Show in pop up telling user no such item exists"))
            }
        }
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        //!!!: Move this to rating control
        //ratingControl.accurateHalfStars = false
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(conditionLabel)
        addSubview(buyButton)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.horizontallyCenterInSuperview()
            make.height.equalTo(200)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.horizontallyCenterInSuperview()
            make.height.equalTo(40)
        }
        buyButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.horizontallyCenterInSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(buyButton.snp.bottom).offset(8)
            make.horizontallyCenterInSuperview()
        }
        conditionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.horizontallyCenterInSuperview()
        }
        updateInfo()
    }
}
