//
//  JNNamespace.swift
//  SwiftProject
//
//  Created by Miles on 2021/8/5.
//

import Foundation

/// 协议类型
public protocol JNTypeWrapperProtocol {
    associatedtype JNWrappedType
    var jnWrappedValue: JNWrappedType { get }
    init(value: JNWrappedType)
}

public struct JNNamespaceWrapper<T>: JNTypeWrapperProtocol {
    public let jnWrappedValue: T
    public init(value: T) {
        self.jnWrappedValue = value
    }
}


/// 命名空间协议
public protocol JNNamespcaeWrappable {
    associatedtype JNWrappedType
    var jn: JNWrappedType { get }
    static var jn: JNWrappedType.Type { get }
}

extension JNNamespcaeWrappable {
    
    public var jn: JNNamespaceWrapper<Self> {
        return JNNamespaceWrapper(value: self)
    }
    
    public static var jn: JNNamespaceWrapper<Self>.Type {
        return JNNamespaceWrapper.self
    }
}
