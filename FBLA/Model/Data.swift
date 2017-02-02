//
//  Data.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/2/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import Foundation

protocol Data {
    var json: [String : Any] { get }
    var path: String { get }
}
extension Data {
    func save(completionHandler handle: (() -> ())? = nil) {
        database.child(path).setValue(json) { _,_ in handle?() }
    }
}
