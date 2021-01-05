//
//  UIRectCorner+Jn.swift
//  SwiftProject
//
//  Created by hjn on 2020/12/30.
//

import UIKit

public extension UIRectCorner {
    
    static let top: UIRectCorner = [.topLeft, .topRight]

    static let left: UIRectCorner = [.topLeft, .bottomLeft]

    static let bottom: UIRectCorner = [.bottomLeft, .bottomRight]

    static let right: UIRectCorner = [.bottomRight, .topRight]
    
    static let allCornersWithoutTopLeft: UIRectCorner = [.topRight, .bottomLeft, .bottomRight]
    
    static let allCornersWithoutTopRight: UIRectCorner = [.topLeft, .bottomLeft, .bottomRight]
    
    static let allCornersWithoutBottomLeft: UIRectCorner = [.topLeft, .topRight, .bottomRight]
    
    static let allCornersWithoutBottomRight: UIRectCorner = [.topLeft, .topRight, bottomLeft]
}
