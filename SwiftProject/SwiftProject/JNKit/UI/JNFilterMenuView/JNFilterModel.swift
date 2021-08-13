//
//  JNFilterModel.swift
//  SwiftProject
//
//  Created by Miles on 2021/8/13.
//

import Foundation
import UIKit

class JNFilterModel {
    
    var title: String?                          //标题
    var code: String?                           //code
    var itemArr: [JNFilterItemModel]?           //item数据
    var selectArr: [JNFilterItemModel]?         //选择的数据
    var multiple: Bool = false                  //是否多选
    var selected: Bool = false                  //是否已选
    var selectFirst: Bool = true                //是否选择第一个
    var minPrice: String?                       //输入框最低值
    var maxPrice: String?                       //输入框最大值
    var listHeight: CGFloat?                    //列表高度(用于内部列表展示时使用)
    
    init() {
        
    }
    
    init(with headTitle: String,
         code:String = "",
         modelArr:[JNFilterItemModel],
         selectFirst: Bool,
         multiple: Bool) {
        self.title = headTitle
        self.code = code
        self.itemArr = modelArr
        self.selectArr = [JNFilterItemModel]()
        self.multiple = multiple
        if let select = modelArr.first?.selected {
            self.selectFirst = select
        }
    }
    
    func setModelItemSelectFalse() {
        minPrice = ""
        maxPrice = ""
        selectArr = [JNFilterItemModel]()
        itemArr?.forEach { $0.selected = false }
    }
    
    func setModelItemSelectFirst() {
        guard let array = itemArr else { return }
        for (i,item) in array.enumerated() {
            item.selected = i == 0 ? true : false
        }
    }
    
    var selectedItemModel: JNFilterItemModel? {
        get {
            itemArr?.first(where: { $0.selected == true})
        }
    }
    
    var selectedItemModelCode: String? {
        get {
            itemArr?.first(where: { $0.selected == true})?.code
        }
    }
    
    var selectedItemModelArr: [JNFilterItemModel]? {
        itemArr?.filter { $0.selected == true}.copy
    }
}

//深拷贝
extension JNFilterModel: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let model = JNFilterModel()
        model.title = title
        model.code = code
        model.itemArr = itemArr?.copy
        model.selectArr = selectArr?.copy
        model.multiple = multiple
        model.selectFirst = selectFirst
        model.minPrice = minPrice
        model.maxPrice = maxPrice
        model.listHeight = listHeight
        return model
    }
}
