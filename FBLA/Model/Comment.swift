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
    var timestamp: TimeInterval
    var date: Date {
        return Date(timeIntervalSince1970: timestamp / 1000)
    }
}

extension Comment {
    var json: [String:Any] {
        return [
            "iid" : iid,
            "uid" : uid,
            "message" : message,
            "timestamp": timestamp
        ]
    }
    func save(completionHandler handle: (() -> ())? = nil) {
        database.child("comments/byCID/\(cid)").setValue(json) { _,_ in handle?() }
        database.child("comments/byIID/\(iid)/\(cid)").setValue(0)
        database.child("comments/byUID/\(uid)/\(cid)").setValue(0)
        newComment()
    }
    func remove() {
        database.child("comments/byCID/\(cid)").removeValue()
        database.child("comments/byIID/\(iid)/\(cid)").removeValue()
        database.child("comments/byUID/\(uid)/\(cid)").removeValue()
        requestReloadAll()
    }
}

extension Comment {
    static func saveNew(iid: String, uid: String, message: String, completionHandler handle: (() -> ())? = nil) {
        database.child("temp").setValue(FIRServerValue.timestamp())
        database.child("temp").observeSingleEvent(of: .value, with: {
            let timestamp = $0.value as! TimeInterval
            let cid = database.child("comments/byCID/").childByAutoId().key
            let comment = Comment(cid: cid, iid: iid, uid: uid, message: message, timestamp: timestamp)
            comment.save { handle?() }
        })
    }
    static func from(cid: String?, _ process: @escaping (Comment?) -> ()) {
        if let cid = cid {
            database.child("comments/byCID/\(cid)").observeSingleEvent(of: .value, with: { snapshot in
                if let json = snapshot.json ,
                    let iid = json["iid"].string,
                    let uid = json["uid"].string,
                    let message = json["message"].string,
                    let timestamp = json["timestamp"].double as TimeInterval?
                {
                    let comment = Comment(cid: cid, iid: iid, uid: uid, message: message, timestamp: timestamp)
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
extension Comment {
    private static func generate(snapshot: FIRDataSnapshot, process: @escaping (Comment?) -> ()) {
        Comment.from(cid: snapshot.key, process)
    }
    static func forEachCommentRelatedToIID(_ iid: String?, limits: [Limit]? = nil, order: Order? = nil, process: @escaping (Comment?) -> ()) {
        forEachCIDRelatedToIID(iid, limits: limits, order: order) {
            Comment.from(cid: $0, process)
        }
    }
    static func forEachCIDRelatedToIID(_ iid: String?, limits: [Limit]? = nil, order: Order? = nil, process: @escaping (String) -> ()) {
        if let iid = iid {
            forEachRelatedToPath("comments/byIID/\(iid)", limits: limits, order: order) {
                process($0.key)
            }
        }
    }
    static func forEachCommentRelatedToUID(_ uid: String?, limits: [Limit]? = nil, order: Order? = nil, process: @escaping (Comment?) -> ()) {
        forEachCIDRelatedToUID(uid, limits: limits, order: order) {
            Comment.from(cid: $0, process)
        }
    }
    static func forEachCIDRelatedToUID(_ uid: String?, limits: [Limit]? = nil, order: Order? = nil, process: @escaping (String) -> ()) {
        if let uid = uid {
            forEachRelatedToPath("comments/byUID/\(uid)", limits: limits, order: order) {
                process($0.key)
            }
        }
    }
}

extension Comment: Equatable {
    public static func ==(lhs: Comment, rhs: Comment) -> Bool {
        return lhs.cid == rhs.cid
    }
    
}
