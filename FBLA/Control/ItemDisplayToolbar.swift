//
//  ItemDisplayToolbar.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/2/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import SnapKit

class ItemDisplayToolbar: UIToolbar {

    var iid: String?

    lazy var small = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    lazy var space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

    // MARK: interface
    open func show() {
        UIApplication.shared.keyWindow!.addSubview(self)
        setItems([space, likeButton, small, commentButton, space, buyButton, space], animated: true)
        snp.makeConstraints { make in
            make.centerX.bottom.width.equalToSuperview()
            make.height.equalTo(49)
        }
    }

    open func hide() {
        removeFromSuperview()
        CommentInput.shared.hide()
    }

    // MARK: Purchase
    lazy var buyButton = UIBarButtonItem(title: Localized.BUY, style: .plain, target: self, action: #selector(pay))
    @objc private func pay() {
        NotificationCenter.default.post(name: .ShouldCheckOutItem, object: nil)
    }

    // MARK: Favorite
    lazy var likeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_favorite_border"), style: .plain, target: self, action: #selector(toggleFavorite))

    //TODO: Read like from database
    private(set) public var isFavorite = false

    @objc private func toggleFavorite() {
        isFavorite.toggle()
        if isFavorite {
            likeButton.image = #imageLiteral(resourceName: "ic_favorite")
        } else {
            likeButton.image = #imageLiteral(resourceName: "ic_favorite_border")
        }
        //TODO: Sync like to database
    }

    // MARK: Comment
    lazy var commentButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_message"), style: .plain, target: self, action: #selector(startComment))

    @objc private func startComment() {
        CommentInput.shared.show()
    }
}
