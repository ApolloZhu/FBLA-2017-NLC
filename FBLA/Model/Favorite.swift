//
//  Favorite.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/4/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import Firebase

extension Account {

    func favorited(iid: String, process: @escaping (Bool) -> ()) {
        if let uid = uid {
            database.child("favorite/\(uid)/\(iid)").observeSingleEvent(of: .value, with: {
                if $0.value as? Int == 0 {
                    process(true)
                } else {
                    process(false)
                }
            })
        } else {
            process(false)
        }
    }

    func favorite(iid: String) {
        if let uid = uid {
            database.child("favorite/\(uid)/\(iid)").setValue(0)
            database.child("items/byIID/\(iid)").runTransactionBlock { currentData in
                if var json = currentData.json {
                    if let count = json["favorite"].int {
                        json["favorite"].int = count + 1
                    } else {
                        json["favorite"].int = 0
                    }
                    currentData.value = json.dictionaryObject
                    return .success(withValue: currentData)
                }
                return .abort()
            }
        }
    }

    func unfavorite(iid: String) {
        if let uid = uid {
            database.child("favorite/\(uid)/\(iid)").removeValue()
            database.child("items/byIID/\(iid)").runTransactionBlock { currentData in
                if var json = currentData.json {
                    if let count = json["favorite"].int {
                        json["favorite"].int = count - 1
                    }
                    currentData.value = json.dictionaryObject
                    return .success(withValue: currentData)
                }
                return .abort()
            }
        }
    }
}
