//
//  JNModel.swift
//  SwiftProject
//
//  Created by Miles on 2021/8/9.
//

import Foundation
import RxDataSources
import HandyJSON

struct JNModel: HandyJSON {
    var _id: String?
    var createdAt: String?
    var desc: String = ""
    var publishedAt: String?
    var source: String = ""
    var type: String?
    var url: String = ""
    var used: String?
    var who: String?
}


// SectionModel

struct JNSection {
    var items:[Item]
}

extension JNSection: SectionModelType {
    
    typealias Item = JNModel
    
    init(original: JNSection, items: [JNModel]) {
        self = original
        self.items = items
    }
}
