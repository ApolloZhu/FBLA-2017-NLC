//
//  CommentsAvaterImageDataSource.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/3/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class CommentsAvaterImageDataSource: NSObject, JSQMessageAvatarImageDataSource {
    public static let shared = CommentsAvaterImageDataSource()
    override private init() {}
    
    public func avatarImage() -> UIImage! {
        //TODO: Get image from database later
        return #imageLiteral(resourceName: "ic_person_48pt")
    }
    
    @available(iOS 2.0, *)
    public func avatarHighlightedImage() -> UIImage! {
        return nil
    }
    
    public func avatarPlaceholderImage() -> UIImage! {
        return #imageLiteral(resourceName: "ic_person_48pt")
    }
}
