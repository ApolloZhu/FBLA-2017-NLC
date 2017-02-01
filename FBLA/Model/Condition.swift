//
//  Condition.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/29/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import Foundation

enum Condition: Int, RawRepresentable {
    case collectible
    case acceptable
    case veryGood
    case likeNew
    case refurbished
    static let all: [Condition] = [.collectible, .acceptable, .veryGood, .likeNew, .refurbished]
}

extension Condition: CustomStringConvertible {
    var description: String {
        switch self {
        case .collectible:
            return NSLocalizedString("Collectible", comment: "Condition of item is rather for collec†ion only")
        case .acceptable:
            return NSLocalizedString("Acceptable", comment: "Condition of item is acceptable")
        case .veryGood:
            return NSLocalizedString("Very Good", comment: "Condition of item is very good")
        case .likeNew:
            return NSLocalizedString("Like New", comment: "Condition of item is like new")
        case .refurbished:
            return NSLocalizedString("Refurbished", comment: "Condition of item is has been refurbished")
        }
    }
}
