//
//  UILabel+Jn.swift
//  SwiftProject
//
//  Created by hjn on 2020/12/31.
//

import UIKit

public extension JNTypeWrapperProtocol where JNWrappedType == UILabel {
    
    var requiredHeight: CGFloat {
        var height = UIScreen.main.bounds.width - jnWrappedValue.frame.width
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: jnWrappedValue.frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = jnWrappedValue.font
        label.text = jnWrappedValue.text
        label.attributedText = jnWrappedValue.attributedText
        label.sizeToFit()
        height += label.frame.height
        return height
    }    
}
