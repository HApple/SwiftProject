//
//  UIApplication+Jn.swift
//  SwiftProject
//
//  Created by hjn on 2020/12/29.
//

import UIKit

public extension UIApplication {
    
    static let isAppExtension: Bool = {
        var isAppExtension: Bool = false
        DispatchQueue.once {
            let bundleUrl: URL = Bundle.main.bundleURL
            let bundlePathExtension: String = bundleUrl.pathExtension
            isAppExtension = bundlePathExtension == "appex"
        }
        return isAppExtension
    }()
    
    static let shared: UIApplication? = {
        if isAppExtension {
            return nil
        }
        let selector = NSSelectorFromString("sharedApplication")
        guard UIApplication.responds(to: selector) else { return nil }
        return UIApplication.perform(selector).takeUnretainedValue() as? UIApplication
    }()
    
    func keyWindow() -> UIWindow? {
        guard let currentApplication = UIApplication.shared else { return nil }
        var targetWindow = currentApplication.keyWindow
        if #available(iOS 13.0, tvOS 13.0, *) {
            let scenes = currentApplication.connectedScenes.filter({ $0.activationState == .foregroundActive })
            var findNormalWindow: Bool = false
            for scene in scenes where !findNormalWindow {
                if let windowScene = scene as? UIWindowScene {
                    for keyWindow in windowScene.windows.filter({ $0.isKeyWindow }) where !findNormalWindow {
                        if keyWindow.windowLevel != .normal {
                            let windows = currentApplication.windows
                            for temp in windows where (!findNormalWindow && temp.windowLevel == .normal) {
                                targetWindow = temp
                                findNormalWindow = true
                                break
                            }
                        } else {
                            targetWindow = keyWindow
                            findNormalWindow = true
                            break
                        }
                    }
                }
            }
        } else {
            if let keyWindow = targetWindow, keyWindow.windowLevel != .normal {
                let windows = currentApplication.windows
                for temp in windows {
                    if temp.windowLevel == .normal {
                        targetWindow = temp
                        break
                    }
                }
            }
        }
        return targetWindow
    }
}


public extension UIApplication {
    /// SwifterSwift: Application running environment.
    ///
    /// - debug: Application is running in debug mode.
    /// - testFlight: Application is installed from Test Flight.
    /// - appStore: Application is installed from the App Store.
    enum Environment {
        /// SwifterSwift: Application is running in debug mode.
        case debug
        /// SwifterSwift: Application is installed from Test Flight.
        case testFlight
        /// SwifterSwift: Application is installed from the App Store.
        case appStore
    }

    /// SwifterSwift: Current inferred app environment.
    var inferredEnvironment: Environment {
        #if DEBUG
        return .debug

        #elseif targetEnvironment(simulator)
        return .debug

        #else
        if Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil {
            return .testFlight
        }

        guard let appStoreReceiptUrl = Bundle.main.appStoreReceiptURL else {
            return .debug
        }

        if appStoreReceiptUrl.lastPathComponent.lowercased() == "sandboxreceipt" {
            return .testFlight
        }

        if appStoreReceiptUrl.path.lowercased().contains("simulator") {
            return .debug
        }

        return .appStore
        #endif
    }

    /// SwifterSwift: Application name (if applicable).
    var displayName: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }

    /// SwifterSwift: App current build number (if applicable).
    var buildNumber: String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }

    /// SwifterSwift: App's current version number (if applicable).
    var version: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
