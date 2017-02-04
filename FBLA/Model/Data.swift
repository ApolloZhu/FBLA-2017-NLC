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

func forEachRelatedToPath<T>(_ path: String, limit: Int? = nil, order: Order? = nil, once: Bool = true, type: FIRDataEventType = .value, process: @escaping (T?) -> (), generate: @escaping (FIRDataSnapshot, @escaping (T?) -> Void) -> Void) {
    var ref: FIRDatabaseQuery = database.child(path)
    if let limit = limit {
        if limit < 0 {
            ref = ref.queryLimited(toLast: UInt(abs(limit)))
        } else {
            ref = ref.queryLimited(toFirst: UInt(limit))
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
    if once {
        ref.observeSingleEvent(of: type, with: { generate($0, process) })
    } else {
        ref.observe(type, with: { generate($0, process) })
    }
}
