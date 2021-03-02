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
        
        let leftView = UIButton(type: .custom)
        leftView.titleLabel?.numberOfLines = 2
        let lsub1 = "加入购物车\n"
        let lsub2 = "3.8节 ￥25起"
        let string = lsub1 + lsub2
        let attr = string.mutableAttributedString
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.alignment = .center
        attr.addAttribute(.font, value: UIFont.systemFont(ofSize: 13), range: lsub1.range)
        attr.addAttribute(.font, value: UIFont.systemFont(ofSize: 10), range: NSRange(location: lsub1.count, length: lsub2.count))
        attr.addAttribute(.foregroundColor, value: UIColor.white, range: string.range)
        attr.addAttribute(.paragraphStyle, value: paragraphStyle, range: string.range)
        leftView.setAttributedTitle(attr, for: .normal)
        view.addSubview(leftView)
        
        leftView.snp.makeConstraints { (make) in
            make.width.equalTo(120)
            make.height.equalTo(40)
            make.top.equalTo(120)
            make.centerX.equalToSuperview().offset(-60)
        }
                
        leftView.addShadowWith(shadowColor: .red,
                               offSet: CGSize(width: 3, height: 3),
                               opacity: 1,
                               shadowRadius: 20,
                               shadowSides: .topLeftRight,
                               fillColor: 0xFC9427.color,
                               radius: 20,
                               corners: [.topLeft,.bottomLeft])
        leftView.addGradient(colors: [0xFDC62E.color,0xFC9126.color], radius: 20, corners: [.topLeft,.bottomLeft])
        
        let rightView = UIButton(type: .custom)
        rightView.setTitle("立即购买", for: .normal)
        rightView.setTitleColor(.white, for: .normal)
        rightView.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(rightView)
        rightView.snp.makeConstraints { (make) in
            make.width.height.top.equalTo(leftView)
            make.left.equalTo(leftView.snp.right)
        }
        rightView.addShadowWith(shadowColor: .red,
                               offSet: CGSize(width: 3, height: 3),
                               opacity: 1,
                               shadowRadius: 20,
                               shadowSides: .bottomLeftRight,
                               fillColor: 0xFC4D1E.color,
                               radius: 20,
                               corners: [.topRight,.bottomRight])
    }

}
