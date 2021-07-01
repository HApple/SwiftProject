//
//  FasterUIViewController.swift
//  SwiftProject
//
//  Created by hjn on 2021/3/2.
//

import UIKit
import SnapKit

class FasterUIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupBadge()
        setupWheelOfFortuneView()
    }

}



// MARK: - Badge
extension FasterUIViewController {
    
    func setupBadge() {
        
        let button = UIButton(type: .custom)
        button.setTitle("消息", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(30)
            make.top.equalTo(200)
            make.centerX.equalToSuperview()
        }
        button.badgeCenterOffset = CGPoint(x: 10, y: 0)
        button.showBadge(style: .number, value: 7, animType: .shake)
        
    }
}

extension FasterUIViewController {
    func setupWheelOfFortuneView() {
        
        let wheelView = WheelOfFortuneView()
        view.addSubview(wheelView)
        wheelView.snp.makeConstraints { (make) in
            make.width.height.equalTo(300)
            make.top.equalTo(250)
            make.centerX.equalToSuperview()
        }
    }
}
