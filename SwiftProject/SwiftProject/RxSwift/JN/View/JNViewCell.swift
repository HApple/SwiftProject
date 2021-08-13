//  JNViewCell.swift
//  SwiftProject
//
//  Created by Miles on 2021/8/10.
//

import UIKit
import Reusable

class JNViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var picView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
