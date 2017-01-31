//
//  Category.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/30/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import Firebase
import SwiftyJSON

class Category {
    let name: String
    var sub: Category?
    init(name: String) {
        self.name = name
    }
}

extension Category {
    static let `default` = Category(name: "General")
    static func from(snapshot: FIRDataSnapshot) -> Category? {
        if let json = snapshot.json {
            var category = Category(name: json[0].stringValue)
            if let sub = Category.from(snapshot: snapshot.childSnapshot(forPath: "1")) {
                category.sub = sub
            }
            return category
        }
        return nil
    }
    var json: JSON {
        var data = JSON([name])
        if let sub = sub {
            data[1] = sub.json
        }
        return data
    }
}
