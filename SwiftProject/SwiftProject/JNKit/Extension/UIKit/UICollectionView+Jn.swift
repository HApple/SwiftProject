//
//  UICollectionView+Jn.swift
//  SwiftProject
//
//  Created by hjn on 2020/12/31.
//

import UIKit

// MARK: - Properties

public extension UICollectionView {

    var indexPathForLastItem: IndexPath? {
        return indexPathForLastItem(inSection: lastSection)
    }

    var lastSection: Int {
        return numberOfSections > 0 ? numberOfSections - 1 : 0
    }
}

// MARK: - Methods

public extension UICollectionView {
    
    func numberOfItems() -> Int {
        var section = 0
        var itemsCount = 0
        while section < numberOfSections {
            itemsCount += numberOfItems(inSection: section)
            section += 1
        }
        return itemsCount
    }

    func indexPathForLastItem(inSection section: Int) -> IndexPath? {
        guard section >= 0 else {
            return nil
        }
        guard section < numberOfSections else {
            return nil
        }
        guard numberOfItems(inSection: section) > 0 else {
            return IndexPath(item: 0, section: section)
        }
        return IndexPath(item: numberOfItems(inSection: section) - 1, section: section)
    }

    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }

    func safeScrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        guard indexPath.item >= 0,
            indexPath.section >= 0,
            indexPath.section < numberOfSections,
            indexPath.item < numberOfItems(inSection: indexPath.section) else {
            return
        }
        scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }

    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section >= 0 &&
            indexPath.item >= 0 &&
            indexPath.section < numberOfSections &&
            indexPath.item < numberOfItems(inSection: indexPath.section)
    }
}
