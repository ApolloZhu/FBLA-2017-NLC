//
//  Item.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/29/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import Foundation

struct Item {
    var iid: String
    var name: String
    var description: String
    var price: Double
    var condition: Condition
    var category: String
    //!!!: Bring back for rating
//    var rating: Double
    
    var uid: String
}

extension Item {
    static func from(iid: String?) -> Item? {
        // TODO: Get from database
        return nil
    }
    func save() {
        // TODO: Save to database
    }
}

extension Item {
    var imageURL: URL? {

        return URL(string: "\(uid).png")
    }
}

extension Item {
    var username: String {
        // TODO: Get from uid
        return Localized.USERNAME
    }
}

