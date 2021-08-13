//
//  CMTime+Jn.swift
//  xiaoshutong
//
//  Created by Miles on 2021/4/15.
//

import Foundation
import AVKit

extension CMTime {
    func getFormattedString() -> String {
        let totalSeconds = Int(self.toSeconds())
        let second = totalSeconds % 60
        let minute = totalSeconds / 60
        let hours = minute / 60
        //https://stackoverflow.com/questions/25566581/leading-zeros-for-int-in-swift
        //不夠兩位數就補0, 5 > 05
        let formattedString = String(format: "%02d:%02d:%02d", hours,minute,second)
        return formattedString
    }
    func toSeconds() -> Float64 {
        return CMTimeGetSeconds(self)
    }
}
