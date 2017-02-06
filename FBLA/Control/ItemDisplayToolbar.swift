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
    var controller: UIViewController { get }
    func showCommentInput(iid: String)
    func hideCommentInput()
}

class ItemDisplayToolbar {
    public static let shared = ItemDisplayToolbar()
    private init(){}
    private lazy var toolbar: _ItemDisplayToolbar = .init()
    weak var delegate: (ItemDisplayToolbarDelegate & CheckOutPerforming)? {
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
    
    private var iid: String!
    weak var _delegate: (ItemDisplayToolbarDelegate & CheckOutPerforming)?
    
    func showForIID(_ iid: String) {
        self.iid = iid
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            Account.shared.favorited(iid: iid) { [weak self] favorited in
                DispatchQueue.main.async {
                    if favorited {
                        self?.likeButton.image = #imageLiteral(resourceName: "ic_favorite")
                    } else {
                        self?.likeButton.image = #imageLiteral(resourceName: "ic_favorite_border")
                    }
                }
            }
        }
        UIApplication.shared.keyWindow!.addSubview(self)
        buyButton = UIBarButtonItem(title: Localized.BUY, style: .plain, target: self, action: #selector(self.pay))
        likeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_favorite_border"), style: .plain, target: self, action: #selector(self.toggleFavorite))
        commentButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_message"), style: .plain, target: self, action: #selector(self.startComment))
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
    var buyButton: UIBarButtonItem!
    @objc private func pay() {
        _delegate?.checkOutItem(identifiedBy: iid)
    }
    
    // MARK: Favorite
    var likeButton: UIBarButtonItem!
    @objc private func toggleFavorite() {
        
        guard let iid = iid else { return }
        if Account.shared.isLogggedIn {
            Account.shared.favorited(iid: iid) { [weak self] favorited in
                if let this = self {
                    if !favorited {
                        this.likeButton.image = #imageLiteral(resourceName: "ic_favorite")
                        Account.shared.favorite(iid: iid)
                    } else {
                        this.likeButton.image = #imageLiteral(resourceName: "ic_favorite_border")
                        Account.shared.unfavorite(iid: iid)
                    }
                }
            }
        } else {
            _delegate?.controller.presentLoginViewController()
        }
    }
    
    // MARK: Comment
    var commentButton: UIBarButtonItem!
    @objc private func startComment() {
        _delegate?.showCommentInput(iid: iid!)
    }
}
