//
//  Extension.swift
//  FBLA
//
//  Created by Apollo Zhu on 1/5/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import SnapKit
import PKHUD
import CoreLocation
import Firebase
import SwiftyJSON
import Braintree
import VTAcknowledgementsViewController

extension BTAPIClient {
    static let shared = BTAPIClient(authorization: "sandbox_ws7w46d8_sjx3gtf3zg6bf66y")!
}

extension ConstraintMaker {
    func horizontallyCenterInSuperview() {
        centerX.equalToSuperview()
        width.equalToSuperview().offset(-16)
    }
    func horizontallyCenterIn(other: ConstraintRelatableTarget) {
        centerX.equalTo(other)
        width.equalTo(other).offset(-16)
    }
}

let database = FIRDatabase.database().reference()
let storage = FIRStorage.storage().reference(forURL: "gs://charity-toaster.appspot.com")
let defaults = UserDefaults.standard

extension FIRDataSnapshot {
    var json: JSON? {
        if let value = value {
            return JSON(value)
        }
        return nil
    }
    var dictionary: [String:Any]? {
        return value as? [String:Any]
    }
}

extension FIRMutableData {
    var json: JSON? {
        if let value = value {
            return JSON(value)
        }
        return nil
    }
}

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
    static func image(fromKey key: String?) -> UIImage? {
        if let key = key {
            return UIImage(contentsOfFile: "\(URL.documentDirectory.appendingPathComponent(key))")
        }
        return nil
    }
}

extension UILabel {
    static func makeAutoAdjusting(_ content: String? = nil, fontSize: CGFloat? = nil, lines: Int? = nil) -> UILabel {
        let label = UILabel()
        if let content = content {
            label.text = content
        }
        if let fontSize = fontSize {
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
        if let lines = lines {
            label.numberOfLines = lines
        }
        label.adjustsFontSizeToFitWidth = true
        if #available(iOS 10.0, *) {
            label.adjustsFontForContentSizeCategory = true
        }
        return label
    }
    func centered() -> UILabel {
        textAlignment = .center
        baselineAdjustment = .alignCenters
        return self
    }
}

extension UIButton {
    convenience init(image: UIImage) {
        self.init(frame: CGRect(origin: .zero, size: image.size))
        contentMode = .scaleAspectFit
        setImage(image, for: .normal)
    }
}

extension UIColor {
    static let tianyi = UIColor(red: 0.4, green: 0.8, blue: 1, alpha: 1)
}

extension String {
    var isBlank: Bool {
        return content.isEmpty
    }
    var content: String {
        return trimmingCharacters(in: .whitespaces)
    }
    var length: Int {
        return characters.count
    }
    var url: URL? {
        return URL(string: self)
    }
}

extension String: Error {
    public var localizedDescription: String {
        return self
    }
}

extension Bool {
    mutating func toggle() {
        self = !self
    }
}

extension UIViewController {
    func animatedDismiss(completion: (() -> ())? = nil) {
        dismiss(animated: true, completion: completion)
    }
    func animatedPop() {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension UIViewController {
    func pushAcknowledgementsViewController(animated: Bool = true) {
        navigationController?.pushViewController(VTAcknowledgementsViewController(fileNamed: "Pods-FBLA-acknowledgements")!, animated: animated)
    }
}

extension CLLocationCoordinate2D {
    static var random: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(arc4random()) / Double(UInt32.max) * 180 - 90, longitude: Double(arc4random()) / Double(UInt32.max) * 360 - 180)
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

@discardableResult func showError(_ error: Error?) -> Bool {
    if let error = error {
        HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 1)
        return true
    }
    return false
}
