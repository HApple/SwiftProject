//
//  JNPermissionAuth.swift
//  SwiftProject
//
//  Created by hjn on 2021/2/20.
//

import Foundation
import Photos
import AVFoundation
import UIKit

struct JNPermissionAuth {
    
    enum Status {
        case notDetermined
        case restricted
        case denied
        case authorized
    }
    
    struct Photos {
        static var status: Status {
            switch PHPhotoLibrary.authorizationStatus() {
            case .notDetermined:
                return .notDetermined
            case .restricted:
                return .restricted
            case .denied:
                return .denied
            case .authorized:
                return .authorized
            case .limited:
                return .authorized
            @unknown default:
                return .denied
            }
        }
        
        static func request(_ completion: @escaping () -> Void) {
            PHPhotoLibrary.requestAuthorization { status in
                completion()
            }
        }
    }
    
    struct Camera {
        static var status: Status {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                return .notDetermined
            case .restricted:
                return .restricted
            case .denied:
                return .denied
            case .authorized:
                return .authorized
            @unknown default:
                return .denied
            }
        }
        
        static func request(_ completion: @escaping () -> Void) {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion()
            }
        }
    }
    
    struct Micro {
        static var stauts: Status {
            switch AVCaptureDevice.authorizationStatus(for: .audio) {
            case .notDetermined:
                return .notDetermined
            case .restricted:
                return .restricted
            case .denied:
                return .denied
            case .authorized:
                return .authorized
            @unknown default:
                return .denied
            }
        }
        
        static func request(_ completion: @escaping () -> Void) {
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                completion()
            }
        }
    }
    
    struct Notice {
        static var status: Status {
            if UIApplication.shared?.isRegisteredForRemoteNotifications == true {
                return .authorized
            }
            else {
                return .denied
            }
        }
    }
    
    static func openSetting() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared?.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
}


