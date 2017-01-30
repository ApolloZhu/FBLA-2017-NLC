//
//  Condition.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/29/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import Foundation

enum Condition: Int {
    case bad
    case acceptable
    case veryGood
    case likeNew
    case refurbished
}

extension Condition: CustomStringConvertible {
    var description: String {
        switch self {
        case .bad :
            return NSLocalizedString("Bad", comment: "Condition of item is bad")
        case .acceptable:
            return NSLocalizedString("Acceptable", comment: "Condition of item is acceptable")
        case .veryGood:
            return NSLocalizedString("Very Good", comment: "Condition of item is very good")
        case .likeNew:
            return NSLocalizedString("Like New", comment: "Condition of item is like new")
        case .refurbished:
            return NSLocalizedString("Refurbished", comment: "Condition of item is refurbished")
        }
    }
}
