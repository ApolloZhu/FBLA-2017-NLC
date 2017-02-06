//
//  FilterViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/5/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import Eureka
import PKHUD

extension Localized {
    static let CLEAR = NSLocalizedString("Clear", comment: "Clear all contents that is currently in the/a input")
}

class FilterViewController: FormViewController {
    var filters: [Filter] {
        var f = [Filter]()
        if let amount = lowPriceRow.value
        { f.append(.minPrice(amount)) }
        if let amount = highPriceRow.value
        { f.append(.maxPrice(amount)) }
        if let condition = conditionRow.value
        { f.append(.condition(condition)) }
        if let method = shippingRow.value
        { f.append(.transfer(method)) }
        return f
    }
    
    lazy private var lowPriceRow = DecimalRow("0") {
        $0.title = Localized.MIN_PRICE
    }
    
    lazy private var highPriceRow = DecimalRow("1") {
        $0.title = Localized.MAX_PRICE
    }
    
    lazy private var conditionRow = PickerInlineRow<Condition>("2") {
        $0.title = Localized.ITEM_CONDITION
        $0.options = Condition.all
    }
    
    lazy private var shippingRow = PickerInlineRow<Transfer>("3") {
        $0.title = Localized.TRANSFER_METHOD
        $0.options = [.ship, .pickUp]
    }
    
    func clear() {
        HUD.show(.labeledProgress(title: Localized.PROCESSING, subtitle: nil))
        view.isUserInteractionEnabled = false
        lowPriceRow.value = nil
        highPriceRow.value = nil
        conditionRow.value = nil
        shippingRow.value = nil
        lowPriceRow.updateCell()
        highPriceRow.updateCell()
        conditionRow.updateCell()
        shippingRow.updateCell()
        view.isUserInteractionEnabled = true
        HUD.hide()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form
            +++ Section(Localized.FILTER)
            <<< lowPriceRow
            <<< highPriceRow
            <<< conditionRow
            <<< shippingRow
            
            +++ Section()
            <<< ButtonRow {
                $0.title = Localized.CLEAR
                }.onCellSelection { [weak self] _, _ in self?.clear() }
    }
}
