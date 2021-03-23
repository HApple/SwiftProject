//
//  UIView+JNBadge.swift
//  SwiftProject
//
//  Created by Miles on 2021/3/19.
//

import UIKit

struct JNBadgeDefault {
    static let font:UIFont = UIFont.boldSystemFont(ofSize: 9)
    static let maximumBadgeNumber: Int = 99
    static let redDotRadis: CGFloat = 4.0
    static let bgColor: UIColor = .red
    static let textColor: UIColor = .white
    static let centerOffset: CGPoint = .zero
    static let radius: CGFloat = 10
    static let frame: CGRect = .zero
}

extension UIView: JNBadgeProtocol {
    
    
    // MARK: - Public Methods
    public func showBadge() {
        <#code#>
    }
    
    public func showBadge(style: JNBadgeStyle, value: Int, animType: JNBadgeAnimType) {
        <#code#>
    }
    
    public func clearBadge() {
        <#code#>
    }
    
    // MARK: - Associated Object
    private struct JNBadgeKey {
        
        static var badge: Void?
        static var badgeFont: Void?
        static var badgeBgColor: Void?
        static var badgeTextColor: Void?
        static var badgeFrame:  Void?
        static var badgeCenterOffset:  Void?
        static var animType:  Void?
        static var badgeMaximumBadgeNumber:  Void?
        static var badgeRadius:  Void?
    }
    
    
    public var badge: UILabel? {
        get {
            return jn_getAssociatedObject(self, &JNBadgeKey.badge)
        }
        set {
            return jn_setRetainedAssociatedObject(self, &JNBadgeKey.badge, newValue)
        }
    }
    
    public var badgeFont: UIFont {
        get {
            guard let font = jn_getAssociatedObject(self, &JNBadgeKey.badgeFont) as UIFont? else {
                return JNBadgeDefault.font
            }
            return font
        }
        set {
            jn_setRetainedAssociatedObject(self, &JNBadgeKey.badgeFont, newValue)
            if badge == nil {
               badgeInit()
            }
            badge?.font = newValue
        }
    }
    
    public var badgeBgColor: UIColor {
        get {
            guard let bgColor = jn_getAssociatedObject(self, &JNBadgeKey.badgeBgColor) as UIColor? else {
                return JNBadgeDefault.bgColor
            }
            return bgColor
        }
        set {
            jn_setRetainedAssociatedObject(self, &JNBadgeKey.badgeBgColor, newValue)
            if badge == nil {
               badgeInit()
            }
            badge?.backgroundColor = newValue
        }
    }
    
    public var badgeTextColor: UIColor {
        get {
            guard let textColor = jn_getAssociatedObject(self, &JNBadgeKey.badgeTextColor) as UIColor? else {
                return JNBadgeDefault.textColor
            }
            return textColor
        }
        set {
             jn_setRetainedAssociatedObject(self, &JNBadgeKey.badgeTextColor, newValue)
            if badge == nil {
               badgeInit()
            }
            badge?.textColor = newValue
        }
    }
    
    public var badgeFrame: CGRect {
        get {
            guard let frm = jn_getAssociatedObject(self, &JNBadgeKey.badgeFrame) as CGRect? else {
                return JNBadgeDefault.frame
            }
            return frm
        }
        set {
            jn_setRetainedAssociatedObject(self, &JNBadgeKey.badgeFrame, newValue)
            if badge == nil {
               badgeInit()
            }
            badge?.frame = newValue
        }
    }
    
    public var badgeCenterOffset: CGPoint {
        get {
            guard let centerOffset = jn_getAssociatedObject(self, &JNBadgeKey.badgeCenterOffset) as CGPoint? else {
                return JNBadgeDefault.centerOffset
            }
            return centerOffset
        }
        set {
            jn_setRetainedAssociatedObject(self, &JNBadgeKey.badgeCenterOffset, newValue)
            if badge == nil {
               badgeInit()
            }
            badge?.center = CGPoint(x: self.frame.size.width + 2 + newValue.x, y: newValue.y)
        }
    }
    
    public var animType: JNBadgeAnimType {
        get {
            guard let type = jn_getAssociatedObject(self, &JNBadgeKey.animType) as JNBadgeAnimType? else {
                return .none
            }
            return type
        }
        set {
            jn_setRetainedAssociatedObject(self, &JNBadgeKey.animType, newValue)
        }
    }
    
    public var badgeMaximumBadgeNumber: Int {
        get {
            guard let maximumBadgeNumber = jn_getAssociatedObject(self, &JNBadgeKey.badgeMaximumBadgeNumber) as Int? else {
                return JNBadgeDefault.maximumBadgeNumber
            }
            return maximumBadgeNumber
        }
        set {
            jn_setRetainedAssociatedObject(self, &JNBadgeKey.badgeMaximumBadgeNumber, newValue)
        }
    }
    
    public var badgeRadius: CGFloat {
        get {
            guard let radius = jn_getAssociatedObject(self, &JNBadgeKey.badgeRadius) as CGFloat? else {
                return JNBadgeDefault.radius
            }
            return radius
        }
        set {
            jn_setRetainedAssociatedObject(self, &JNBadgeKey.badgeRadius, newValue)
            if badge == nil {
               badgeInit()
            }
            
        }
    }
}

// MARK: - Private Methods
extension UIView {

    private func showNumberBadgeWith(value: Int) {
    
        guard value >= 0 else { return }
        badgeInit()
        if value == 0 { badge?.isHidden = true }
        badge!.tag = JNBadgeStyle.number.rawValue
        badge!.font = badgeFont
        badge!.text = value > badgeMaximumBadgeNumber ? "\(badgeMaximumBadgeNumber)+" : "\(value)"
        adjustLabelWidth(badge!)
        var frm = badge!.frame
        frm.size.width += 4
        frm.size.height += 4
        if frm.size.width < frm.size.height {
            frm.size.width = frame.size.height
        }
        badge!.frame = frm
        badge!.center = CGPoint(x: frame.size.width + 2 + badgeCenterOffset.x, y: badgeCenterOffset.y)
        badge!.layer.cornerRadius = badge!.frame.height / 2

    }
    
    
    private func badgeInit() {

        if badge == nil {
            let redotWidth:CGFloat = JNBadgeDefault.redDotRadis * 2
            let frm = CGRect(x: self.frame.size.width, y: -redotWidth, width: redotWidth, height: redotWidth)
            badge = UILabel(frame: frm)
            badge!.textAlignment = .center
            badge!.center = CGPoint(x: self.frame.size.width + 2 + badgeCenterOffset.x, y: badgeCenterOffset.y)
            badge!.backgroundColor = badgeBgColor
            badge!.textColor = badgeTextColor
            badge!.tag = JNBadgeStyle.reddot.rawValue
            badge!.layer.cornerRadius = badge!.frame.size.width / 2
            badge!.layer.masksToBounds = true
            addSubview(badge!)
            bringSubviewToFront(badge!)
        }
        
    }

    private func adjustLabelWidth(_ label: UILabel) {
        guard let s = label.text as NSString? else { return }
        guard let font = label.font else { return }
        label.numberOfLines = 0
        
        let size = CGSize(width: 320, height: 3000)
        var labelSize: CGSize = .zero
        
        let style:NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        style.lineBreakMode = .byWordWrapping
        labelSize = s.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font, .paragraphStyle: style], context: nil).size
        var frame = label.frame
        frame.size = CGSize(width: CGFloat(ceilf(Float(labelSize.width))), height: CGFloat(ceilf(Float(labelSize.height))))
        label.frame = frame
    }
    
    
    private func beginAnimation() {
        let key = animType.animKey
        guard let bLayer = self.badge?.layer else { return }
        switch animType {
        case .breathe:
            bLayer.add(CAAnimation.jn_OpacityForever_Animation(duration: 1.4), forKey: key)
        case .shake:
            bLayer.add(CAAnimation.jn_Shake_Animation(repeatCount: Float.greatestFiniteMagnitude, duration: 1, for: bLayer), forKey: key)
        case .scale:
            bLayer.add(CAAnimation.jn_Scale(from: 1.4, to: 0.6, duration: 1, repeatCount: Float.greatestFiniteMagnitude), forKey: key)
        case .bounce:
            bLayer.add(CAAnimation.jn_Bounce_Animation(repeatCount: Float.greatestFiniteMagnitude, duration: 1, for: bLayer), forKey: key)
        case .none:
            break
        }
    }
    
    private func removeAnimation() {
        self.badge?.layer.removeAllAnimations()
    }
}
