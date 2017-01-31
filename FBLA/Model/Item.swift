//
//  Item.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/29/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import SwiftyJSON

struct Item {
    var uid: String
    var iid: String
    var name: String
    var description: String
    var price: Double
    var condition: Condition
    var category: Category
    var imagePath: String?
    //!!!: Bring back for rating
    //    var rating: Double
    
}

extension Item {
    static func from(iid: String?, _ process: @escaping (Item?) -> ()) {
        // TODO: Get from database
        if let iid = iid {
            database.child("items/\(iid)").observe(.value, with: { snapshot in
                if let json = snapshot.json,
                    let uid = json["uid"].string,
                    let name = json["name"].string,
                    let description = json["description"].string,
                    let price = json["price"].double,
                    let rawCondition = json["condition"].int
                {
                    let item = Item(uid: uid, iid: iid, name: name, description: description, price: price,
                                    condition: Condition(rawValue: rawCondition) ?? .acceptable,
                                    category: Category.from(snapshot: snapshot.childSnapshot(forPath: "category")) ?? .default,
                                    imagePath: json["url"].string)
                    process(item)
                } else {
                    process(nil)
                }
            })
        }
        process(nil)
    }
    func save() {
        database.child("items/\(iid)").updateChildValues(<#T##values: [AnyHashable : Any]##[AnyHashable : Any]#>)
        // TODO: Save to database
    }
}

extension Item {
    var imageURL: URL? {
        if let path = imagePath {
            return URL(string: path)
        }
        return nil
    }
}

extension Item {
    var username: String {
        // TODO: Get from uid
        return Localized.USERNAME
    }
}

