//
//  Dictionary+Jn.swift
//  SwiftProject
//
//  Created by hjn on 2020/12/29.
//

import Foundation

public extension Dictionary {
    func convertDictionaryToString() -> String? {
        do {
            let jsonAddressData =  try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let jsonaddressString: String = NSString(data: jsonAddressData, encoding: String.Encoding.utf8.rawValue)! as String
            return jsonaddressString
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func printAsJSON() {
        #if DEBUG
        if let json = convertDictionaryToString()  {
            print(json)
        }
        #endif
    }
}

public extension Dictionary {
    
    func groupBy<U>(groupingFunction group: (Key, Value) -> U) -> [U: Dictionary] {
        var result = [U: Dictionary]()
        for item in self {
            let groupKey = group(item.key, item.value)
            if let value = result[groupKey] {
                var newValue = value
                newValue.updateValue(item.value, forKey: item.key)
                result.updateValue(newValue, forKey: groupKey)
            } else {
                let newValue = Dictionary(dictionaryLiteral: item)
                result.updateValue(newValue, forKey: groupKey)
            }
        }
        return result
    }
    
    func countBy<U>(groupingFunction group: (Key, Value) -> U) -> [U: Int] {
        var result = [U: Int]()
        for item in self {
            let groupKey = group(item.key, item.value)
            if let value = result[groupKey] {
                let newValue = value + 1
                result.updateValue(newValue, forKey: groupKey)
            } else {
                result.updateValue(1, forKey: groupKey)
            }
        }
        return result
    }
    
    func countWhere(_ check: (Key, Value) -> Bool) -> Int {
        var result = 0
        for item in self {
            if check(item.key, item.value) {
                result += 1
            }
        }
        return result
    }
}

