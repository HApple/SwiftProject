//
//  UITabBarItem+JNBadge.swift
//  SwiftProject
//
//  Created by hjn on 2021/3/29.
//

import UIKit

extension UITabBarItem: JNBadgeProtocol {
    public func showBadge() {
        getActualBadgeSuperView()?.showBadge()
    }
    
    public func showBadge(style: JNBadgeStyle, value: Int, animType: JNBadgeAnimType) {
        getActualBadgeSuperView()?.showBadge(style: style, value: value, animType: animType)
    }
    
    public func showNumberBadge(with value: Int, animType: JNBadgeAnimType) {
        getActualBadgeSuperView()?.showNumberBadge(with: value, animType: animType)
    }
    
    public func clearBadge() {
        getActualBadgeSuperView()?.clearBadge()
    }
    
    public func resumeBadge() {
        getActualBadgeSuperView()?.resumeBadge()
    }
    
    public var badge: UILabel? {
        get {
            getActualBadgeSuperView()?.badge
        }
        set {
            getActualBadgeSuperView()?.badge = newValue
        }
    }
    
    public var badgeFont: UIFont {
        get {
            getActualBadgeSuperView()?.badgeFont ?? JNBadgeDefault.font
        }
        set {
            getActualBadgeSuperView()?.badgeFont = newValue
        }
    }
    
    public var badgeBgColor: UIColor {
        get {
            getActualBadgeSuperView()?.badgeBgColor ?? JNBadgeDefault.bgColor
        }
        set {
            getActualBadgeSuperView()?.badgeBgColor = newValue
        }
    }
    
    public var badgeTextColor: UIColor {
        get {
            getActualBadgeSuperView()?.badgeTextColor ?? JNBadgeDefault.textColor
        }
        set {
            getActualBadgeSuperView()?.badgeTextColor = newValue
        }
    }
    
    public var badgeFrame: CGRect {
        get {
            getActualBadgeSuperView()?.badgeFrame ?? JNBadgeDefault.frame
        }
        set {
            getActualBadgeSuperView()?.badgeFrame = newValue
        }
    }
    
    public var badgeCenterOffset: CGPoint {
        get {
            getActualBadgeSuperView()?.badgeCenterOffset ?? JNBadgeDefault.centerOffset
        }
        set {
            getActualBadgeSuperView()?.badgeCenterOffset = newValue
        }
    }
    
    public var animType: JNBadgeAnimType {
        get {
            getActualBadgeSuperView()?.animType ?? JNBadgeAnimType.none
        }
        set {
            getActualBadgeSuperView()?.animType = newValue
        }
    }
    
    public var badgeMaximumBadgeNumber: Int {
        get {
            getActualBadgeSuperView()?.badgeMaximumBadgeNumber ?? JNBadgeDefault.maximumBadgeNumber
        }
        set {
            getActualBadgeSuperView()?.badgeMaximumBadgeNumber = newValue
        }
    }
    
    public var badgeRadius: CGFloat {
        get {
            getActualBadgeSuperView()?.badgeRadius ?? JNBadgeDefault.radius
        }
        set {
            getActualBadgeSuperView()?.badgeRadius = newValue
        }
    }

}

extension UITabBarItem {
    
    private func getActualBadgeSuperView() -> UIView? {
        let view = value(forKey: "_view") as? UIView
        var bgView : UIView?
        view?.subviews.forEach { (subView) in
            if subView.isKind(of: NSClassFromString("UITabBarSwappableImageView")!) {
                bgView = subView
            }
        }
        return bgView
    }
}
