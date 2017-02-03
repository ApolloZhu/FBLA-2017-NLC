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
    static func from(iid: String?, _ process: @escaping (Item?) -> ()) {
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
    static func eachIIDFor(uid: String?, _ process: @escaping (String?) -> ()) {
        if let uid = uid {
            database.child("items/fromUID/\(uid)").observeSingleEvent(of: .value, with: { snapshot in
                if let iids = snapshot.dictionary?.keys {
                    for iid in iids {
                        process(iid)
                    }
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
    func sell(toUID target: String) {
        database.child("items/byIID/\(iid)").removeValue { _,_ in
            database.child("items/fromUID/\(self.uid)").removeValue()
            var json = self.json
            json.removeValue(forKey: "favorite")
            database.child("soldItems/byIID/\(self.iid)").setValue(json)
            database.child("soldItems/toUID/\(target)/\(self.iid)").setValue(0)
            DispatchQueue.global(qos: .userInitiated).async {
                Comment.forEachRelatedTo(iid: self.iid) {
                    $0?.remove()
                }
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
    static func forEachBoughtIIDFor(uid: String?, _ process: @escaping (Item?) -> ()) {
        if let uid = uid {
            database.child("soldItems/toUID/\(uid)").observeSingleEvent(of: .value, with: { snapshot in
                if let iids = snapshot.dictionary?.keys {
                    for iid in iids {
                        boughtItemFrom(iid: iid, process)
                    }
                } else {
                    process(nil)
                }
            })
        } else {
            process(nil)
        }
    }
}
