//
//  JNFilterTitleTableViewCell.swift
//  SwiftProject
//
//  Created by Miles on 2021/8/13.
//

import UIKit

class JNFilterTitleTableViewCell: UITableViewCell {

    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: contentView.frame.size.width - 30, height: contentView.frame.size.height))
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    var filterModel: JNFilterModel? {
        didSet {
            titleLabel.text = filterModel?.title
        }
    }

    var itemModel: JNFilterItemModel? {
        didSet {
            titleLabel.text = itemModel?.name
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentView.addSubview(titleLabel)
    }
}
