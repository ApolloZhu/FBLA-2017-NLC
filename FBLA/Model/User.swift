//
//  User.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/2/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import Foundation

struct User {
    var uid: String
    var name: String?
    var photoPath: String?
    var placeID: String?
    var photoURL: URL? {
        if let path = photoPath { return URL(string: path) }
        return nil
    }
}

extension User {
    static let Anonymous = User(uid: "0", name: Localized.ANONYMOUS, photoPath: nil, placeID: nil)
}

extension User {
    static func new(withIID generate: (String) -> Item) {
        generate(database.child("items").childByAutoId().key).save()
    }
    static func from(uid: String?, _ process: @escaping (User?) -> ()) {
        if let uid = uid {
            if uid == "0" {
                process(.Anonymous)
            } else {
                database.child("userData/\(uid)").observeSingleEvent(of: .value, with: { snapshot in
                    if let json = snapshot.json {
                        let user = User(
                            uid: uid,
                            name: json["name"].string,
                            photoPath: json["image"].string,
                            placeID: json["placeID"].string
                        )
                        process(user)
                    } else {
                        process(nil)
                    }
                })
            }
        } else {
            process(nil)
        }
    }
}
