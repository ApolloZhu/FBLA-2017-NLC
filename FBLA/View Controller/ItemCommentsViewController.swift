//
//  ItemCommentsViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/3/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import JSQMessagesViewController

class ItemCommentsViewController: JSQMessagesViewController {
    
    // MARK: Must call this method
    func setup(iid: String, sellerUID: String, commenterUID: String? = nil, commenterDisplayName: String? = nil) {
        self.iid = iid
        self.sellerUID = sellerUID
        self.senderId = commenterUID
        self.senderDisplayName = commenterDisplayName
    }
    
    fileprivate var iid: String!
    private var sellerUID: String!
    private var _uid: String?
    override var senderId: String! {
        get {
            return _uid ?? Account.shared.uid ?? "0"
        }
        set {
            _uid = newValue
        }
    }
    private var _senderDisplayName: String?
    override var senderDisplayName: String! {
        get {
            return _senderDisplayName ?? Account.shared.name ?? Localized.ANONYMOUS
        }
        set {
            _senderDisplayName = newValue
        }
    }
    
    var comments = [JSQMessage]()
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return comments[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    lazy var inBackground: JSQMessageBubbleImageDataSource = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: .jsq_messageBubbleLightGray())
    lazy var outBackground: JSQMessageBubbleImageDataSource = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: .jsq_messageBubbleBlue())
    lazy var sellerBackground: JSQMessageBubbleImageDataSource = {
        let f = JSQMessagesBubbleImageFactory()!
        let c = UIColor.jsq_messageBubbleRed()
        if self.sellerUID == self.senderId {
            return f.outgoingMessagesBubbleImage(with: c)
        } else {
            return f.incomingMessagesBubbleImage(with: c)
        }
    }()
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        switch comments[indexPath.item].senderId {
        case sellerUID!:
            return sellerBackground
        case senderId:
            return outBackground
        default:
            return inBackground
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let id = comments[indexPath.item].senderId
        if id != senderId && id != sellerUID {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    private func addExistingComment(_ comment: Comment, displayName name: String) {
        if let comment = JSQMessage(senderId: comment.uid, senderDisplayName: name, date: comment.date, text: comment.message) {
            comments.insert(comment) {
                calender.compare($0.date, to: $1.date, toGranularity: Calendar.Component.nanosecond) == .orderedAscending
            }
            finishReceivingMessage()
        }
    }
    
    var avatars = [String:JSQMessageAvatarImageDataSource]()
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return avatars[comments[indexPath.item].senderId] ?? JSQMessagesAvatarImage.placeholder
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard self != nil else { return }
            Comment.forEachCommentRelatedToIID(self!.iid) { [weak self] in
                if let comment = $0 {
                    User.from(uid: comment.uid) { [weak self] user in
                        if let url = user?.photoURL {
                            ImageDownloader.default.downloadImage(with: url) { [weak self] image,_,_,_ in
                                self?.avatars[comment.uid] = JSQMessagesAvatarImage.avatar(with: image)
                                self?.finishReceivingMessage()
                            }
                        }
                        self?.addExistingComment(comment, displayName: user?.name ?? Localized.ANONYMOUS)
                    }
                }
            }
        }
        inputToolbar.contentView.rightBarButtonItem.setImage(#imageLiteral(resourceName: "ic_send"), for: .normal)
        inputToolbar.contentView.leftBarButtonItem.setImage(#imageLiteral(resourceName: "ic_clear"), for: .normal)
        title = Localized.COMMENTS
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        hideCommentInput()
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        if let text = text?.content, !text.isBlank {
            Comment.saveNew(iid: iid, uid: senderId, message: text)
            { JSQSystemSoundPlayer.jsq_playMessageSentSound() }
            hideCommentInput()
            inputToolbar.contentView.textView.text = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ItemDisplayToolbar.shared.showForIID(iid)
        ItemDisplayToolbar.shared.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ItemDisplayToolbar.shared.hide()
    }
}

extension ItemCommentsViewController: ItemDisplayToolbarDelegate, CheckOutPerforming {
    var controller: UIViewController { return self }
    func showCommentInput(iid: String) {
        inputToolbar.contentView.textView.becomeFirstResponder()
    }
    func hideCommentInput() {
        inputToolbar.contentView.textView.resignFirstResponder()
    }
    func checkOutItem(identifiedBy iid: String) {
        if let id = self.iid, id == iid {
            Item.inSellItemFromIID(iid) { [weak self] in
                if let item = $0, let this = self {
                    this.checkOut(item: item)
                }
            }
        }
    }
}

extension JSQMessagesAvatarImage {
    static let placeholder = JSQMessagesAvatarImage.avatar(with: #imageLiteral(resourceName: "ic_person_48pt"))
}
