//
//  JNViewModelType.swift
//  SwiftProject
//
//  Created by Miles on 2021/8/9.
//

import Foundation

protocol JNViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transfrom(input: Input) -> Output
}
