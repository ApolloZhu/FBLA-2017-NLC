//
//  Comment.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/29/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import Firebase

struct Comment {
    var cid: String
    var iid: String
    var uid: String
    var message: String
}

extension Comment {
    var json: [String:Any] {
        return [
            "iid" : iid,
            "uid" : uid,
            "message" : message
        ]
    }
    func save(completionHandler handle: (() -> ())? = nil) {
        database.child("comments/byCID/\(cid)").setValue(json) { _,_ in handle?() }
        database.child("comments/byIID/\(iid)/\(cid)").setValue(0)
        database.child("comments/byUID/\(uid)/\(cid)").setValue(0)
        NotificationCenter.default.post(name: .ShouldUpdate, object: nil)
    }
    func remove() {
        database.child("comments/byCID/\(cid)").removeValue()
        database.child("comments/byIID/\(iid)/\(cid)").removeValue()
        database.child("comments/byUID/\(uid)/\(cid)").removeValue()
        NotificationCenter.default.post(name: .ShouldUpdate, object: nil)
    }
}

extension Comment {
    static func new(withCID generate: (String) -> Comment?) {
        generate(database.child("comments/byCID/").childByAutoId().key)?.save()
    }
    static func from(cid: String?, _ process: @escaping (Comment?) -> ()) {
        if let cid = cid {
            database.child("comments/byCID/\(cid)").observeSingleEvent(of: .value, with: { snapshot in
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
    private static func forEachIn(snapshot: FIRDataSnapshot, process: @escaping (Comment?) -> ()) {
        print(snapshot)
        if let cids = snapshot.dictionary?.keys {
            for cid in cids {
                Comment.from(cid: cid, process)
            }
        } else {
            process(nil)
        }
    }
    static func forEachRelatedTo(iid: String?, process: @escaping (Comment?) -> ()) {
        if let iid = iid {
            database.child("comments/byIID/\(iid)").observeSingleEvent(of: .value, with: {
                forEachIn(snapshot: $0, process: process)
            })
        } else {
            process(nil)
        }
    }
    static func forEachRelatedTo(uid: String?, process: @escaping (Comment?) -> ()) {
        if let uid = uid {
            database.child("comments/byUID/\(uid)").observeSingleEvent(of: .value, with: {
                forEachIn(snapshot: $0, process: process)
            })
        } else {
            process(nil)
        }
    }
}
