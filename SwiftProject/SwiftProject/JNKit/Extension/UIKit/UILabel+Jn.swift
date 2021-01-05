//
//  UILabel+Jn.swift
//  SwiftProject
//
//  Created by hjn on 2020/12/31.
//

import UIKit

public extension UILabel {
    
    var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
    
    
}
