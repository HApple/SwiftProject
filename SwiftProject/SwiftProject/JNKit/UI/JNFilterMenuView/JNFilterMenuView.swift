//
//  JNFilterMenuView.swift
//  SwiftProject
//
//  Created by Miles on 2021/8/13.
//

import UIKit

/** 确定类型 */
enum JNFilterMenuConfirmType: Int {
    case speed        //列表快速点击选择
    case bottom       //底部确定按钮选择
}

/** 下拉展示类型 */
enum JNFilterMenuDownType: Int {
    case twoLists          //双列表
    case onlyItem          //可点item
    case onlyList          //单列表
    case itemInput         //可点item加输入框
}

/** 警告类型（方便后续拓展） */
enum JNFilterMenuViewWarnType: Int {
    case input    //输入框价格区间不正确
}

protocol JNFilterMenuViewDelegate: AnyObject {
    /** 确定回调 */
    func menuView(_ menuView: JNFilterMenuView, didSelectConfirmAt selectedModelArr:[JNFilterItemModel])
    /** 警告回调(用于错误提示) */
    func menuView(_ menuView: JNFilterMenuView, warnType: JNFilterMenuViewWarnType)
    /** 消失回调 */
    func menuView(_ menuView: JNFilterMenuView, didHideAt selectedModelArr:[JNFilterItemModel])
    /** 列表将要显示回调 */
    func menuView(_ menuView: JNFilterMenuView, willShowAt tabIndex: Int)
    /** 点击菜单回调 */
    func menuView(_ menuView: JNFilterMenuView, selectMenuAt tabIndex: Int)
}
extension JNFilterMenuViewDelegate {
    func menuView(_ menuView: JNFilterMenuView, warnType: JNFilterMenuViewWarnType) {}
}

protocol JNFilterMenuViewDataSource: AnyObject {
    /** 返回每个 tabIndex 下的确定类型 */
    func menuView(_ menuView: JNFilterMenuView, confirmTypeIn tabIndex: Int) -> JNFilterMenuConfirmType
    /** 返回每个 tabIndex 下的下拉展示类型 */
    func menuView(_ menuView: JNFilterMenuView, downTypeIn tabIndex: Int) -> JNFilterMenuDownType
}




class JNFilterBottomView: UIView {
    
    lazy var resetButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 20, y: 20, width: frame.size.width / 2 - 40, height: frame.size.height - 40)
        btn.setTitle("重置", for: .normal)
        btn.setTitleColor(JNFilterMenuView.Appearance.titleSelectedColor, for: .normal)
        btn.backgroundColor = .white
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 2
        btn.layer.borderColor = JNFilterMenuView.Appearance.titleSelectedColor?.cgColor
        btn.layer.borderWidth = 1
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return btn
    }()
    
    lazy var confirmButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: frame.size.width / 2 + 20, y: 20, width: frame.size.width / 2 - 40, height: frame.size.height - 40)
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = JNFilterMenuView.Appearance.titleSelectedColor
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 2
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return btn
    }()
    
    convenience init(with target:Any?, resetAction: Selector, confirmAction: Selector) {
        self.init()
        backgroundColor = .white
        addSubview(resetButton)
        addSubview(confirmButton)
        
        resetButton.addTarget(target, action: resetAction, for: .touchUpInside)
        confirmButton.addTarget(target, action: confirmAction, for: .touchUpInside)
    }
    
    
}


class JNFilterMenuView: UIView {
    
    struct Appearance {
        
        static let screenWidth = UIScreen.main.bounds.size.width
        static let screenHeight = UIScreen.main.bounds.size.height
        static let tableViewHeight:CGFloat = 44
        static let bottomViewHeight: CGFloat = 80
        
        static let titleColor = UIColor(hex: 0x333333)
        static let titleSelectedColor = UIColor(hex: 0x3072f5)
        static let lineColor = UIColor(hex: 0xe8e8e8)
        static let itemBGColor = UIColor(hex: 0xf5f5f5)
        static let itemBGSelectedColor = UIColor(hex: 0xeef6ff)
    }
 
    
    var leftTableView: UITableView?
    var mediumTableView: UITableView? //后续拓展使用
    var rightTableView: UITableView?
    var backGroudView: UIView?
    var lineView: UIView?
    var bottomView: JNFilterBottomView?
    var menuCount: Int?
    var selectedTabIndex: Int = -1
    var maxHeight: CGFloat?
    var isShow: Bool? //是否展开
    var itemManager: JNFilterItemManager?
    var dataArr: [JNFilterItemModel]?
    
    convenience init(frame: CGRect, maxHeight: CGFloat) {
        self.init(frame: frame)
        backgroundColor = .white
        itemManager = JNFilterItemManager()
        itemManager?.width = frame.size.width
        itemManager?.maxLength = 7
        
    }

}
