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
    static let ShouldUpdate = Notification.Name("ShouldUpdate")
}

class ItemDisplayViewController: UITableViewController {
    
    var iid: String? {
        didSet {
            Item.from(iid: iid) { [weak self] in
                self?.item = $0
            }
        }
    }
    var item: Item? {
        didSet {
            update()
        }
    }
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
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        itemView?.iid = iid
    //        itemView?.snp.makeConstraints { make in
    //            make.horizontallyCenterInSuperview()
    //        }
    //    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(pay), name: .ShouldCheckOutItem, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .ShouldUpdate, object: nil)
        toolbar.iid = iid
        toolbar.show()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        toolbar.hide()
    }
    
    //    override func viewWillLayoutSubviews() {
    //        super.viewWillLayoutSubviews()
    //        if let height = itemView?.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height {
    //            itemView?.frame.size.height = height
    //        }
    //    }
    
    var comments = [Comment]()
    
    // MARK: Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // Information
            return 4
        case 1: // Buy
            return 1
        case 2: // Rating
            return 1
        case 3: // 3 Comments, and button to show more
            return comments.count + 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 2):
            let custom = tableView.dequeueReusableCell(withIdentifier: "ItemConditionCell") as! ItemConditionTableViewCell
            custom.condition = item?.condition
            return custom
        case (0, 3):
            let custom = tableView.dequeueReusableCell(withIdentifier: "ItemImageCell") as! ItemImageTableViewCell
            item?.fetchImageURL {
                custom.imageURL = $0
            }
            return custom
        case (0, let index):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTextCell")!
            if index == 0 {
                cell.textLabel?.font = .systemFont(ofSize: 25)
                cell.textLabel?.text = item?.name
            } else {
                cell.textLabel?.text = item?.description
            }
            return cell
        case (1, _):
            let custom = tableView.dequeueReusableCell(withIdentifier: "ItemPurchaseCell") as! ItemPurchaseTableViewCell
            custom.price = item?.price
            return custom
        default: break
        }
        return .init()
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
