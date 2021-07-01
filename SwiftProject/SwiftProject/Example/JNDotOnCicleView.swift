//
//  JNDotOnCicleView.swift
//  SwiftProject
//
//  Created by hjn on 2021/3/30.
//

import UIKit
/*
 角度 angle  弧度 radian
 1. 弧度 和 角度 是度量角大小的两种不同的单位
 2. 在旋转角度里的角，以“角度”为单位；而在三角函数里的角要以“弧度”为单位，如 rotation 2 是旋转 2角度， sin(π/2) 是大小为 π/2弧度 的角的正弦
 3. 角度的定义： 两条射线从圆心向圆周射出，行程一个夹角和夹角正对的一段弧，当这段弧长正好等于圆周长的360分之一时，两条射线的夹角为1角度。
 4. 弧度的定义： 两条射线从圆心向圆周射出，行程一个夹角和夹角正对的一段弧，当这段弧长正好等于圆的半径时，两条射线的夹角大小为1弧度。
 5. 角所对的弧长是半径的几倍，那么角的大小就是几弧度
    它们的关系可用下式表示和计算：
    角（弧度） = 弧长 / 半径
    圆的周长是半径的 2π倍，所以一个周角（360度）是 2π弧度。
    半圆的长度是半径的 π倍，所以一个平角（180度）是 π弧度。
 6. 角度转弧度     radian =  angle * π / 180
 7. 弧度转角度     angle = radian * 180 / π
 
 
          1.5PI π/2
            |
            |
            |
            |
            |
1 PI ————------------- 0 PI (2 PI) 弧度 0π / 2π
            |
            |
            |     顺时针
            |
            |
           0.5 PI
    
 角度弧度互换  注意顺时针 逆时针
 
 https://www.geogebra.org/m/jftuf4zz
 
 */

extension CGFloat {
    
    func angleToRadian() -> CGFloat {
        return self * CGFloat.pi / 180
    }
    
    func radianToAngle() -> CGFloat {
        return self * 180 / CGFloat.pi
    }
}

// center point on cicle 在圆上的点
func pointAroundCircumference(center: CGPoint, radius: CGFloat, theta: CGFloat) -> CGPoint {
    var point: CGPoint = .zero
    point.x = center.x + radius * cos(theta)
    point.y = center.y + radius * sin(theta)
    return point
}


class JNDotOnCicleView: UIView {

    
    var circleWidth: CGFloat = 20 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var dotSize: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var numberOfDot:Int = 18 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var dotColor: UIColor = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var dotShiningColor: UIColor = .green {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    private var dotLayers: [CAShapeLayer] = [CAShapeLayer]()
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        dotLayers.forEach { (cy) in
            cy.removeAllAnimations()
            cy.removeFromSuperlayer()
        }
        dotLayers.removeAll()
        
        
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let dotRadians = CGFloat.pi * 2 / CGFloat(numberOfDot)
        
        let shiningAnimation = CABasicAnimation(keyPath: "backgroundColor")
        for i in 0..<numberOfDot {
            let shapeL = CAShapeLayer()
            shapeL.frame = CGRect(x: 0, y: 0, width: dotSize, height: dotSize)
            shapeL.cornerRadius = dotSize / 2
            shapeL.position = pointAroundCircumference(center: center, radius: center.x - circleWidth / 2, theta: CGFloat(i) * dotRadians)
            shapeL.backgroundColor = i % 2 == 0 ? dotColor.cgColor : dotShiningColor.cgColor
            dotLayers.append(shapeL)
            layer.addSublayer(shapeL)
            
            shiningAnimation.fromValue = shapeL.backgroundColor
            shiningAnimation.toValue = i % 2 == 0 ? dotShiningColor.cgColor : dotColor.cgColor
            shiningAnimation.duration = 0.25
            shiningAnimation.repeatCount = Float.infinity
            shiningAnimation.autoreverses = false
            
            shapeL.add(shiningAnimation, forKey: "backgroundColor")
            
        }
    }
}
