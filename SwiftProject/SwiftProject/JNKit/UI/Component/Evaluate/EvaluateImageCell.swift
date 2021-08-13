//
//  EvaluateImageCell.swift
//  SwiftProject
//
//  Created by Miles on 2021/8/4.
//

import UIKit
import Kingfisher
import SnapKit

class EvaluateImageCell: UICollectionViewCell {
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        self.addSubview(self.imageView)
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 5
        self.imageView.contentMode = UIView.ContentMode.scaleAspectFill
        self.imageView.clipsToBounds = true
        self.imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imageURL :String? {
        didSet {
            guard let url = imageURL else {return}
            self.imageView.kf.setImage(with: URL(string:url))
        }
    }
}
