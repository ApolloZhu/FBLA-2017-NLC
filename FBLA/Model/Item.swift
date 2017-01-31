//
//  Item.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/29/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import SwiftyJSON

struct Item {
    var iid: String
    
    var uid: String
    var name: String
    var description: String
    var price: Double
    var condition: Condition
    fileprivate var imagePath: String?
    //!!!: Bring back for rating
    //    var category: Category /*May replace with tags*/
    //    var rating: Double
    
}

extension Item {
    static func from(iid: String?, _ process: @escaping (Item?) -> ()) {
        // TODO: Get from database
        if let iid = iid {
            database.child("items/\(iid)").observe(.value, with: { snapshot in
                if let json = snapshot.json ,
                    let uid = json["uid"].string,
                    let name = json["name"].string,
                    let description = json["description"].string,
                    let price = json["price"].double,
                    let rawCondition = json["condition"].int {
                    let item = Item(
                        iid: iid, uid: uid, name: name, description: description, price: price,
                        condition: Condition(rawValue: rawCondition) ?? .acceptable,
                        imagePath: json["url"].string?.content
                    )
                    process(item)
                } else {
                    process(nil)
                }
            })
        } else {
            process(nil)
        }
    }
    func save() {
        var json: [String : Any] = [
            "uid": uid,
            "name": name,
            "description": description,
            "price": price,
            "condition": condition.rawValue,
            ]
        if let path = imagePath {
            json["url"] = path
        }
        database.child("items/\(iid)").updateChildValues(json)
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

