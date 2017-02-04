//
//  CommentInput.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/2/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import MaterialKit
import SnapKit

extension Localized {
    static let MORE_COMMENT = NSLocalizedString("Show more comments", comment: "User cilcks here to view more comments")
    static let COMMENT_HERE = NSLocalizedString("Leave your comment here ~", comment: "Prompt in input textfield to tell the user to input comment here")
    static let NO_COMMENT = NSLocalizedString("No comment yet", comment: "Displays when user trying to get list of comments of an item, but no comment exists.")
}

class CommentInput: NSObject, UITextFieldDelegate {
    public static let shared = CommentInput()
    override private init() {}

    private lazy var textField: MKTextField = {
        let tf = MKTextField()
        tf.borderStyle = .line
        tf.layer.borderColor = UIColor.tianyi.cgColor
        tf.layer.borderWidth = 5
        tf.backgroundColor = .white
        tf.tintColor = .tianyi
        tf.placeholder = Localized.COMMENT_HERE
        return tf
    }()

    private var iid: String?
    func show(for iid: String?) {
        hide()
        self.iid = iid
        UIApplication.shared.keyWindow!.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.centerX.bottom.width.equalToSuperview()
            make.height.equalTo(60)
        }
        textField.inputAccessoryView = textField
        textField.becomeFirstResponder()
        textField.delegate = self

        let sendButton = UIButton(image: #imageLiteral(resourceName: "ic_send"))
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
        textField.rightView = sendButton
        textField.rightViewMode = .whileEditing

        let cancel = UIButton(image: #imageLiteral(resourceName: "ic_clear"))
        cancel.addTarget(self, action: #selector(hide), for: .touchUpInside)
        textField.leftView = cancel
        textField.leftViewMode = .whileEditing
    }

    func hide() {
        textField.resignFirstResponder()
        textField.removeFromSuperview()
    }

    func send() {
        textField.resignFirstResponder()
        if let iid = iid, let message = textField.text?.content, !message.isBlank {
            DispatchQueue.global(qos: .userInteractive).async {
                Comment.new { cid in
                    return Comment(cid: cid, iid: iid, uid: Account.shared.uid ?? "0", message: message)
                }
            }
            textField.text = nil
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        send()
        return true
    }
}
