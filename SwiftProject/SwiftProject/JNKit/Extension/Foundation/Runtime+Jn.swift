//
//  Runtime+Jn.swift
//  SwiftProject
//
//  Created by hjn on 2021/3/2.
//

import Foundation

func jn_getAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer) -> T? {
    return objc_getAssociatedObject(object, key) as? T
}

func jn_setRetainedAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer, _ value: T) {
    objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}


@discardableResult
public func jn_swizzleInstanceMethod(target: Any?, originalSelector: Selector, newSelector: Selector) -> Bool {
    let targetClass: AnyClass? = object_getClass(target)
    guard let originalMethod = class_getInstanceMethod(targetClass, originalSelector), let newMethod = class_getInstanceMethod(targetClass, newSelector) else {
        return false
    }
    let didAdd = class_addMethod(targetClass, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))
    if didAdd {
        class_replaceMethod(targetClass, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    }else {
        method_exchangeImplementations(originalMethod, newMethod)
    }
    return true
}

@discardableResult
public func jn_swizzleClassMethod(target: Any?, originalSelector: Selector, newSelector: Selector) -> Bool {
    let targetClass: AnyClass? = object_getClass(target)
    guard let originalMethod = class_getClassMethod(targetClass, originalSelector), let newMethod = class_getClassMethod(targetClass, newSelector) else {
        return false
    }
    let metaClass: AnyClass? = object_getClass(targetClass)
    let didAdd = class_addMethod(metaClass, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))
    if didAdd {
        class_replaceMethod(metaClass, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    }else {
        method_exchangeImplementations(originalMethod, newMethod)
    }
    return true
}
