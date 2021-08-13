//
//  Array+Jn.swift
//  SwiftProject
//
//  Created by hjn on 2020/12/29.
//

import Foundation

public extension Array {
    func convertArrayToString() -> String? {
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
        if let json = convertArrayToString()  {
            print(json)
        }
        #endif
    }
}
