//
//  ItemCommentsViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/3/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ItemCommentsViewController: JSQMessagesViewController {
    var iid: String?
    var comments = [JSQMessage]()
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return comments[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    lazy var inBackground: JSQMessageBubbleImageDataSource = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: .jsq_messageBubbleLightGray())
    lazy var outBackground: JSQMessageBubbleImageDataSource = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: .jsq_messageBubbleBlue())
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        if comments[indexPath.item].senderId == senderId {
            return outBackground
        } else {
            return inBackground
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return CommentsAvaterImageDataSource.shared
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            comments.append(message)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // messages from someone else
        addMessage(withId: "foo", name: "Mr.Bolt", text: "I am so fast!")
        // messages sent from local sender
        addMessage(withId: senderId, name: "Me", text: "I bet I can run faster than you!")
        addMessage(withId: senderId, name: "Me", text: "I like to run!")
        // animates the receiving of a new message on the view
        finishReceivingMessage()
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            Comment.new { [weak self] cid in
                if let iid = self?.iid, let text = text?.content {
                    return Comment(cid: cid, iid: iid, uid: senderId ?? "0", message: text)
                }
                return nil
            }
        }
        
    }
}
