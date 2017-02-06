//
//  EventViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/6/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class EventViewController: JSQMessagesViewController {
    override open var senderDisplayName: String! {
        get { return Account.shared.name ?? Localized.ANONYMOUS }set{}
    }

    override open var senderId: String! {
        get { return Account.shared.uid ?? "0" }set{}
    }

    lazy var inBackground: JSQMessageBubbleImageDataSource = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: .jsq_messageBubbleBlue())

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        return inBackground
    }

    var messages = [JSQMessage]()

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let uid = Account.shared.uid {
            Event.forEachEventOfUID(uid) {
                if let event = $0 {
                    event.localized { [weak self] in
                        self?.messages.append(.init(senderId: "system", displayName: "System", text: $0))
                        self?.finishReceivingMessage()
                    }
                }
            }
        }
    }
}
