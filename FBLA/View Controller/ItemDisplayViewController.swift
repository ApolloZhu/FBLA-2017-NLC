//
//  ItemDisplayViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/5/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyStarRatingView

extension UIViewController {
    func displayItemWithIID(_ iid: String) {
        tabBarController?.hidesBottomBarWhenPushed = true
        guard let vc = storyboard?.instantiateViewController(withIdentifier: Identifier.ItemDisplayViewController) as? ItemDisplayViewController else { return }
        vc.iid = iid
        if let nav = navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            let nav = UINavigationController(rootViewController: vc)
            vc.navigationItem.hidesBackButton = false
            vc.navigationItem.backBarButtonItem?.action = #selector(animatedDismiss)
            present(nav, animated: true, completion: nil)
        }
    }
}

extension Notification.Name {
    static let ShouldCheckOutItem = Notification.Name("ShoudCheckOutItem")
}

class ItemDisplayViewController: UITableViewController {

    var iid: String?
    @IBOutlet weak var itemView: ItemDisplayView?
    lazy var toolbar: ItemDisplayToolbar = .init()

    @objc private func pay() {
        Item.from(iid: iid) { [weak self] item in
            if let this = self, let item = item {
                this.checkOut(item: item)
            } else {
                showError(Localized.CHECKOUT_ERROR)
            }
        }
    }

    @objc private func update() {
        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        itemView?.iid = iid
        itemView?.snp.makeConstraints { make in
            make.horizontallyCenterInSuperview()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(pay), name: .ShouldCheckOutItem, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .ShouldReloadComments, object: nil)
        toolbar.iid = iid
        toolbar.show()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        toolbar.hide()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let height = itemView?.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height {
            itemView?.frame.size.height = height
        }
    }
}
