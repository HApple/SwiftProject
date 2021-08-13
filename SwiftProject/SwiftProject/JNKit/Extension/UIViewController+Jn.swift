//
//  UIViewController+Jn.swift
//  SwiftProject
//
//  Created by hjn on 2020/12/29.
//

import UIKit

extension UIViewController: JNNamespcaeWrappable {}

public extension JNTypeWrapperProtocol where JNWrappedType == UIViewController {
    
    var topViewController: UIViewController {
        return jnWrappedValue.presentedViewController?.jn.topViewController
            ?? (jnWrappedValue as? UITabBarController)?.selectedViewController?.jn.topViewController
            ?? (jnWrappedValue as? UINavigationController)?.visibleViewController?.jn.topViewController
            ?? jnWrappedValue
    }
    
    static var topViewController: UIViewController {
        return UIApplication.shared.delegate?.window??.rootViewController?.jn.topViewController ?? UIViewController()
    }
}
