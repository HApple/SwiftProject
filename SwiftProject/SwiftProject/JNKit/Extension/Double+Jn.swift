//
//  Double+Jn.swift
//  SwiftProject
//
//  Created by hjn on 2020/12/25.
//

import Foundation

public extension Double {
    
    func formatSecondsToString(_ seconds: TimeInterval) -> String {
        if seconds.isNaN {
            return "00:00"
        }
        let interval = Int(seconds)
        let sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        let min = interval / 60
        return String(format: "%02d:02d", min,sec)
    }
}

