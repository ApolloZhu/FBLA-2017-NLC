//
//  ItemSubmitViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/31/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import Firebase

class ItemSubmitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func submit() {
        let iid = database.child("items").childByAutoId().key
        if let uid = Account.shared.user?.uid {
            
        }
//        Item(
//            iid: iid, uid: Account.shared.user.uid, name: name, description: description, price: price,
//            condition: Condition(rawValue: rawCondition) ?? .acceptable,
//            imagePath: json["url"].string?.content,
//            favorite: favorite
//        ).save()
    }
}
