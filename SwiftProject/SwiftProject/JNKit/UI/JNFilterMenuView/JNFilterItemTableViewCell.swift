//
//  JNFilterItemTableViewCell.swift
//  SwiftProject
//
//  Created by Miles on 2021/8/13.
//

import UIKit
import SwifterSwift

enum JNFilterItemType: Int {
    case onlyItem // 可点item
    case itemInput // 可点item加输入框
}

class JNFilterItemManager {
    var titleColor: UIColor?
    var titleSelectedColor: UIColor?
    var itemBGColor: UIColor?
    var itemBGSelectedColor: UIColor?
    var itemTitleFontSize: CGFloat?
    var width: CGFloat = 50
    var space: CGFloat = 15         //item间隔
    var itemHeight: CGFloat = 30    //item高度
    var lineNum: Int = 4            //一行展示数量(默认4，当内容字符数大于7时 lineNum = 2)
    var maxLength: Int = 7          //输入框最大文本数量

}


class JNFilterItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var minTextField: UITextField!
    @IBOutlet weak var maxTextField: UITextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewBottom: NSLayoutConstraint!
    
    var buttonArr:[UIButton] = [UIButton]()
    var maxCount: Int = 0
        
    var itemType: JNFilterItemType? {
        didSet {
            switch itemType {
            case .onlyItem:
                titleLabel.isHidden = false
                leftButton.isHidden = true
                rightButton.isHidden = true
                bottomView.isHidden = true
                bottomViewBottom.constant = 0
            case .itemInput:
                titleLabel.isHidden = true
                leftButton.isHidden = false
                rightButton.isHidden = false
                bottomView.isHidden = false
                bottomViewBottom.constant = 90
            case .none:
                break
            }
        }
    }
    
    var itemManager: JNFilterItemManager = JNFilterItemManager() {
        didSet {
            leftButton.setTitleColor(itemManager.titleColor?.withAlphaComponent(0.6), for: .normal)
            leftButton.setTitleColor(itemManager.titleSelectedColor, for: .selected)
            rightButton.setTitleColor(itemManager.titleColor?.withAlphaComponent(0.6), for: .normal)
            rightButton.setTitleColor(itemManager.titleSelectedColor, for: .selected)
        }
    }
    
    var modelArr:[JNFilterModel]? {
        didSet {
            maxCount = modelArr?.filter { $0.itemArr?.count ?? 0 > maxCount }.count ?? 0
            if itemType == .itemInput {
                if modelArr?.count ?? 0 > 1 {
                    leftButton.setTitle(modelArr?.first?.title, for: .normal)
                    rightButton.setTitle(modelArr?.last?.title, for: .normal)
                    if !leftButton.isSelected && !rightButton.isSelected {
                        leftButton.isSelected = true
                        filterModel = modelArr?.first
                        filterModel?.selected = true
                    }
                }else {
                    titleLabel.isHidden = false
                    leftButton.isHidden = true
                    rightButton.isHidden = true
                }
            }
        }
    }
    
    var filterModel: JNFilterModel? {
        didSet {
            if itemType == .itemInput {
                minTextField.text = filterModel?.minPrice
                maxTextField.text = filterModel?.maxPrice
            }
            titleLabel.text = filterModel?.title
            createButtonItem()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        minTextField.addTarget(self, action: #selector(textFieldChanged(sender:)), for: .editingChanged)
        maxTextField.addTarget(self, action: #selector(textFieldChanged(sender:)), for: .editingChanged)
        
    }
    
    func createButtonItem() {
        itemView.subviews.forEach { $0.removeSubviews() }
        buttonArr.removeAll()
        guard let itemArr = filterModel?.itemArr else {
            return
        }
        
        for (i, model) in itemArr.enumerated() {
            let button = UIButton(type: .custom)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 2
            button.tintColor = .clear
            button.setTitle(model.name, for: .normal)
            button.setTitleColor(itemManager.titleColor, for: .normal)
            button.setTitleColor(itemManager.titleSelectedColor, for: .selected)
            button.setBackgroundImage(UIImage.imageWith(color: itemManager.itemBGColor), for: .normal)
            button.setBackgroundImage(UIImage.imageWith(color: itemManager.itemBGSelectedColor), for: .selected)
            button.tag = i
            button.addTarget(self, action: #selector(itemButtonTap(_:)), for: .touchUpInside)
            itemView.addSubview(button)
            let itemWidth = (itemManager.width - itemManager.space * CGFloat((itemManager.lineNum + 1))) / CGFloat(itemManager.lineNum)
            let horizolIndex = i % itemManager.lineNum
            let verticalIndex = i / itemManager.lineNum
            let originX =  itemManager.space + CGFloat(horizolIndex) * (itemManager.width + itemManager.space)
            let originY =  itemManager.space +  CGFloat(verticalIndex) * (itemManager.itemHeight + itemManager.space)
            button.frame = CGRect(x: originX, y: originY, width: itemWidth, height: itemManager.itemHeight)
            button.isSelected = model.selected
            buttonArr.append(button)
        }
    }
    
    @objc func itemButtonTap(_ sender: UIButton) {
        minTextField.text = nil
        maxTextField.text = nil
        if filterModel?.multiple ?? false {
            sender.isSelected = !sender.isSelected
            guard let itemModel = filterModel?.itemArr?[sender.tag] else { return }
            itemModel.selected = sender.isSelected
            filterModel?.selectArr =  filterModel?.itemArr?.filter { $0.selected == true }
        }else {
            buttonArr.forEach { btn in
                if btn == sender {
                    btn.isEnabled = true
                }else {
                    btn.isSelected = false
                }
            }
            filterModel?.selectArr = [JNFilterItemModel]()
            guard let itemArr = filterModel?.itemArr else { return }
            for(i, itemModel) in itemArr.enumerated() {
                if i == sender.tag {
                    itemModel.selected = true
                    filterModel?.selectArr = [itemModel]
                }else {
                    itemModel.selected = false
                }
            }
        }
    }
    
    @objc func textFieldChanged(sender: UITextField) {
        
        strLengthLimit(with: sender, maxLength: itemManager.maxLength)
        if sender == minTextField {
            filterModel?.minPrice = sender.text
        }else if sender == maxTextField {
            filterModel?.maxPrice = sender.text
        }
    }
    
    @IBAction func leftButtonTap(_ sender: Any) {
     
        if leftButton.isEnabled { return }
        itemView.subviews.forEach { $0.removeSubviews() }
        buttonArr.removeAll()
        leftButton.isSelected = true
        rightButton.isSelected = false
        modelArr?.first?.selected = true
        modelArr?.last?.selected = false
        modelArr?.first?.setModelItemSelectFalse()
        filterModel = modelArr?.first
    }
    
    @IBAction func rightButtonTap(_ sender: Any) {
        if rightButton.isEnabled { return }
        itemView.subviews.forEach { $0.removeSubviews() }
        buttonArr.removeAll()
        leftButton.isSelected = false
        rightButton.isSelected = true
        modelArr?.last?.selected = true
        modelArr?.first?.selected = false
        modelArr?.last?.setModelItemSelectFalse()
        filterModel = modelArr?.last
    }
    
    /*
     输入框字符数限制，并且未确定文字不做截取处理
     */
    func strLengthLimit(with textField: UITextField, maxLength: Int) {
        let lang = UIApplication.shared.textInputMode?.primaryLanguage ?? ""//键盘输入模式
        if lang == "zh-Hans" { //简体中文输入，包括简体拼音，简体五笔，简体手写
            guard let selectedRange = textField.markedTextRange else { return }
            //获取高亮部分
            let position = textField.position(from: selectedRange.start, offset: 0)
            if position != nil {
                if textField.text?.count ?? 0 > maxLength {
                    textField.text = textField.text?.slice(from: 0, length: maxLength)
                }
            }else {
                // 有高亮选择的字符串，则暂不对文字进行统计和限制
            }
        }else {
            // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if textField.text?.count ?? 0 > maxLength {
                textField.text = textField.text?.slice(from: 0, length: maxLength)
            }
        }
    }

}

extension UIImage {
    
    static func imageWith(color: UIColor?) -> UIImage? {
        guard let color = color else { return nil }
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
