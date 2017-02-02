//
//  Comment.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/29/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import Foundation

struct Comment {
    var cid: String
    var iid: String
    var uid: String
    var message: String
}

extension Comment: Data {
    var path: String {
        return "comments/\(cid)"
    }
    var json: [String:Any] {
        return [:]
    }
    static func from(cid: String?, _ process: @escaping (Comment?) -> ()) {
        if let cid = cid {
            database.child("comment/\(cid)").observeSingleEvent(of: .value, with: { snapshot in
                if let json = snapshot.json ,
                    let iid = json["iid"].string,
                    let uid = json["uid"].string,
                    let message = json["message"].string
                {
                    let comment = Comment(cid: cid, iid: iid, uid: uid, message: message)
                    process(comment)
                } else {
                    process(nil)
                }
            })
        } else {
            process(nil)
        }
    }
}
