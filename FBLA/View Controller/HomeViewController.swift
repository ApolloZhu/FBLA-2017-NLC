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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(presentAccountViewController(animated:)), name: .ShouldPresentAccountViewController, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //!!!: Remove before final stage
        if segue.identifier == "Test", let vc = segue.terminus as? ItemViewController {
                vc.iid = "2017-2233"
        }
    }

}
