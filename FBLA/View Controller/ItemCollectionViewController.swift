//
//  ItemCollectionViewController.swift
//  FBLA
//
//  Created by Apollo Zhu on 2/5/17.
//  Copyright © 2017 Swifty X. All rights reserved.
//

import UIKit
import Firebase

class ItemCollectionViewController: UICollectionViewController {
    
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Item.forEachInSellItem(limits: [.number(-20)]) { [weak self] in
            if let item = $0, let this = self {
                this.items.append(item)
                this.collectionView?.reloadData()
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as? ItemCollectionViewCell {
            cell.item = items[indexPath.item]
            return cell
        }
        return .init()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        displayItem(items[indexPath.item])
    }
}
