//
//  Extension.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/5/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit

extension UIStoryboardSegue {
    var terminus: UIViewController {
        return (destination as? UINavigationController)?.visibleViewController ?? destination
    }
}

extension CGPoint {
    static func make(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
}

extension URL {
    static var documentDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

extension UIImage {
    func save(withKey key: String) {
        try? UIImagePNGRepresentation(self)?.write(to: URL.documentDirectory.appendingPathComponent(key))
    }
    static func image(fromKey key: String) -> UIImage? {
        return UIImage(contentsOfFile: "\(URL.documentDirectory.appendingPathComponent(key))")
    }
}

protocol SWRevealViewControllerPresentor {
    weak var menuButton: UIBarButtonItem! { get set }
}

extension SWRevealViewControllerPresentor where Self : UIViewController {
    func setupForSWRevealViewController() {
        menuButton?.target = revealViewController()
        menuButton?.action = #selector(revealViewController().revealToggle(_:))
        view?.addGestureRecognizer(revealViewController().panGestureRecognizer())
    }
}

extension UIViewController {
    func presentAccountViewController(animated: Bool = true) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: Identifier.AccountViewController) {
            navigationController?.pushViewController(vc, animated: animated)
        }

    }
}
