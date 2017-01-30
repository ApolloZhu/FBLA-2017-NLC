//
//  ItemViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/5/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

class ItemViewController: UIViewController {

    var iid: String?
    @IBOutlet weak var itemView: ItemView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemView.iid = iid
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
