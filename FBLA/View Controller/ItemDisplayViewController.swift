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


extension Identifier {
    static let ShowMoreCommentsSegue = "ShowMoreCommentsSegue"
    static let ItemTextCell = "ItemTextCell"
}

class ItemDisplayViewController: UITableViewController {
    
    var iid: String! {
        didSet {
            Item.inSellItemFrom(iid: iid) { [weak self] in
                self?.item = $0
            }
        }
    }
    var item: Item? {
        didSet {
            reload()
        }
    }
    
    @objc private func pay() {
        Item.inSellItemFrom(iid: iid) { [weak self] item in
            if let this = self, let item = item {
                this.checkOut(item: item)
            } else {
                showError(Localized.CHECKOUT_ERROR)
            }
        }
    }
    
    var comments = [Comment]()
    
    func loadComments() {
        Comment.forEachRelatedToIID(iid, limits: [.number(-3)], once: false, type: .childAdded)
        {
            [weak self] in
            if let this = self,
                let comment = $0 {
                let i = this.comments.insertionPoint(for: comment) { calender.compare($0.date, to: $1.date, toGranularity: Calendar.Component.nanosecond) == .orderedDescending }
                if i >= this.comments.count || i < 0 {
                    this.comments.append(comment)
                } else {
                    if this.comments[i] != comment {
                        this.comments.insert(comment, at: i)
                    } else {
                        return
                    }
                }
                this.tableView.insertRows(at: [IndexPath(row: this.comments.count - 1, section: 3)], with: .automatic)
            }
        }
    }
    
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
        case 3: // 5 Comments, and button to show more
            return comments.count + 1
        default:
            return 0
        }
    }
    
    private var _shouldSetImage = true
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 2):
            return itemConditionTableViewCell(for: item)
            
        case (0, 3):
            return itemImageTableViewCell(for: item)
            
        case (0, let index):
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.ItemTextCell
                )!
            if index == 0 {
                cell.textLabel?.font = .systemFont(ofSize: 25)
                cell.textLabel?.text = item?.name
            } else {
                cell.textLabel?.text = item?.description
            }
            return cell
            
        case (1, _):
            return itemPurchaseTableViewCell(for: item)
            
        case (3, comments.count):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowMoreCommentCell")!
            cell.textLabel?.text = Localized.MORE_COMMENT
            return cell
        case (3, let index):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCommentCell")!
            let comment = comments[index]
            User.from(uid: comment.uid) { user in
                cell.textLabel?.text = user?.name
                cell.detailTextLabel?.text = comment.message
                cell.imageView?.kf.setImage(with: user?.photoURL, placeholder: #imageLiteral(resourceName: "ic_person_48pt"))
            }
            return cell
        default: break
        }
        return .init()
    }
    
    // MARK: To auto layout
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: To show more comments
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 && indexPath.row == comments.count {
            performSegue(withIdentifier: Identifier.ShowMoreCommentsSegue, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let item = item, segue.identifier == Identifier.ShowMoreCommentsSegue, let vc = segue.terminus as? ItemCommentsViewController {
            vc.setup(iid: iid, sellerUID: item.uid)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadComments()
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(pay), name: .ShouldCheckOutItem, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .ShouldUpdate, object: nil)
        ItemDisplayToolbar.shared.showForIID(iid)
        ItemDisplayToolbar.shared.delegate = self
        requestUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        ItemDisplayToolbar.shared.hide()
    }
}

extension ItemDisplayViewController: ItemDisplayToolbarDelegate {
    func showCommentInput(iid: String?) {
        CommentInput.shared.show(for: iid)
    }
    func hideCommentInput() {
        CommentInput.shared.hide()
    }
}
