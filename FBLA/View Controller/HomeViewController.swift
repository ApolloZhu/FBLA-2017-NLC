//
//  HomeViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/13/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, SWRevealViewControllerPresentor {
    @IBOutlet weak var menuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupForSWRevealViewController()
    }
}

extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //!!!: Remove before final stage
        if segue.identifier == "Test", let vc = segue.terminus as? ItemDisplayViewController {
            vc.iid = "商品标识符"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(pushAccountViewController(animated:)), name: .ShouldPushAccountViewController, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showAboutUsViewController(animated:)), name: .ShouldPushAboutUsViewController, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushAcknowledgementsViewController(animated:)), name: .ShouldPushAcknowledgementsViewController, object: nil)
    }

    @objc fileprivate func showAboutUsViewController(animated: Bool = true) {
        performSegue(withIdentifier: Identifier.ShowAboutUsSegue, sender: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}
