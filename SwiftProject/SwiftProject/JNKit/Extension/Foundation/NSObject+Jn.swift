//
//  NSObject+Jn.swift
//  SwiftProject
//
//  Created by hjn on 2021/3/2.
//

import Foundation

extension NSObject {
  class func swiftClassFromString(className: String) -> AnyClass! {
    if let appName: NSString = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! NSString? {
        let fAppName = appName.replacingOccurrences(of: " ", with: "_", options: NSString.CompareOptions.literal, range: NSRange(location: 0, length: appName.length))
      return NSClassFromString("\(fAppName).\(className)")
    }
    return nil;
  }
}


