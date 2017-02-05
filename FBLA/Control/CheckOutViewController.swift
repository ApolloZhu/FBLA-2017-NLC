//
//  CheckOutViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/31/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import PKHUD
import Braintree

extension UIViewController {
    func checkOut(item: Item) {
        if !Account.shared.isLogggedIn {
            presentLoginViewController()
        } else {
            let dropIn = BTDropInViewController(apiClient: .shared)
            let checkOutRootViewController = CheckOutViewController(rootViewController: dropIn)
            
            checkOutRootViewController.item = item
            checkOutRootViewController.uid = Account.shared.uid
            
            let paymentRequest = BTPaymentRequest()
            paymentRequest.summaryTitle = item.name
            paymentRequest.summaryDescription = item.description
            paymentRequest.displayAmount = "$\(item.price)"
            paymentRequest.callToActionText = NSLocalizedString("Pay", comment: "Click to pay")
            paymentRequest.shouldHideCallToAction = false
            
            dropIn.delegate = checkOutRootViewController
            dropIn.paymentRequest = paymentRequest
            dropIn.title = NSLocalizedString("Check Out", comment: "To complete payment at this page")
            
            dropIn.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(hideCheckOutViewController))
            present(checkOutRootViewController, animated: true, completion: nil)
        }
    }
    @objc private func hideCheckOutViewController() {
        animatedDismiss()
    }
}

class CheckOutViewController: UINavigationController, BTDropInViewControllerDelegate {
    public var item: Item?
    public var uid: String?
    public func drop(_ viewController: BTDropInViewController, didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce) {
        let paymentURL = URL(string: "https://fbla-2017-nlc-braintree.herokuapp.com/payment-methods")!
        var request = URLRequest(url: paymentURL)
        request.httpBody = "payment_method_nonce=\(paymentMethodNonce)".data(using: .utf8)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { _,_,_ in } .resume()
        item!.sellToUID(uid!)
        HUD.flash(.success, delay: 1) { [weak self] _ in self?.animatedDismiss() }
    }
    public func drop(inViewControllerDidCancel viewController: BTDropInViewController) {
        animatedDismiss()
    }
}
