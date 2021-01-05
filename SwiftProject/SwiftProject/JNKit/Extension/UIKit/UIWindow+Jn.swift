//
//  UIWindow+Jn.swift
//  SwiftProject
//
//  Created by hjn on 2020/12/31.
//

import UIKit

public extension UIWindow {
    
    func switchRootViewController(
        to viewController: UIViewController,
        animated: Bool = true,
        duration: TimeInterval = 0.5,
        options: UIView.AnimationOptions = .transitionFlipFromRight,
        _ completion: (() -> Void)? = nil) {
        guard animated else {
            rootViewController = viewController
            completion?()
            return
        }

        UIView.transition(with: self, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }, completion: { _ in
            completion?()
        })
    }
}
