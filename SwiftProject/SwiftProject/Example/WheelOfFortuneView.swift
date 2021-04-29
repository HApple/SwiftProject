//
//  WheelOfFortuneView.swift
//  SwiftProject
//
//  Created by Miles on 2021/3/29.
//

import UIKit

class WheelOfFortuneView: UIView {

    var circleWidth: CGFloat = 20
    
    lazy var dotOnCicleView:JNDotOnCicleView = {
       let view = JNDotOnCicleView()
        view.circleWidth = circleWidth
       return view
    }()
    
    lazy var pieChartView: JNPieChartView = {
        let view = JNPieChartView(frame: .zero)
        view.delegate = self
        view.datasource = self
        return view
    }()
    
    var prizes: [String] = [String]()
    var pieColors: [UIColor] = [UIColor]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dotOnCicleView.frame = bounds
        pieChartView.frame = bounds.inset(by: UIEdgeInsets(top: circleWidth, left: circleWidth, bottom: circleWidth, right: circleWidth))
        
        layer.cornerRadius = bounds.size.width / 2
        layer.masksToBounds = true
    }
    
    func setup() {

        prizes = ["黄健娜", "B", "C", "D", "E", "F"]
        pieColors = [.black, .blue, .cyan, .brown, .green, .red]
        
        addSubview(dotOnCicleView)
        addSubview(pieChartView)
    }
        
}

// MARK:- JNPieChartViewDelegate / JNPieChartViewDataSource
extension WheelOfFortuneView: JNPieChartViewDelegate, JNPieChartViewDataSource {
    func pieChartView(_ pieChartView: JNPieChartView, colorForSliceAt index: Int) -> UIColor {
        return pieColors[index]
    }
    
    func pieChartView(_ pieChartView: JNPieChartView, valueForSliceAt index: Int) -> CGFloat {
        return 100 / CGFloat(prizes.count)
    }
    
    var centerCircleRadius: CGFloat {
        return 0
    }
    
    func numberOfSlicesIn(pieChartView: JNPieChartView) -> Int {
        return prizes.count
    }
    
    func pieChartView(_ pieChartView: JNPieChartView, titleForSliceAt index: Int) -> String {
        return prizes[index]
    }
    
}
