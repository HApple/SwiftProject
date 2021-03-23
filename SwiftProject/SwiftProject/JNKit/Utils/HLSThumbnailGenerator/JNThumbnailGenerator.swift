//
//  JNThumbnailGenerator.swift
//  SwiftProject
//
//  Created by Miles on 2021/3/19.
//

import AVFoundation
import CoreImage
import UIKit

protocol JNDispatching: class {
    
    func async(_ block: @escaping () -> Void)
    func delay(_ seconds: TimeInterval, block: @escaping () -> Void)
}

extension DispatchQueue: JNDispatching {
    
    func async(_ block: @escaping () -> Void) {
        async(group: nil, execute: block)
    }
    func delay(_ seconds: TimeInterval, block: @escaping () -> Void) {
        asyncAfter(deadline: .now() + seconds, execute: block)
    }
}

public enum JNThumbnailGenerationError: Error {
    
    case seekInterrupted
    case copyPixelBufferFailed
    case imageCreationFailed
    
    public var localizeDescription: String {
        switch self {
        case .seekInterrupted:
            return "The remote player was unable to finish seeking to the requested time."
        case .copyPixelBufferFailed:
            return "The video output was unable to copy the pixel buffer at the requested time."
        case .imageCreationFailed:
            return "Counld not create an image from the supplied pixel buffer."
        }
    }
}

public protocol JNThumbnailGeneratorDelegate: class {
    
    func thumbnailGenerator(_ thumbnailGenerator: JNThumbnailGenerator, didGenerateThumbnail thumbnail: UIImage, atTime time: Double)
    func thumbnailGenerator(_ thumbnailGenerator: JNThumbnailGenerator, thumbnailGenerationDidFailWithError error: JNThumbnailGenerationError, atTime time: Double)
}


public final class JNThumbnailGenerator {
 
    private enum PlayerState {
        case loading
        case ready
    }
    
    public let asset: AVAsset
    public weak var delegate: JNThumbnailGeneratorDelegate?
    private(set) var times: [Double] = []
    
    var player: AVPlayer!
    private var observer: NSKeyValueObservation?
    private var videoOutput: AVPlayerItemVideoOutput?
    private var playerState: PlayerState = .loading {
        didSet {
            guard playerState == .ready, !times.isEmpty else { return }
            generateNextThumbnail()
        }
    }
    
    private let mainQueue: JNDispatching
    private let backgroundQueue: JNDispatching
    
    init(asset: AVAsset, mainQueue: JNDispatching, backgroundQueue: JNDispatching) {
        self.asset = asset
        self.mainQueue = mainQueue
        self.backgroundQueue = backgroundQueue
        setup()
    }
    
    public convenience init(asset: AVAsset) {
        let defaultBackgroundQueue = DispatchQueue(label: "com.jnthumbnail-generator.background")
        self.init(asset: asset, mainQueue: DispatchQueue.main, backgroundQueue: defaultBackgroundQueue)
    }
    
    // MARK: - Setup
    private func setup() {
        setupPlayer()
        setupObserver()
        setupVideoOutput()
    }
    
    
    private func setupPlayer() {
        let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: [])
        player = AVPlayer(playerItem: playerItem)
        player.rate = 0
    }
    
    private func setupObserver() {
        self.observer = player.currentItem?.observe(\.status, options: [.new, .old]) { [weak self]  (playerItem, change) in
            guard let self = self, playerItem.status == .readyToPlay, self.playerState == .loading else  { return }
            self.playerState = .ready
        }
    }
    
    private func setupVideoOutput() {
        let settings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        videoOutput = AVPlayerItemVideoOutput(pixelBufferAttributes: settings)
        guard let videoOutput = videoOutput else { return }
        player.currentItem?.add(videoOutput)
    }
    
    // MARK: - Thumbnail Generation
    
    public func generateThumbnails(atTimesInSeconds times:[Double]) {
        self.times += times
        guard playerState == .ready else { return }
        backgroundQueue.async (generateNextThumbnail)
    }
    
    private func generateNextThumbnail() {
        guard !times.isEmpty else { return }
        let time = times.removeFirst()
        generateThumbnail(atTimeInSeconds: time)
    }
    
    private func generateThumbnail(atTimeInSeconds time: Double) {
        let time = CMTime(seconds: time, preferredTimescale: 1)
        player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] (isFinished) in
            guard let self = self else { return }
            guard isFinished else {
                self.mainQueue.async {
                    self.delegate?.thumbnailGenerator(self, thumbnailGenerationDidFailWithError: .seekInterrupted, atTime: time.seconds)
                }
                self.generateNextThumbnail()
                return
            }
            self.backgroundQueue.delay(0.3) {
                self.didFinishSeeking(toTime: time)
            }
        }
    }
    
    private func didFinishSeeking(toTime time: CMTime) {
        guard let buffer = videoOutput?.copyPixelBuffer(forItemTime: time, itemTimeForDisplay: nil) else {
            mainQueue.async {
                self.delegate?.thumbnailGenerator(self, thumbnailGenerationDidFailWithError: .copyPixelBufferFailed, atTime: time.seconds)
            }
            generateNextThumbnail()
            return
        }
        
        processPixelBuffer(buffer, atTime: time.seconds)
    }
    
    private func processPixelBuffer(_ buffer: CVPixelBuffer, atTime time: Double) {
        defer {
            generateNextThumbnail()
        }
        let ciImage = CIImage(cvPixelBuffer: buffer)
        let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(buffer), height: CVPixelBufferGetHeight(buffer))
        guard let videoImage = CIContext().createCGImage(ciImage, from: imageRect) else {
            mainQueue.async {
                self.delegate?.thumbnailGenerator(self, thumbnailGenerationDidFailWithError: .imageCreationFailed, atTime: time)
            }
            return
        }
        let image = UIImage(cgImage: videoImage)
        mainQueue.async {
            self.delegate?.thumbnailGenerator(self, didGenerateThumbnail: image, atTime: time)
        }
    }
}
