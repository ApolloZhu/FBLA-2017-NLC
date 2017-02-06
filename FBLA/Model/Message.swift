//
//  Message.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/5/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import Foundation
import GooglePlaces

struct Message {

}

extension Message {

    static func pickUp(item: Item, by customerUID: String, from donatorUID: String, at location: GMSPlace) {
        let msg2Customer = String(format: NSLocalizedString("Pick up %1$@ at %2$@ from %3$@", comment: "Pick up {item} at {location} from {donator}"), item.name, location.formattedAddress!, donatorUID)
        let msg2Donator = String(format: NSLocalizedString("%1$@ will come and pick up %2$@", comment: "{customer} will come and pick up {item}"), customerUID, item.name)
    }
    static func ship(item: Item, from donatorUID: String, by customerUID: String, at location: GMSPlace) {
        let msg2Customer = String(format: NSLocalizedString("%1$@ will ship %2$@ to you", comment: "{donator} will ship {item} to you"), item.name, location.formattedAddress!, donatorUID)
        let msg2Donator = String(format: NSLocalizedString("You should ship %1$@ to %2$@ at %3$@", comment: "You should ship {item} to {customer} at {location}"), customerUID, item.name, location.formattedAddress!)
    }
}
