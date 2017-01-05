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
