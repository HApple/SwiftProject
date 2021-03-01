//
//  Learn-CGRect.swift
//  SwiftProject
//
//  Created by hjn on 2021/2/20.
//

import UIKit

class LearnCGrectViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let greenView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        greenView.backgroundColor = .green
        view.addSubview(greenView)
        
        //获取view的最小X值，也就是这个view的frame.origin.x
        let minX: CGFloat = greenView.frame.minX
        print("minX is \(minX)")
        
        //获取view的最大的X值，也就是这个view的 frame.origin.x + frame.size.width
        let maxX: CGFloat = greenView.frame.maxX
        print("maxX is \(maxX)")
        
        //获取view的最小Y值，也就是这个view的frame.origin.y
        let minY: CGFloat = greenView.frame.minY
        print("minY is \(minY)")
        
        //获取view的最大Y值，也就是这个view的frame.origin.y + frame.size.height
        let maxY: CGFloat = greenView.frame.maxY
        print("maxY is \(maxY)")
        
        //获取view的中点X 也就是这个view的frame.origin.x + frame.size.width / 2
        let midX: CGFloat = greenView.frame.midX
        print("midX is \(midX)")
        
        //获取view的中点Y 也就是这个view的frame.origin.y + frame.size.height / 2
        let midY: CGFloat = greenView.frame.midY
        print("midY is \(midY)")
        
        //获取view的宽
        let width: CGFloat = greenView.frame.width
        print("width is \(width)")
        
        //获取view的高
        let height: CGFloat = greenView.frame.height
        print("height is \(height)")
        
        //判断两个view大小是否一样
        let flag = view.frame.equalTo(self.view.frame)
        print("flag is \(flag)")
        
        //Returns a rectangle with a positive width and height
        let rectStandardized = view.frame.standardized
        print("rectStandardized: \(rectStandardized)")
        
        //A null rectangle is the equivalent of an empty set. For example, the result of intersecting two disjoint rectangles is a null rectangle. A null rectangle cannot be drawn and interacts with other rectangles in special ways.
        let flag1 = view.frame.isNull
        print("flag1 is \(flag1)")
        
        //Returns whether a rectangle has zero width or height, or is a null rectangle
        let flag2 = view.frame.isEmpty
        print("flag2 is \(flag2)")
        
        
        
        let insetRect: CGRect = greenView.frame.insetBy(dx: 10, dy: 10)
        let redView = UIView(frame: insetRect)
        redView.backgroundColor = UIColor.red
        view.addSubview(redView)
        
        
        
        
    }
}
