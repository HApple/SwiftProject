//
//  UITableView+Jn.swift
//  SwiftProject
//
//  Created by hjn on 2020/12/31.
//

import UIKit

// MARK: - Properties

public extension UITableView {

    var indexPathForLastRow: IndexPath? {
        guard let lastSection = lastSection else { return nil }
        return indexPathForLastRow(inSection: lastSection)
    }

    var lastSection: Int? {
        return numberOfSections > 0 ? numberOfSections - 1 : nil
    }
}

// MARK: - Methods

public extension UITableView {
    
    func numberOfRows() -> Int {
        var section = 0
        var rowCount = 0
        while section < numberOfSections {
            rowCount += numberOfRows(inSection: section)
            section += 1
        }
        return rowCount
    }

    func indexPathForLastRow(inSection section: Int) -> IndexPath? {
        guard numberOfSections > 0, section >= 0 else { return nil }
        guard numberOfRows(inSection: section) > 0 else {
            return IndexPath(row: 0, section: section)
        }
        return IndexPath(row: numberOfRows(inSection: section) - 1, section: section)
    }

    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }

    func removeTableFooterView() {
        tableFooterView = nil
    }

    func removeTableHeaderView() {
        tableHeaderView = nil
    }

    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section >= 0 &&
            indexPath.row >= 0 &&
            indexPath.section < numberOfSections &&
            indexPath.row < numberOfRows(inSection: indexPath.section)
    }

    func safeScrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        guard indexPath.section < numberOfSections else { return }
        guard indexPath.row < numberOfRows(inSection: indexPath.section) else { return }
        scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
}
