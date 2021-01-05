//
//  CGPoint+Jn.swift
//  SwiftProject
//
//  Created by hjn on 2020/12/31.
//

import CoreGraphics

public extension CGPoint {
    
    func distance(from point: CGPoint) -> CGFloat {
        return CGPoint.distance(from: self, to: point)
    }
    
    static func distance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        return sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2))
    }
}
