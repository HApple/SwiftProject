//
//  CGFloat+Jn.swift
//  SwiftProject
//
//  Created by hjn on 2020/12/29.
//

import UIKit

public extension CGFloat {
    
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    
    static let isiPhoneXSeries =  screenHeight > 736.0
    
    static let statusBarHeight: CGFloat = 20 + topSafeAreaHeight
    static let navigationBarHeight: CGFloat = 44
    static let statusAndNavigationHeight: CGFloat = statusBarHeight + navigationBarHeight
    
    static let topSafeAreaHeight: CGFloat = isiPhoneXSeries ? 22 : 0
    static let bottomSafeAreaHeight: CGFloat = isiPhoneXSeries ? 34 : 0
}

public extension CGFloat {
    
    var ceil: CGFloat {
        return Foundation.ceil(self)
    }
    
    var floor: CGFloat {
        return Foundation.floor(self)
    }
    
    var isPositive: Bool {
        return self > 0
    }
    
    var isNegative: Bool {
        return self < 0
    }

    var int: Int {
        return Int(self)
    }

    var float: Float {
        return Float(self)
    }

    var double: Double {
        return Double(self)
    }
    
    var degreesToRadians: CGFloat {
        return .pi * self / 180.0
    }
    
    var radiansToDegrees: CGFloat {
        return self * 180 / CGFloat.pi
    }
}
