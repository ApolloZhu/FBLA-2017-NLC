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
    static let translators = ["Apollo Zhu", "Khan Mujtaba", "Seonuk Kim"]

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Locale.current.localizedString(forLanguageCode: localizations[0])
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return localizations.count
        } else {
            return LanguagesTableViewController.translators.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        if indexPath.section == 0 {
            cell.textLabel?.text = localizations[indexPath.row]
        } else {
            cell.textLabel?.text = LanguagesTableViewController.translators[indexPath.row]
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            UserDefaults.standard.set([localizations[indexPath.row]], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
    }
}
