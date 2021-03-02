//
//  UIView+Jn.swift
//  SwiftProject
//
//  Created by hjn on 2020/12/30.
//

import UIKit

public extension UIView {

    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }

    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center.x = newValue
        }
    }
    
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center.y = y
        }
    }
    
    /// 指定方向圆角
    func addRoundedCorner(radius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .clear) {
        DispatchQueue.main.async {
            self.layer.addCornersWith(radius: radius, corners: corners)
        }
    }
    
    /// 指定方向边线
    @discardableResult
    func addBorders(edges: UIRectEdge, color: UIColor, inset: CGFloat = 0.0, thickness: CGFloat = 1.0) -> [UIView] {
        var borders = [UIView]()
        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(
                formats.flatMap {
                    NSLayoutConstraint.constraints(
                        withVisualFormat: $0,
                        options: [],
                        metrics: ["inset": inset, "thickness": thickness],
                        views: ["border": border]
                    )
                }
            )
            borders.append(border)
            return border
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }
        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }
        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }
        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }
        return borders
    }
}

//MARK: - gradient
extension UIView {
    func addGradient(colors: [UIColor],
                     locations: [CGFloat]? = nil,
                     startPoint: CGPoint = CGPoint(x: 0, y: 0.5),
                     endPoint: CGPoint = CGPoint(x: 1.0, y: 0.5),
                     type: CAGradientLayerType = .axial,
                     radius: CGFloat = 0,
                     corners: UIRectCorner = [.bottomRight,.bottomLeft]) {
        DispatchQueue.main.async {
                        
            let sublayer = CAGradientLayer(colors: colors,
                                           locations: locations,
                                           startPoint: startPoint,
                                           endPoint: endPoint,
                                           type: type)
            sublayer.frame = self.bounds
            sublayer.addCornersWith(radius: radius,
                            corners: corners)
            self.layer.addCornersWith(radius: radius, corners: corners)            
            if let shadowLayer = self.layer.sublayers?.first(where: {$0.name == "SHADOW_LAYER"}) {
                shadowLayer.backgroundColor = UIColor.clear.cgColor
                self.layer.insertSublayer(sublayer, above: shadowLayer)
            }else {
                self.layer.insertSublayer(sublayer, at: 0)
            }
            
        }
    }
}

//MARK: - shadow
extension UIView {
    
    enum ShadowPosition: Int {
        case topBottom
        case leftRight
        case topLeftRight
        case bottomLeftRight
        case all
    }
    
    func addShadowWith(shadowColor: UIColor,
                   offSet: CGSize,
                   opacity: Float,
                   shadowRadius: CGFloat,
                   shadowSides: ShadowPosition,
                   fillColor: UIColor = .white,
                   radius: CGFloat = 0,
                   corners: UIRectCorner = [.bottomRight,.bottomLeft]) {
        DispatchQueue.main.async {
            self.layer.addCornersWith(radius: radius,
                            corners: corners)
            
            if let sublayer = self.layer.sublayers?.first(where: {$0.name == "SHADOW_LAYER"}) {
                sublayer.removeFromSuperlayer()
            }
            let shadowLayer = self.getShadowLayer(shadowColor: shadowColor,
                                                  offSet: offSet,
                                                  opacity: opacity,
                                                  shadowradius: shadowRadius,
                                                  shadowSides: shadowSides,
                                                  fillColor: fillColor,
                                                  radius: radius,
                                                  corners: corners)
            self.layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    fileprivate func getShadowLayer(shadowColor: UIColor,
                                offSet: CGSize,
                                opacity: Float,
                                shadowradius: CGFloat,
                                shadowSides: ShadowPosition,
                                fillColor: UIColor = .white,
                                radius: CGFloat = 0,
                                corners: UIRectCorner = [.bottomRight,.bottomLeft]) -> CALayer {
        let shadowLayer: CAShapeLayer = CAShapeLayer()
        let size: CGSize = CGSize(width: radius, height: radius)
        let layerPath: UIBezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size)
        shadowLayer.path = layerPath.cgPath
        shadowLayer.fillColor = fillColor.cgColor
        shadowLayer.name = "SHADOW_LAYER"
        
        let _offset: CGFloat = radius
        let maxX: CGFloat = self.frame.width
        let maxY: CGFloat = self.frame.height
        let minX: CGFloat = 0 + _offset
        let minY: CGFloat = 0 + _offset
        let shadowPath: UIBezierPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: minX, y: 0))
        switch shadowSides {
        case .topBottom:
            shadowPath.move(to: CGPoint(x: 0, y: 0))
            shadowPath.addLine(to: CGPoint(x: maxX, y: 0))
            shadowPath.addLine(to: CGPoint(x: 0, y: maxY))
            shadowPath.addLine(to: CGPoint(x: maxX, y: maxY))
            shadowPath.addLine(to: CGPoint(x: 0, y: 0))
        case .leftRight:
            shadowPath.move(to: CGPoint(x: 0, y: 0))
            shadowPath.addLine(to: CGPoint(x: 0, y: maxY))
            shadowPath.addLine(to: CGPoint(x: shadowradius, y: maxY - shadowradius))
            shadowPath.addLine(to: CGPoint(x: maxX - shadowradius, y: maxY - shadowradius))
            shadowPath.addLine(to: CGPoint(x: maxX, y: maxY))
            shadowPath.addLine(to: CGPoint(x: maxX, y: 0))
            shadowPath.addLine(to: CGPoint(x: maxX - shadowradius, y: shadowradius))
            shadowPath.addLine(to: CGPoint(x: shadowradius, y: shadowradius))
            shadowPath.addLine(to: CGPoint(x: 0, y: 0))
        case .all:
            shadowPath.addLine(to: CGPoint(x: maxX - _offset, y: 0))
            shadowPath.addLine(to: CGPoint(x: maxX, y: maxY - _offset))
            shadowPath.addLine(to: CGPoint(x: minX, y: maxY))
            shadowPath.addLine(to: CGPoint(x: 0, y: minY))
            if _offset > 0 {
                shadowPath.addArc(withCenter: CGPoint(x: maxX - _offset, y: minY), radius: _offset, startAngle: CGFloat(3 * Double.pi / 2), endAngle: 0, clockwise: true)
                shadowPath.addArc(withCenter: CGPoint(x: maxX - _offset, y: maxY - _offset), radius: _offset, startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
                shadowPath.addArc(withCenter: CGPoint(x: minX, y: maxY - _offset), radius: _offset, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
                shadowPath.addArc(withCenter: CGPoint(x: minX, y: minY), radius: _offset, startAngle: CGFloat(Double.pi), endAngle: CGFloat(3*Double.pi / 2), clockwise: true)
            }
        case .topLeftRight:
            shadowPath.addLine(to: CGPoint(x: maxX - _offset, y: 0))
            if _offset > 0 {
                shadowPath.addArc(withCenter: CGPoint(x: maxX - _offset, y: minY), radius: _offset, startAngle: CGFloat((3 * Double.pi) / 2), endAngle: 0, clockwise: true)
            }
            shadowPath.addLine(to: CGPoint(x: maxX, y: maxY))
            shadowPath.addLine(to: CGPoint(x: maxX - 10, y: maxY/2))
            shadowPath.addLine(to: CGPoint(x: 10, y: maxY/2))
            shadowPath.addLine(to: CGPoint(x: 0, y: maxY))
            shadowPath.addLine(to: CGPoint(x: 0, y: minY))
            if _offset > 0 {
                shadowPath.addArc(withCenter: CGPoint(x: minX, y: minY), radius: _offset, startAngle: CGFloat(Double.pi), endAngle: CGFloat((3 * Double.pi) / 2), clockwise: true)
            }
        case .bottomLeftRight:
            shadowPath.move(to: CGPoint(x: maxX, y: 0))
            shadowPath.addLine(to: CGPoint(x: maxX, y: maxY - _offset))
            if _offset > 0 {
                shadowPath.addArc(withCenter: CGPoint(x: maxX - _offset, y: maxY - _offset), radius: _offset, startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
            }
            shadowPath.addLine(to: CGPoint(x: minX, y: maxY))
            if _offset > 0 {
                shadowPath.addArc(withCenter: CGPoint(x: minX, y: maxY - _offset), radius: _offset, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
            }
            shadowPath.addLine(to: CGPoint(x: 0, y: 0))
            shadowPath.addLine(to: CGPoint(x: 10, y: maxY/2))
            shadowPath.addLine(to: CGPoint(x: maxX - 10, y: maxY/2))
            shadowPath.addLine(to: CGPoint(x: maxX, y: 0))
        }
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath = shadowPath.cgPath
        shadowLayer.shadowOffset = offSet
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowradius
        return shadowLayer
    }
    
}


extension CALayer {
    
    func addCornersWith(radius: CGFloat,
                        corners:UIRectCorner) {
    
        guard radius > 0 else {
            self.maskedCorners = []
            return
        }
        var maskedCorners = CACornerMask()
        if corners.contains(.allCorners) {
            maskedCorners = [.layerMinXMinYCorner,
                             .layerMaxXMinYCorner,
                             .layerMinXMaxYCorner,
                             .layerMaxXMaxYCorner]
        } else {
            if corners.contains(.topLeft){
                maskedCorners.insert(.layerMinXMinYCorner)
            }
            if corners.contains(.topRight){
                maskedCorners.insert(.layerMaxXMinYCorner)
            }
            if corners.contains(.bottomLeft){
                maskedCorners.insert(.layerMinXMaxYCorner)
            }
            if corners.contains(.bottomRight){
                maskedCorners.insert(.layerMaxXMaxYCorner)
            }
        }
        self.cornerRadius = radius
        self.maskedCorners = maskedCorners
    }
}
