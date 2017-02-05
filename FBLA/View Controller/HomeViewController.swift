//
//  HomeViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/13/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import VTAcknowledgementsViewController

class HomeViewController: UIViewController, SWRevealViewControllerPresentor {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //!!!: Remove at final stage
    @IBAction func test() {
        displayItemWithIID("2017-2233")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForSWRevealViewController()
    }
}

extension HomeViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushAccountViewController(animated:)), name: .ShouldPushAccountViewController, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showMessagesViewController), name: .ShouldPushMessagesViewController, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showFavorites), name: .ShouldShowFavorites, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showBought), name: .ShouldShowBought, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showDonated), name: .ShouldShowDonated, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(showLanguagesViewController), name: .ShouldPushLanguagesViewController, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showAboutUsViewController), name: .ShouldPushAboutUsViewController, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushAcknowledgementsViewController), name: .ShouldPushAcknowledgementsViewController, object: nil)
    }
    
    @objc private func showMessagesViewController() {
        
    }
    
    @objc private func showFavorites() {
        if let vc = itemsTableViewController(), let uid = Account.shared.uid {
            DispatchQueue.global(qos: .userInteractive).async {
                Account.forEachFavoritedIIDByUID(uid) { vc.add(iid: $0, state: .favorited) }
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func showBought() {
        if let vc = itemsTableViewController(), let uid = Account.shared.uid {
            DispatchQueue.global(qos: .userInteractive).async {
                Item.forEachBoughtIIDByUID(uid) { vc.add(iid: $0, state: .bought) }
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func showDonated() {
        if let vc = itemsTableViewController(), let uid = Account.shared.uid {
            DispatchQueue.global(qos: .userInteractive).async {
                Item.forEachInSellIIDFromUID(uid) { vc.add(iid: $0, state: .inSell) }
                Item.forEachBoughtIIDFromUID(uid) { vc.add(iid: $0, state: .bought) }
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func showLanguagesViewController() {
        performSegue(withIdentifier: Identifier.ShowLanguagesSegue, sender: self)
    }
    
    @objc private func showAboutUsViewController() {
        performSegue(withIdentifier: Identifier.ShowAboutUsSegue, sender: self)
    }
    
    @objc private func pushAcknowledgementsViewController() {
        navigationController?.pushViewController(VTAcknowledgementsViewController(fileNamed: "Pods-FBLA-acknowledgements")!, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}
