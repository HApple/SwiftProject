//
//  Data+Jn.swift
//  SwiftProject
//
//  Created by hjn on 2020/12/29.
//

import Foundation

public extension Data {
    func printAsJSON() {
        #if DEBUG
        if let theJSONData = try? JSONSerialization.jsonObject(with: self, options: []) as? NSDictionary {
            var swiftDict:[String: Any] = [:]
            for key in theJSONData.allKeys {
                let stringKey = key as? String
                if let key = stringKey, let keyValue = theJSONData.value(forKey: key) {
                    swiftDict[key] = keyValue
                }
            }
            swiftDict.printAsJSON()
        }
        #endif
    }
}
