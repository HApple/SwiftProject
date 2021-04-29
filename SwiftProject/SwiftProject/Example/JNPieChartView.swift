//
//  JNPieChartView.swift
//  SwiftProject
//
//  Created by Miles on 2021/3/30.
//

import UIKit

protocol JNPieChartViewDelegate: class {
    var centerCircleRadius: CGFloat { get }
}

protocol JNPieChartViewDataSource: class {
    func numberOfSlicesIn(pieChartView: JNPieChartView) -> Int
    func pieChartView(_ pieChartView: JNPieChartView, valueForSliceAt index: Int) -> CGFloat
    func pieChartView(_ pieChartView: JNPieChartView, colorForSliceAt index: Int) -> UIColor
    func pieChartView(_ pieChartView: JNPieChartView, titleForSliceAt index: Int) -> String
    func pieChartView(_ pieChartView: JNPieChartView, imageNameForSliceAt index: Int) -> String
}

extension JNPieChartViewDataSource {
    func pieChartView(_ pieChartView: JNPieChartView, titleForSliceAt index: Int) -> String { return "" }
    func pieChartView(_ pieChartView: JNPieChartView, imageNameForSliceAt index: Int) -> String { return "" }
}

class JNPieChartView: UIView {

    
    weak var datasource: JNPieChartViewDataSource?
    weak var delegate: JNPieChartViewDelegate?
    lazy var imageRenderQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "ImageRanderQueue"
        return queue
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadData() {
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        
        // Drawing code
        
        // prepare
        let context = UIGraphicsGetCurrentContext()
        let theHalf = rect.size.width / 2
        var lineWidth = theHalf
        if let radius = delegate?.centerCircleRadius {
            lineWidth = lineWidth - radius
            assert(lineWidth <= theHalf, "wrong circle radius")
        }
        let radius = theHalf - lineWidth / 2
        let centerX = theHalf
        let centerY = rect.size.height / 2
        
        
        //drawing
        var sum: CGFloat = 0
        guard let slicesCount = datasource?.numberOfSlicesIn(pieChartView: self) else { return }
        
        for i in 0..<slicesCount {
            guard let value = datasource?.pieChartView(self, valueForSliceAt: i) else { return }
            sum = sum + value
        }
        
        //起始位置
        var startAngle:CGFloat = 0
        var endAngle: CGFloat = 0
        for i in 0..<slicesCount {
            guard let value = datasource?.pieChartView(self, valueForSliceAt: i) else { return }
            endAngle = startAngle + (value / sum) * CGFloat.pi * 2
            /*
             CoreGraphics 绘图系统 和 Bezier贝塞尔曲线坐标系的顺时针方向是相反的
             就问你懵不懵！！！
             
             berzier的顺时针 是真实世界时钟的顺时针
             CoreGraphics 顺时针 其实是真实世界时钟的逆时针

             */
            context?.addArc(center: CGPoint(x: centerX, y: centerY),
                            radius: radius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: false)
            
            guard let drawColor = datasource?.pieChartView(self, colorForSliceAt: i) else { return }
            context?.setStrokeColor(drawColor.cgColor)
            context?.setLineWidth(lineWidth)
            context?.strokePath()
            
            // 图片
            if let imageName = datasource?.pieChartView(self, imageNameForSliceAt: i) {
                let imgL = CALayer()
                let operation = BlockOperation {
                    
                    OperationQueue.main.addOperation {
                        let image = UIImage(named: imageName)
                        
                    }
                    
                }
                
                
                
            }

            // 文字
            if let title = datasource?.pieChartView(self, titleForSliceAt: i) {
                let textFontSize: CGFloat = 12
                let attr = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: textFontSize)]
                let text = NSAttributedString(string: title, attributes: attr)
                let textAtAngle =   endAngle + (value / sum) * CGFloat.pi * 2 * 0.5
                drawCurveStringOnLayer(context: context, text: text, atAngle: textAtAngle, radius: centerX - textFontSize - 5)
            }
            
            
            startAngle = endAngle
    
        }
    }
    
    
    // draw fan shaped text(sector text) 画扇形字
    func drawCurveStringOnLayer(context:CGContext?, text: NSAttributedString, atAngle: CGFloat, radius: CGFloat) {
        
        let textSize = text.boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).integral.size
        let perimeter = CGFloat.pi * 2 * radius
        let textAngle = textSize.width / perimeter * CGFloat.pi * 2
        
        var textRotation: CGFloat = 0
        var textDirection: CGFloat = 0
        var angle = atAngle
        
        // 方向 使文字 可读
        if angle > CGFloat(10).degreesToRadians && angle < CGFloat(170).degreesToRadians {
            //bottom string
            textRotation = 0.5 * CGFloat.pi
            textDirection = -2 * CGFloat.pi
            angle += textAngle / 2
        }else {
            //top string
            textRotation = 1.5 * CGFloat.pi
            textDirection = 2 * CGFloat.pi
            angle -= textAngle / 2
        }
        
        for c in 0..<text.length {
            let range = NSRange(location: c, length: 1)
            let letter = text.attributedSubstring(from: range)
            let charSize = letter.boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).integral.size
            let letterAngle = (charSize.width / perimeter) * textDirection
            let x = radius * cos(angle + (letterAngle / 2))
            let y = radius * sin(angle + (letterAngle / 2))
            let letterFrame = CGRect(x: layer.frame.size.width / 2 - charSize.width / 2 + x,
                                     y: layer.frame.size.height / 2 - charSize.height / 2 + y,
                                     width: charSize.width,
                                     height: charSize.height)
            let singleCharL = getTextLayer(attrStr: letter, frame: letterFrame, opacity: 1)
            
            let transform = CGAffineTransform.identity.rotated(by: angle - textRotation)
            singleCharL.transform = CATransform3DMakeAffineTransform( transform )
            
            layer.addSublayer(singleCharL)
                        
            angle += letterAngle
            
        }
        
    }
    
    
    func getTextLayer(attrStr: NSAttributedString, frame: CGRect, opacity: Float) -> CATextLayer {
        let textL = CATextLayer()
        textL.frame = frame
        textL.string = attrStr
        textL.alignmentMode = .center
        textL.contentsScale = UIScreen.main.scale
        textL.opacity = opacity
        return textL
    }

}
