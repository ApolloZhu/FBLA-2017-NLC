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
    var imagePath: String?
    var favorite: Int
    //!!!: Bring back for rating
    //    var category: Category /*May replace with tags*/
    //    var rating: Double

    var imageURL: URL? {
        if let path = imagePath {
            return URL(string: path)
        }
        return nil
    }

}

extension Item {
    static func from(iid: String?, _ process: @escaping (Item?) -> ()) {
        // TODO: Get from database
        if let iid = iid {
            database.child("items/\(iid)").observeSingleEvent(of: .value, with: { snapshot in
                if let json = snapshot.json ,
                    let uid = json["uid"].string,
                    let name = json["name"].string,
                    let description = json["description"].string,
                    let price = json["price"].double,
                    let rawCondition = json["condition"].int,
                    let favorite = json["favorite"].int
                {
                    let item = Item(
                        iid: iid, uid: uid, name: name, description: description, price: price,
                        condition: Condition(rawValue: rawCondition) ?? .acceptable,
                        imagePath: json["url"].string?.content,
                        favorite: favorite
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
}

extension Item {
    func save() {
        database.child("items/\(iid)").setValue(json)
    }
    func sell(toUID uid: String) {
        database.child("items/\(iid)").removeValue { (error, _) in
            if error != nil {
                self.save()
            } else {
                var json = self.json
                json.removeValue(forKey: "favorite")
                database.child("soldItems/\(self.iid)").setValue(json)
            }
        }
    }
    var json: [String : Any] {
        var data: [String : Any] = [
            "uid": uid,
            "name": name,
            "description": description,
            "price": price,
            "condition": condition.rawValue,
            "favorite": favorite
        ]
        if let path = imagePath {
            data["url"] = path
        }
        return data
    }
}
