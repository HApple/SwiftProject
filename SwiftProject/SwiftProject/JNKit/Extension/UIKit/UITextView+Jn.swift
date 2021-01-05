//
//  UITextView+Jn.swift
//  SwiftProject
//
//  Created by hjn on 2020/12/31.
//

import UIKit

// MARK: - Methods

public extension UITextView {

    func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }

    func scrollToBottom() {
        let range = NSRange(location: (text as NSString).length - 1, length: 1)
        scrollRangeToVisible(range)
    }
    
    func scrollToTop() {
        let range = NSRange(location: 0, length: 1)
        scrollRangeToVisible(range)
    }

    func wrapToContent() {
        contentInset = .zero
        scrollIndicatorInsets = .zero
        contentOffset = .zero
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        sizeToFit()
    }
}
