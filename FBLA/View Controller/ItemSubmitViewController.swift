//
//  ItemSubmitViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/31/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import Firebase
import Eureka
import ImageRow

class ItemSubmitViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section(NSLocalizedString("Basic Information", comment: "Basic information of item"))
            <<< TextRow { $0.title = NSLocalizedString("Item Name", comment: "Input name of the item") }
            <<< TextAreaRow { $0.title = NSLocalizedString("Item Description", comment: "Input description of item") }
            <<< ImageRow { $0.title = NSLocalizedString("Item Photo", comment: "Select photo of item"); $0.clearAction = .no }
            
            +++ Section(NSLocalizedString("Details", comment: "Details of the item"))
            <<< PickerInlineRow<Condition> { $0.title = NSLocalizedString("Condition", comment: "Condition of item"); $0.options = Condition.all }
            <<< DecimalRow { $0.title = NSLocalizedString("Price in USD", comment: "Price of item in us dollar"); }
            
            +++ Section()
            <<< ButtonRow {
                $0.title = Localized.DONE
                $0.hidden = Eureka.Condition.function([]) {
                    return !$0.allRows.dropLast().reduce(true) { $0 && ($1.baseValue != nil) }
                }
                }.onCellSelection{ [weak self] _, _ in self?.submit() }
    }
    
    func submit() {
        if !Account.shared.isLogggedIn {
            showLoginViewController()
        } else {
            let iid = database.child("items").childByAutoId().key
            Item(
                iid: iid, uid: Account.shared.user!.uid,
                name: (form.rows[0] as! TextRow).value!,
                description: (form.rows[1] as! TextAreaRow).value!,
                price: (form.rows[4] as! DecimalRow).value!,
                condition: Condition(rawValue: (form.rows[3] as! PickerInlineRow).value!) ?? .acceptable,
                imagePath: "",
                favorite: 0
            ).save()
        }
    }
}
