//
//  Data.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/3/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import Firebase

enum Order {
    case key
    case value
    case priority
    case child(String)
}

enum Limit {
    case number(Int)
    case start(String)
    case end(String)
}

func forEachRelatedToPath(_ path: String, limits: [Limit]? = nil, order: Order? = nil, process: @escaping (FIRDataSnapshot) -> ()) {
    var ref: FIRDatabaseQuery = database.child(path)
    if let limits = limits {
        for limit in limits {
            switch limit {
            case .number(let count):
                if count < 0 {
                    ref = ref.queryLimited(toLast: UInt(abs(count)))
                } else {
                    ref = ref.queryLimited(toFirst: UInt(count))
                }
            case .start(let key):
                ref = ref.queryStarting(atValue: key)
            case .end(let key):
                ref = ref.queryEnding(atValue: key)
            }
        }
    }
    if let order = order {
        switch order {
        case .key:
            ref = ref.queryOrderedByKey()
        case .value:
            ref = ref.queryOrderedByValue()
        case .priority:
            ref = ref.queryOrderedByPriority()
        case .child(let path):
            ref = ref.queryOrdered(byChild: path)
        }
    }
    ref.observe(.childAdded, with: { process($0) })
}
