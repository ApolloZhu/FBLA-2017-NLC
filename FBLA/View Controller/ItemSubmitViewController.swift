//
//  ItemSubmitViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/31/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import PKHUD
import Firebase
import Eureka
import ImageRow

class ItemSubmitViewController: FormViewController {

    var shouldAllowSubmit: Bool {
        var flag = true
        flag = flag && nameRow.value != nil
        flag = flag && descriptionRow.value != nil
        flag = flag && imageRow.value != nil
        flag = flag && conditionRow.value != nil
        flag = flag && priceRow.value != nil
        return flag
    }

    lazy var nameRow = TextRow("0")
    { $0.title = NSLocalizedString("Item Name", comment: "Input name of the item") }

    lazy var descriptionRow = TextAreaRow("1")
    { $0.title = NSLocalizedString("Item Description", comment: "Input description of item") }

    lazy var imageRow = ImageRow("2") {
        $0.title = NSLocalizedString("Item Photo", comment: "Select photo of item")
        $0.clearAction = .no
    }

    lazy var conditionRow = PickerInlineRow<Condition>("3") {
        $0.title = NSLocalizedString("Condition", comment: "Condition of item")
        $0.options = Condition.all
    }

    lazy var priceRow = DecimalRow("4") {
        $0.title = NSLocalizedString("Price in USD", comment: "Price of item in us dollar")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section(NSLocalizedString("Basic Information", comment: "Basic information of item"))
            <<< nameRow
            <<< descriptionRow
            <<< imageRow

            +++ Section(NSLocalizedString("Details", comment: "Details of the item"))
            <<< conditionRow
            <<< priceRow

            +++ Section()
            <<< ButtonRow {
                $0.title = Localized.CANCEL
                $0.cell.textLabel?.textColor = .red
                }.onCellSelection { [weak self] _, _ in self?.clear() }
            <<< ButtonRow {
                $0.title = Localized.DONE
                $0.hidden = Eureka.Condition.function((0...4).map{"\($0)"}) { [weak self] _ in
                    return !(self?.shouldAllowSubmit ?? false)
                }
                }.onCellSelection{ [weak self] _, _ in self?.submit() }
    }

    func clear() {
        HUD.show(.labeledProgress(title: Localized.PROCESSING, subtitle: nil))
        view.isUserInteractionEnabled = false
        nameRow.value = nil
        descriptionRow.value = nil
        imageRow.value = nil
        conditionRow.value = nil
        priceRow.value = nil
        nameRow.updateCell()
        descriptionRow.updateCell()
        imageRow.updateCell()
        conditionRow.updateCell()
        priceRow.updateCell()
        view.isUserInteractionEnabled = true
        HUD.hide()
    }

    func submit() {
        if !Account.shared.isLogggedIn {
            presentLoginViewController()
        } else {
            let iid = database.child("items").childByAutoId().key
            if let name = nameRow.value,
                let uid = Account.shared.user?.uid,
                let description = descriptionRow.value,
                let image = imageRow.value,
                let price = priceRow.value,
                let condition = conditionRow.value
            {
                HUD.show(.labeledProgress(title: Localized.PROCESSING, subtitle: nil))
                view.isUserInteractionEnabled = false
                // Store image to drive
                storage.child("itemIMG/\(iid)").put(UIImagePNGRepresentation(image)!, metadata: nil)
                { [weak self] meta in self?.clear() }
                // Relate to user
                database.child("userData/\(uid)/sold").childByAutoId().setValue(iid)
                // Store item to database
                Item(iid: iid, uid: uid,
                     name: name, description: description,
                     price: price, condition: condition,
                     favorite: 0
                    ).save()
                
            }
        }
    }
}
