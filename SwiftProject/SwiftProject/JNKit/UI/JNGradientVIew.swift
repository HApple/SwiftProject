//
//  JNGradientVIew.swift
//  SwiftProject
//
//  Created by hjn on 2021/3/3.
//
// from https://appcodelabs.com/create-ibdesignable-gradient-view-swift

import UIKit

@IBDesignable
class JNGradientView: UIView {
    
    // 渐变开始颜色
    @IBInspectable var startColor: UIColor? {
        didSet {
            updateGradient()
        }
    }
    
    // 渐变结束颜色
    @IBInspectable var endColor: UIColor? {
        didSet {
            updateGradient()
        }
    }
    
    // 渐变角度  逆时针方向 0从 东/右边 开始
    // 这个角度最终换算成 startPoint endPoint
    // 默认值270 相当于 startPoint(0.5,0) endPoint(1,0.5), 可以画图仔细想想
    @IBInspectable var angle: CGFloat = 270 {
        didSet {
            updateGradient()
        }
    }
    
    // 渐变层
    private var gradient: CAGradientLayer?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        installGradient()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        installGradient()
    }
    
    
    private func installGradient() {
        if let gradient = self.gradient {
            gradient.removeFromSuperlayer()
        }
        let gradient = createGradient()
        self.layer.addSublayer(gradient)
        self.gradient = gradient
    }
    
    
    func updateGradient() {
        if let gradient = self.gradient {
            let startColor = self.startColor ?? .clear
            let endColor = self.endColor ?? .clear
            gradient.colors = [startColor, endColor]
            let (start, end) = gradientPoints(forAngle: self.angle)
            gradient.startPoint = start
            gradient.endPoint = end
        }
    }
    
    private func createGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        return gradient
    }
    
    // create vector pointing in direction of angle
    private func gradientPoints(forAngle angle: CGFloat) -> (CGPoint, CGPoint) {
        // get vector start and end points
        let end = point(forAngle: angle)
        // let start = point(forAngle: (angle + 180.0))
        let start = oppositePoint(end)
        // convert to gradient space
        let p0 = transformToGradientSpace(start)
        let p1 = transformToGradientSpace(end)
        return (p0, p1)
    }
    
    // get a point corresponding to the angle
    private func point(forAngle angle: CGFloat) -> CGPoint {
        // convert degrees to radians
        let radians = angle * .pi / 180.0
        var x = cos(radians)
        var y = sin(radians)
        // (x,y) is in terms unit circle. Extrapolate to unit square to get full vector length
        if (abs(x) > abs(y)) {
            // extrapolate x to unit length
            x = x > 0 ? 1 : -1
            y = x * tan(radians)
        } else {
            // extrapolate y to unit length
            y = y > 0 ? 1 : -1
            x = y / tan(radians)
        }
        return CGPoint(x: x, y: y)
    }
    
    // transform point in unit space to gradient space
    private func transformToGradientSpace(_ point: CGPoint) -> CGPoint {
        // input point is in signed unit space: (-1,-1) to (1,1)
        // convert to gradient space: (0,0) to (1,1), with flipped Y axis
        return CGPoint(x: (point.x + 1) * 0.5, y: 1.0 - (point.y + 1) * 0.5)
    }
    
    // return the opposite point in the signed unit square
    private func oppositePoint(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: -point.x, y: -point.y)
    }
    
    // 确保 gradient 在 IB 中 初始化
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        installGradient()
        updateGradient()
    }
}
