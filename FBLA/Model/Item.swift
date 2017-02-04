//
//  Item.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/29/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import Firebase
import SwiftyJSON

struct Item {
    var iid: String

    var uid: String
    var name: String
    var description: String
    var price: Double
    var condition: Condition
    var favorite: Int
    //!!!: Bring back for rating
    //    var category: Category /*May replace with tags*/
    //    var rating: Double

    func fetchImageURL(then process: @escaping (URL?) -> ()) {
        storage.child("itemIMG/\(iid)").downloadURL { url, _ in
            process(url)
        }
    }
}

extension Item {
    var json: [String : Any] {
        return [
            "uid": uid,
            "name": name,
            "description": description,
            "price": price,
            "condition": condition.rawValue,
            "favorite": favorite
        ]
    }
    func save(completionHandler handle: (() -> ())? = nil) {
        database.child("items/byIID/\(iid)").setValue(json) { _,_ in handle?() }
        database.child("items/fromUID/\(uid)/\(iid)").setValue(0)
    }
}

extension Item {
    static func new(withIID generate: (String) -> Item) {
        generate(database.child("items").childByAutoId().key).save()
    }
    static func inSellItemFrom(iid: String?, _ process: @escaping (Item?) -> ()) {
        if let iid = iid {
            database.child("items/byIID/\(iid)").observeSingleEvent(of: .value, with: { snapshot in
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
    static func eachIIDForUID(_ uid: String?, limits: [Limit]? = nil, order: Order? = nil, once: Bool = true, type: FIRDataEventType = .value, process: @escaping (Item?) -> ()) {
        if let uid = uid {
            forEachRelatedToPath("items/fromUID/\(uid)", limits: limits, once: once, type: type, process: process) { Item.inSellItemFrom(iid: $0.key, $1) }
        } else {
            process(nil)
        }
    }
}

extension Item {
    func sell(toUID target: String) {
        database.child("items/byIID/\(iid)").removeValue { _,_ in
            database.child("items/fromUID/\(self.uid)").removeValue()
            var json = self.json
            json.removeValue(forKey: "favorite")
            database.child("soldItems/byIID/\(self.iid)").setValue(json)
            database.child("soldItems/toUID/\(target)/\(self.iid)").setValue(0)
            DispatchQueue.global(qos: .userInitiated).async {
                Comment.forEachRelatedToIID(self.iid) { $0?.remove() }
            }
        }
    }
    static func boughtItemFrom(iid: String?, _ process: @escaping (Item?) -> ()) {
        if let iid = iid {
            database.child("soldItems/fromIID/\(iid)").observeSingleEvent(of: .value, with: { snapshot in
                if let json = snapshot.json ,
                    let uid = json["uid"].string,
                    let name = json["name"].string,
                    let description = json["description"].string,
                    let price = json["price"].double,
                    let rawCondition = json["condition"].int
                {
                    let item = Item(
                        iid: iid, uid: uid, name: name, description: description, price: price,
                        condition: Condition(rawValue: rawCondition) ?? .acceptable,
                        favorite: 0
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
    static func forEachBoughtIIDForUID(_ uid: String?, limits: [Limit]? = nil, order: Order? = nil, once: Bool = true, type: FIRDataEventType = .value, process: @escaping (Item?) -> ()) {
        if let uid = uid {
            forEachRelatedToPath("soldItems/toUID/\(uid)", limits: limits, once: once, type: type, process: process) { boughtItemFrom(iid: $0.key, $1) }
        } else {
            process(nil)
        }
    }
}
