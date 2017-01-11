//
//  HamburgerButton.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/11/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit

@IBDesignable
class HamburgerButton: UIButton {

    @IBInspectable var lineWidth: CGFloat = 0.15
        { didSet { setNeedsDisplay() } }

    @IBInspectable var span: CGFloat = 0.9
        { didSet { setNeedsDisplay() } }

    override var tintColor: UIColor!
        { didSet { setNeedsDisplay() } }

    override func draw(_ rect: CGRect) {
        let total = min((rect.width - contentEdgeInsets.left - contentEdgeInsets.right), (rect.height - contentEdgeInsets.top - contentEdgeInsets.bottom))

        let interval = total * span / 2
        let leftX = rect.midX - interval
        let rightX = rect.midX + interval
        let upY = rect.midY - interval / 2
        let bottomY = rect.midY + interval / 2

        let path = UIBezierPath()
        path.move(to: .make(leftX, upY))
        path.addLine(to: .make(rightX, upY))
        path.move(to: .make(leftX, rect.midY))
        path.addLine(to: .make(rightX, rect.midY))
        path.move(to: .make(leftX, bottomY))
        path.addLine(to: .make(rightX, bottomY))

        path.lineWidth = total * lineWidth
        path.lineCapStyle = .round
        tintColor?.setStroke()
        path.stroke()
    }
}
