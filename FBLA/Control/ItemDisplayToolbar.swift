//
//  ItemDisplayToolbar.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/2/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import SnapKit

protocol ItemDisplayToolbarDelegate: class {
    func showCommentInput(iid: String?)
    func hideCommentInput()
}

class ItemDisplayToolbar {
    public static let shared = ItemDisplayToolbar()
    private init(){}
    private lazy var toolbar: _ItemDisplayToolbar = .init()
    weak var delegate: ItemDisplayToolbarDelegate? {
        get {
            return toolbar._delegate
        }
        set {
            toolbar._delegate = newValue
        }
    }
    func showForIID(_ iid: String) {
        toolbar.showForIID(iid)
    }
    func hide() {
        toolbar.hide()
    }
}

fileprivate class _ItemDisplayToolbar: UIToolbar {

    var iid: String?
    weak var _delegate: ItemDisplayToolbarDelegate?

    func showForIID(_ iid: String) {
        self.iid = iid
        UIApplication.shared.keyWindow!.addSubview(self)
        setItems([space, likeButton, small, commentButton, space, buyButton, space], animated: true)
        snp.makeConstraints { make in
            make.centerX.bottom.width.equalToSuperview()
            make.height.equalTo(49)
        }
    }

    func hide() {
        removeFromSuperview()
        _delegate?.hideCommentInput()
    }


    lazy var small = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    lazy var space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

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
        _delegate?.showCommentInput(iid: iid)
    }
}
