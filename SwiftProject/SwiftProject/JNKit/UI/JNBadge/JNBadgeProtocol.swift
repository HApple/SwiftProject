//
//  JNBadgeProtocol.swift
//  SwiftProject
//
//  Created by hjn on 2021/3/17.
//

import Foundation
import UIKit

public enum JNBadgeStyle: Int {
    case reddot
    case number
    case new
}

public enum JNBadgeAnimType: Int {
    case none
    case scale
    case shake
    case bounce
    case breathe
    
    var animKey:String {
        switch self {
        case .none:
            return ""
        case .scale:
            return "scale"
        case .shake:
            return "shake"
        case .bounce:
            return "bounce"
        case .breathe:
            return "breathe"
        }
    }
}

public protocol JNBadgeProtocol: AnyObject {
    
    var badge: UILabel? { get set }
    var badgeFont: UIFont { get set }
    var badgeBgColor: UIColor { get set }
    var badgeTextColor: UIColor { get set }
    var badgeFrame: CGRect { get set }
    var badgeCenterOffset: CGPoint { get set }
    var animType: JNBadgeAnimType { get set }
    var badgeMaximumBadgeNumber: Int { get set }
    var badgeRadius: CGFloat { get set }
    
    func showBadge()
    func showBadge(style: JNBadgeStyle, value: Int , animType: JNBadgeAnimType)
    func showNumberBadge(with value: Int, animType: JNBadgeAnimType)
    func clearBadge()
    func resumeBadge()
    
    
}
