//
//  JNDefaultWrapper.swift
//  SwiftProject
//
//  Created by hjn on 2021/7/1.
//
//  PropertyWrapper详解：https://juejin.cn/post/6953646935127359524#heading-2
//  直接使用库Foil  https://github.com/jessesquires/Foil

import Foundation


private enum Key: String {
    case userId
    case sessionId
}

@propertyWrapper
struct JNDefaults<T> {
    
    let key: String
    let defaultValue:T
    
    var wrappedValue:T {
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
        get {
            UserDefaults.standard.value(forKey: key) as? T ?? defaultValue
        }
    }
}

enum GloablSettings {
    
    @JNDefaults(key: Key.userId.rawValue, defaultValue: nil)
    static var userId:String?
    
    @JNDefaults(key: Key.sessionId.rawValue, defaultValue: nil)
    static var sessionId: String?
}
