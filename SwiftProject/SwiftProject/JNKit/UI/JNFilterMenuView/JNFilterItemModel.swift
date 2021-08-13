//
//  JNFilterItemModel.swift
//  SwiftProject
//
//  Created by Miles on 2021/8/13.
//

import Foundation

class JNFilterItemModel {
    
    var selected: Bool = false          //标记选择状态
    var name: String?                   //名称
    var code: String?                   //code
    var parentCode: String?             //父类code
    var minPrice: String?               //输入框最低值
    var maxPrice: String?               //输入框最大值

//    var itemArry:[JNFilterItemModel]?   //item数据（暂时无用，后续拓展多层级展示时可使用）
}

// 深拷贝
extension JNFilterItemModel: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let model = JNFilterItemModel()
        model.code = code
        model.selected = selected
        model.name = name
        model.parentCode = parentCode
        model.minPrice = minPrice
        model.maxPrice = maxPrice
        return model
    }
}

//数组拓展 深拷贝
extension Array where Element: NSCopying {
    //返回元素支持拷贝数组的深拷贝
    public var copy:[Element] {
        return self.map { $0.copy(with: nil) as! Element }
    }
}
