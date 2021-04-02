//
//  JNVerticalAlignLabel.swift
//  SwiftProject
//
//  Created by hjn on 2021/3/3.
//

import UIKit

@IBDesignable
public class JNVerticalAlignLabel: UILabel {
    
    @IBInspectable var top: Bool = false {
        didSet {
            self.verticalTextAligment = top ? .top : .center
        }
    }
    
    @IBInspectable var bottom: Bool = false {
        didSet {
            self.verticalTextAligment = bottom ? .bottom : .center
        }
    }
    
    // 设置文本垂直对齐方式后调用 setNeedsDisplay ，系统会自动调用 drawTextInRect
    public var verticalTextAligment: VerticalTextAlignment = .center {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // 重写父类 drawTextInRect 方法，调用本类 textRectForBounds 方法
    public override func drawText(in rect: CGRect) {
        let actualRect = self.textRect(forBounds: rect, limitedToNumberOfLines: numberOfLines)
        super.drawText(in: actualRect)
    }
    
    // 重写父类 textRectForBounds 方法，修改并返回 textRect
    public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        switch self.verticalTextAligment {
        case .top:
            textRect.origin.y = bounds.origin.y
        case .bottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height
        case .center:
            textRect.origin.y = (bounds.origin.y + bounds.size.height - textRect.size.height) * 0.5
        }
        return textRect
    }
    
    public enum VerticalTextAlignment {
        case top
        case center
        case bottom
    }
}
