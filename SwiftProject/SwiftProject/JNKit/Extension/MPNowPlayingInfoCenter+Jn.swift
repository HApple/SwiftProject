//
//  MPNowPlayingInfoCenter+Jn.swift
//  xiaoshutong
//
//  Created by Miles on 2021/4/15.
//

import Foundation
import MediaPlayer

extension MPNowPlayingInfoCenter {

    func setElapsedTime(with elpasedTime: CMTime?){
        guard let elpasedTime = elpasedTime else { return }
        let elpasedTimeWithSeconds = elpasedTime.toSeconds()

        if var nowPlayingInfo = self.nowPlayingInfo {
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elpasedTimeWithSeconds
            self.nowPlayingInfo = nowPlayingInfo
        } else {
            var dictionary = [String : Any]()
            dictionary[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elpasedTimeWithSeconds
            self.nowPlayingInfo = dictionary
        }
    }
    func setDuration(with duration: CMTime?){
        guard let duration = duration else { return }
        let durationWithSeconds = duration.toSeconds()
        
        if var nowPlayingInfo = self.nowPlayingInfo {
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = durationWithSeconds
            self.nowPlayingInfo = nowPlayingInfo
        } else {
            var dictionary = [String : Any]()
            dictionary[MPMediaItemPropertyPlaybackDuration] = durationWithSeconds
            self.nowPlayingInfo = dictionary
        }
    }
    func setInfo(title: String?, artist: String?, image: UIImage?){
        
        if var nowPlayingInfo = self.nowPlayingInfo {
            nowPlayingInfo[MPMediaItemPropertyTitle] = title
            nowPlayingInfo[MPMediaItemPropertyArtist] = artist
            if let image = image {
                let artwork = MPMediaItemArtwork(boundsSize: image.size) { (_) -> UIImage in
                    return image
                }
                nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
            }
            self.nowPlayingInfo = nowPlayingInfo
        } else {
            var dictionary = [String : Any]()
            dictionary[MPMediaItemPropertyTitle] = title
            dictionary[MPMediaItemPropertyArtist] = artist
            if let image = image {
                let artwork = MPMediaItemArtwork(boundsSize: image.size) { (_) -> UIImage in
                    return image
                }
                dictionary[MPMediaItemPropertyArtwork] = artwork
            }
            self.nowPlayingInfo = dictionary
        }
    }
}
