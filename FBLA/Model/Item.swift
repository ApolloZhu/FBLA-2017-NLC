//
//  Item.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/29/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import Firebase
import SwiftyJSON

enum ItemState: CustomStringConvertible {
    case inSell, favorited, bought, sold
    var description: String {
        switch self {
        case .inSell: return Localized.IN_SELL
        case .favorited: return Localized.FAVORITED
        case .bought: return Localized.BOUGHT
        case .sold: return Localized.SOLD
        }
    }
}

struct Item {
    var iid: String
    
    var uid: String
    var name: String
    var description: String
    var price: Double
    var condition: Condition
    var favorite: Int
    
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
    static func new(generateWithIID generate: (String) -> Item) {
        generate(database.child("items").childByAutoId().key).save()
    }
    static func inSellItemFromIID(_ iid: String?, _ process: @escaping (Item?) -> ()) {
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
    static func forEachInSellItemFromUID(_ uid: String?, limits: [Limit]? = nil, order: Order? = nil, process: @escaping (Item?) -> ()) {
        forEachInSellIIDFromUID(uid, limits: limits, order: order) {
            Item.inSellItemFromIID($0, process)
        }
    }
    static func forEachInSellIIDFromUID(_ uid: String?, limits: [Limit]? = nil, order: Order? = nil, process: @escaping (String) -> ()) {
        if let uid = uid {
            forEachRelatedToPath("items/fromUID/\(uid)", limits: limits, order: order) {
                process($0.key)
            }
        }
    }
}

extension Item {
    func sellToUID(_ target: String) {
        database.child("items/byIID/\(iid)").removeValue { _,_ in
            database.child("items/fromUID/\(self.uid)").removeValue()
            var json = self.json
            json.removeValue(forKey: "favorite")
            database.child("soldItems/byIID/\(self.iid)").setValue(json)
            database.child("soldItems/toUID/\(target)/\(self.iid)").setValue(0)
            DispatchQueue.global(qos: .userInitiated).async {
                Comment.forEachCommentRelatedToIID(self.iid) { $0?.remove() }
            }
        }
    }
    static func boughtItemFromIID(_ iid: String?, _ process: @escaping (Item?) -> ()) {
        if let iid = iid {
            database.child("soldItems/byIID/\(iid)").observeSingleEvent(of: .value, with: { snapshot in
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
    
    static func forEachBoughtItemFromUID(_ uid: String?, limits: [Limit]? = nil, order: Order? = nil, process: @escaping (Item?) -> ()) {
        forEachBoughtIIDFromUID(uid, limits: limits, order: order) {
            boughtItemFromIID($0, process)
        }
    }
    static func forEachBoughtIIDFromUID(_ uid: String?, limits: [Limit]? = nil, order: Order? = nil, process: @escaping (String) -> ()) {
        if let uid = uid {
            forEachRelatedToPath("soldItems/byIID", limits: limits, order: order) {
                if let json = $0.json {
                    if json["uid"].string == uid {
                        process($0.key)
                    }
                }
            }
        }
    }
    
    static func forEachBoughtItemByUID(_ uid: String?, limits: [Limit]? = nil, order: Order? = nil, process: @escaping (Item?) -> ()) {
        forEachBoughtIIDByUID(uid, limits: limits, order: order) {
            boughtItemFromIID($0, process)
        }
    }
    static func forEachBoughtIIDByUID(_ uid: String?, limits: [Limit]? = nil, order: Order? = nil, process: @escaping (String) -> ()) {
        if let uid = uid {
            forEachRelatedToPath("soldItems/toUID/\(uid)", limits: limits, order: order) {
                process($0.key)
            }
        }
    }
}
