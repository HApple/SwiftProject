//
//  CAAnimation+JNBadge.swift
//  SwiftProject
//
//  Created by Miles on 2021/3/17.
//

import Foundation
import UIKit

public enum JNAxis: Int {
    case x, y , z
}

// Degrees to radians
public func jn_DegeesToRadians(angle: Double) -> Double {
    angle / 180.0 * Double.pi
}

public func jn_RadiansToDeggrees(radians: Double) -> Double {
    radians * ( 180.0 / Double.pi)
}


extension CAAnimation {
    
    
    static func jn_OpacityForever_Animation(duration: TimeInterval) -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.1
        animation.autoreverses = true
        animation.duration = duration
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.fillMode = .forwards
        return animation
    }
    
    static func jn_OpacityForever_Animation(repeatCounts: Float, duration: TimeInterval) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opcaity")
        animation.fromValue = 1.0
        animation.toValue = 0.4
        animation.autoreverses = true
        animation.duration = duration
        animation.repeatCount = repeatCounts
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.fillMode = .forwards
        return animation
    }
    
    static func jn_Rotation(duration: TimeInterval, degress: Float, axis: JNAxis, repeatCount: Float) -> CABasicAnimation {
        let axisArr = ["transform.rotation.x", "transform.rotation.y", "transform.rotation.z"]
        let animation = CABasicAnimation(keyPath: axisArr[axis.rawValue])
        animation.fromValue = 0
        animation.toValue = degress
        animation.duration = duration
        animation.autoreverses = false
        animation.isCumulative = true
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.repeatCount = repeatCount
        return animation
    }
    
    static func jn_Scale(from fromScale: CGFloat, to toScale: CGFloat, duration: TimeInterval, repeatCount: Float) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = fromScale
        animation.toValue = toScale
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        return animation
    }
    
    static func jn_Shake_Animation(repeatCount: Float, duration: TimeInterval, for layer: CALayer) -> CAKeyframeAnimation {
        
        let originPosition: CGPoint = layer.position
        let originSize: CGSize = layer.bounds.size
        
        let hOffset = originSize.width / 4.0
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.values = [CGPoint(x: originPosition.x, y: originPosition.y),
                            CGPoint(x: originPosition.x - hOffset, y: originPosition.y),
                            CGPoint(x: originPosition.x, y: originPosition.y),
                            CGPoint(x: originPosition.x + hOffset, y: originPosition.y),
                            CGPoint(x: originPosition.x, y: originPosition.y)]
        
        animation.repeatCount = repeatCount
        animation.duration = duration
        animation.fillMode = .forwards
        return animation
    }
    
    static func jn_Bounce_Animation(repeatCount: Float, duration: TimeInterval, for layer: CALayer) -> CAKeyframeAnimation {
        let originPosition: CGPoint = layer.position
        let originSize: CGSize = layer.bounds.size
        
        let hOffset = originSize.width / 4.0
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.values = [CGPoint(x: originPosition.x, y: originPosition.y),
                            CGPoint(x: originPosition.x, y: originPosition.y - hOffset),
                            CGPoint(x: originPosition.x, y: originPosition.y),
                            CGPoint(x: originPosition.x , y: originPosition.y + hOffset),
                            CGPoint(x: originPosition.x, y: originPosition.y)]
        
        animation.repeatCount = repeatCount
        animation.duration = duration
        animation.fillMode = .forwards
        return animation
    }
}
