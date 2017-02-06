//
//  Message.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/5/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import Foundation
import GooglePlaces
import Firebase

struct Event {
    let eid: String
    let uid: String
    
    let type: EventType
    let components: [String]
    
    var json: [String:Any] {
        return [
            "type": type.rawValue,
            "components": components
        ]
    }
    func save() {
        database.child("msg/\(uid)/repo/\(eid)").setValue(json)
    }
}

enum EventType: Int, CustomStringConvertible {
    case buyPickUpFromSell
    case sellWaitBuyPickingUp
    case buyWaitSellShip
    case sellShipToBuy
    var description: String {
        switch self {
        case .buyPickUpFromSell:
            return NSLocalizedString("Pick up %1$@ at %2$@ from %3$@", comment: "Pick up {item} at {location} from {donator}")
        case .sellWaitBuyPickingUp:
            return NSLocalizedString("%1$@ will come and pick up %2$@", comment: "{customer} will come and pick up {item}")
        case .buyWaitSellShip:
            return NSLocalizedString("%1$@ will ship %2$@ to you", comment: "{donator} will ship {item} to you")
        case .sellShipToBuy:
            return NSLocalizedString("You should ship %1$@ to %2$@ at %3$@", comment: "You should ship {item} to {customer} at {location}")
        }
    }
}

extension Event {
    static func when(customer customerUID: String, willPickUp item: Item, from donatorUID: String, at location: GMSPlace) {
        new(uid: customerUID, type: .buyPickUpFromSell, components: [item.name, location.formattedAddress ?? location.description, donatorUID])
        new(uid: donatorUID, type: .sellWaitBuyPickingUp, components: [customerUID, item.name])
    }
    static func when(donator donatorUID: String, willShip item: Item, to customerUID: String, at location: GMSPlace) {
        new(uid: customerUID, type: .buyWaitSellShip, components: [donatorUID, item.name])
        new(uid: donatorUID, type: .sellShipToBuy, components: [item.name, customerUID, location.formattedAddress ?? location.description])
    }
}

extension Event {
    static func fromEID(_ eid: String, process: @escaping (Event?) -> ()) {
        if let uid = Account.shared.uid {
            database.child("msg/\(uid)/repo/\(eid)").observeSingleEvent(of: .value, with: {
                if let json = $0.json,
                    let raw = json["type"].int,
                    let type = EventType(rawValue: raw)
                {
                    let components = json["components"].arrayValue.map({$0.stringValue}).filter({!$0.isBlank})
                    process(Event(eid: $0.key, uid: uid, type: type, components: components))
                } else {
                    process(nil)
                }
            })
        }
    }
    
    static func new(uid: String, type: EventType, components: [String]) {
        let eid = database.child("msg/\(uid)/repo").childByAutoId().key
        Event(eid: eid, uid: uid, type: type, components: components).save()
    }
}

extension Event {
    static func forEachEventOfUID(_ uid: String, limits: [Limit]? = nil, order: Order? = nil, process: @escaping (Event?) -> ()) {
        forEachEIDOfUID(uid, limits: limits, order: order) {
            fromEID($0, process: process)
        }
    }
    static func forEachEIDOfUID(_ uid: String, limits: [Limit]? = nil, order: Order? = nil, process: @escaping (String) -> ()) {
        forEachRelatedToPath("msg/\(uid)/repo", limits: limits, order: order) {
            process($0.key)
        }
    }
}

extension Event {
    static func clearAllUnreadEvents() {
        if let uid = Account.shared.uid {
            database.child("msg/\(uid)/count").removeValue()
        }
    }
    static func incrementUnreadMessages(by amount: Int) {
        if let uid = Account.shared.uid {
            countUnreadEvents { database.child("msg/\(uid)/count").setValue($0 + amount) }
        }
    }
    static func countUnreadEvents(process: @escaping (Int) -> ()) {
        if let uid = Account.shared.uid {
            database.child("msg/\(uid)/count").observeSingleEvent(of: .value, with: {
                process($0.value as? Int ?? 0)
            })
        }
    }
}
