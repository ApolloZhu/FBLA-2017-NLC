//
//  CTTextField.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/25/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import MaterialKit

public enum CTTextFieldType {
    case `default`
    case email
    case password
    case autoCorrecting
}

open class CTTextField: MKTextField {
    convenience public init(prompt: String? = nil, type: CTTextFieldType = .default)
    { self.init(frame: .zero, prompt: prompt, type: type) }

    override convenience init(frame: CGRect)
    { self.init(frame: frame, prompt: nil) }

    public init(frame: CGRect, prompt: String? = nil, type: CTTextFieldType = .default) {
        super.init(frame: frame)
        setup(prompt: prompt, type: type)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public var content: String? {
        return text?.content
    }

    private func setup(prompt: String? = nil, type: CTTextFieldType = .default, enableAI: Bool = false) {
        bottomBorderEnabled = true
        clearButtonMode = .whileEditing
        layer.borderColor = UIColor.clear.cgColor

        if type != .autoCorrecting {
            autocapitalizationType = .none
            autocorrectionType = .no
            spellCheckingType = .no
            switch type {
            case .email:
                keyboardType = .emailAddress
            case .password:
                isSecureTextEntry = true
            default: break
            }
        }

        textAlignment = .center
        backgroundColor = .white
        tintColor = .tianyi // Cursor
        roundingCorners = .allCorners
        cornerRadius = 10
        placeholder = prompt
    }
}
