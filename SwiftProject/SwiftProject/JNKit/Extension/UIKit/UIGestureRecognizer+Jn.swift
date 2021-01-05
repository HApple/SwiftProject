//
//  UIGestureRecognizer+Jn.swift
//  SwiftProject
//
//  Created by hjn on 2020/12/31.
//

import UIKit

fileprivate struct AssociatedObjectKeys {
    static var gestureRecognizerBlockKey: String = "gestureRecognizerBlockKey"
}

public typealias UIGestureRecognizerActionBlock = ((UIGestureRecognizer) -> Void)

public extension UIGestureRecognizer {
    
    private var gestureRecognizerBlock: UIGestureRecognizerActionBlock? {
        
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectKeys.gestureRecognizerBlockKey) as? UIGestureRecognizerActionBlock
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedObjectKeys.gestureRecognizerBlockKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    convenience init(_ action: UIGestureRecognizerActionBlock?) {
        self.init()
        addAction(action)
    }
    
    @objc private func callGestureRecognizerBlock() {
        gestureRecognizerBlock?(self)
    }
    
    
    func addAction(_ action: UIGestureRecognizerActionBlock?) {
        gestureRecognizerBlock = action
        if nil == action {
            removeTarget(self, action: #selector(callGestureRecognizerBlock))
        }else {
            addTarget(self, action: #selector(callGestureRecognizerBlock))
        }
    }
    
    func removeAction() {
        addAction(nil)
    }
}


