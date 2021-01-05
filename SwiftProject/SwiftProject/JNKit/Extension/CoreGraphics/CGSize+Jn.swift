//
//  CGSize+Jn.swift
//  SwiftProject
//
//  Created by hjn on 2020/12/31.
//

import CoreGraphics


public extension CGSize {
    
    var aspectRatio: CGFloat {
        guard height != 0 else { return 0 }
        return width / height
    }

    var maxDimension: CGFloat {
        return max(width, height)
    }

    var minDimension: CGFloat {
        return min(width, height)
    }
}

public extension CGSize {
    
    ///     let rect = CGSize(width: 120, height: 80)
    ///     let parentRect  = CGSize(width: 100, height: 50)
    ///     let newRect = rect.aspectFit(to: parentRect)
    ///     // newRect.width = 75 , newRect = 50
    func aspectFit(to boundingSize: CGSize) -> CGSize {
        let minRatio = min(boundingSize.width / width, boundingSize.height / height)
        return CGSize(width: width * minRatio, height: height * minRatio)
    }

    ///     let rect = CGSize(width: 20, height: 120)
    ///     let parentRect  = CGSize(width: 100, height: 60)
    ///     let newRect = rect.aspectFit(to: parentRect)
    ///     // newRect.width = 100 , newRect = 60
    func aspectFill(to boundingSize: CGSize) -> CGSize {
        let minRatio = max(boundingSize.width / width, boundingSize.height / height)
        let aWidth = min(width * minRatio, boundingSize.width)
        let aHeight = min(height * minRatio, boundingSize.height)
        return CGSize(width: aWidth, height: aHeight)
    }
}

// MARK: - Operators

public extension CGSize {
    
    ///     let sizeA = CGSize(width: 5, height: 10)
    ///     let sizeB = CGSize(width: 3, height: 4)
    ///     let result = sizeA + sizeB
    ///     // result = CGSize(width: 8, height: 14)
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    
    ///     let sizeA = CGSize(width: 5, height: 10)
    ///     let result = sizeA + (5, 4)
    ///     // result = CGSize(width: 10, height: 14)
    static func + (lhs: CGSize, tuple: (width: CGFloat, height: CGFloat)) -> CGSize {
        return CGSize(width: lhs.width + tuple.width, height: lhs.height + tuple.height)
    }

    ///     var sizeA = CGSize(width: 5, height: 10)
    ///     let sizeB = CGSize(width: 3, height: 4)
    ///     sizeA += sizeB
    ///     // sizeA = CGPoint(width: 8, height: 14)
    static func += (lhs: inout CGSize, rhs: CGSize) {
        lhs.width += rhs.width
        lhs.height += rhs.height
    }

    
    ///     var sizeA = CGSize(width: 5, height: 10)
    ///     sizeA += (3, 4)
    ///     // result = CGSize(width: 8, height: 14)
    static func += (lhs: inout CGSize, tuple: (width: CGFloat, height: CGFloat)) {
        lhs.width += tuple.width
        lhs.height += tuple.height
    }

    ///     let sizeA = CGSize(width: 5, height: 10)
    ///     let sizeB = CGSize(width: 3, height: 4)
    ///     let result = sizeA - sizeB
    ///     // result = CGSize(width: 2, height: 6)
    static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    ///     let sizeA = CGSize(width: 5, height: 10)
    ///     let result = sizeA - (3, 2)
    ///     // result = CGSize(width: 2, height: 8)
    static func - (lhs: CGSize, tuple: (width: CGFloat, heoght: CGFloat)) -> CGSize {
        return CGSize(width: lhs.width - tuple.width, height: lhs.height - tuple.heoght)
    }

    
    ///     var sizeA = CGSize(width: 5, height: 10)
    ///     let sizeB = CGSize(width: 3, height: 4)
    ///     sizeA -= sizeB
    ///     // sizeA = CGPoint(width: 2, height: 6)
    ///
    static func -= (lhs: inout CGSize, rhs: CGSize) {
        lhs.width -= rhs.width
        lhs.height -= rhs.height
    }

    ///     var sizeA = CGSize(width: 5, height: 10)
    ///     sizeA -= (2, 4)
    ///     // result = CGSize(width: 3, height: 6)
    static func -= (lhs: inout CGSize, tuple: (width: CGFloat, height: CGFloat)) {
        lhs.width -= tuple.width
        lhs.height -= tuple.height
    }

    ///     let sizeA = CGSize(width: 5, height: 10)
    ///     let sizeB = CGSize(width: 3, height: 4)
    ///     let result = sizeA * sizeB
    ///     // result = CGSize(width: 15, height: 40)
    static func * (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
    }

    ///     let sizeA = CGSize(width: 5, height: 10)
    ///     let result = sizeA * 5
    ///     // result = CGSize(width: 25, height: 50)
    static func * (lhs: CGSize, scalar: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * scalar, height: lhs.height * scalar)
    }

    ///     let sizeA = CGSize(width: 5, height: 10)
    ///     let result = 5 * sizeA
    ///     // result = CGSize(width: 25, height: 50)
    static func * (scalar: CGFloat, rhs: CGSize) -> CGSize {
        return CGSize(width: scalar * rhs.width, height: scalar * rhs.height)
    }

    ///     var sizeA = CGSize(width: 5, height: 10)
    ///     let sizeB = CGSize(width: 3, height: 4)
    ///     sizeA *= sizeB
    ///     // result = CGSize(width: 15, height: 40)
    static func *= (lhs: inout CGSize, rhs: CGSize) {
        lhs.width *= rhs.width
        lhs.height *= rhs.height
    }

    ///     var sizeA = CGSize(width: 5, height: 10)
    ///     sizeA *= 3
    ///     // result = CGSize(width: 15, height: 30)
    static func *= (lhs: inout CGSize, scalar: CGFloat) {
        lhs.width *= scalar
        lhs.height *= scalar
    }
}
