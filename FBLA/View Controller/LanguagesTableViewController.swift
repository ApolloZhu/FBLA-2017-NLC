//
//  LanguagesTableViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/5/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import PKHUD

extension Localized {
    static let LOCAL_LANG = NSLocalizedString("English", comment: "Name of the language in its own. e.g. English for en, Español for spanish")
    static let LANG = NSLocalizedString("Languages", comment: "Title for list of languages available")
}

class LanguagesTableViewController: UITableViewController {
    
    lazy var localizations: [String] = {
        return Bundle.main.localizations.filter { $0 != "Base" }
    }()
    static let translators = ["Apollo Zhu", "Khan Mujtaba", "Seonuk Kim"]
    
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
            cell.textLabel?.text = Locale(identifier: localizations[indexPath.row]).localizedString(forLanguageCode: localizations[indexPath.row])
        } else {
            cell.textLabel?.text = LanguagesTableViewController.translators[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return Localized.LANG
        }
        if section == 1{
            return NSLocalizedString("Translators", comment: "Title for list of translators")
        }
        return nil
    }
    
    private var _lastSelected: Int?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let target = localizations[indexPath.row]
            if Bundle.main.preferredLocalizations.first != target {
                switchTo(preferredLocale: target)
            }
        }
    }
    
    func switchTo(preferredLocale: String) {
        var bundle = Bundle.main
        if let path = bundle.path(forResource: preferredLocale, ofType: "lproj") {
            if let preferredBundle = Bundle(path: path) {
                bundle = preferredBundle
            }
        }
        let alertController = UIAlertController(
            title: NSLocalizedString("Restart", bundle: bundle, comment: "Restart the app"),
            message: NSLocalizedString("To change the language, you must reopen the app", bundle: bundle, comment: "Appears in a pop up when user try to change language"),
            preferredStyle: .alert
        )

        let restart = UIAlertAction(title: NSLocalizedString("OK", bundle: bundle, comment: "Cool to restart the app"), style: .destructive)
        { _ in
            UserDefaults.standard.set([preferredLocale], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            exit(0)
        }
        alertController.addAction(restart)
        let cancel = UIAlertAction(title: bundle.localizedString(forKey: "Cancel", value: Localized.CANCEL, table: nil), style: .cancel, handler: nil)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
}
