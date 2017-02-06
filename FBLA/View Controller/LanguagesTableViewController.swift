//
//  LanguagesTableViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/5/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit

extension Localized {
    static let LOCAL_LANG = NSLocalizedString("English", comment: "Name of the language in its own. e.g. English for en, Español for spanish")
}

class LanguagesTableViewController: UITableViewController {

    lazy var localizations: [String] = {
        return Bundle.main.localizations.filter { $0 != "Base" }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
