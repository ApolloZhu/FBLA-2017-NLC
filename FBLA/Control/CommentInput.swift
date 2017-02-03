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
        tf.placeholder = NSLocalizedString("Your comment here ~", comment: "Prompt in input textfield to tell the user to input comment here")
        return tf
    }()
    
    private var iid: String?
    func show(for iid: String?) {
        hide()
        self.iid = iid
        UIApplication.shared.keyWindow!.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.centerX.centerY.width.equalToSuperview()
            make.height.equalTo(60)
        }
        textField.inputAccessoryView = textField
        textField.becomeFirstResponder()
        textField.delegate = self
    }
    
    func hide() {
        textField.resignFirstResponder()
        textField.removeFromSuperview()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let iid = iid, let message = textField.text?.content {
            DispatchQueue.global(qos: .userInteractive).async {
                Comment.new { cid in
                    return Comment(cid: cid, iid: iid, uid: Account.shared.uid ?? "0", message: message)
                }
            }
            textField.text = nil
        }
        return true
    }
}
