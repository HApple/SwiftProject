//
//  JNProgressHUD.swift
//  SwiftProject
//
//  Created by Miles on 2021/8/9.
//

import Foundation
import SVProgressHUD

enum JNHUDType {
    case success
    case error
    case loading
    case info
    case progress
}

class JNProgressHUD: NSObject {
    
    class func initJNProgressHUD() {
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 14))
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
    }
    
    class func showSuccess(_ status: String) {
        self.showJNProgressHUD(type: .success, status: status)
    }
    class func showError(_ status: String) {
        self.showJNProgressHUD(type: .error, status: status)
    }
    class func showLoading(_ status: String) {
        self.showJNProgressHUD(type: .loading, status: status)
    }
    class func showInfo(_ status: String) {
        self.showJNProgressHUD(type: .info, status: status)
    }
    class func showProgress(_ status: String, _ progress: CGFloat) {
        self.showJNProgressHUD(type: .success, status: status, progress: progress)
    }
    class func dismissHUD(_ delay: TimeInterval = 0) {
        SVProgressHUD.dismiss(withDelay: delay)
    }
}

extension JNProgressHUD {
    class func showJNProgressHUD(type: JNHUDType, status: String, progress: CGFloat = 0) {
        switch type {
        case .success:
            SVProgressHUD.showSuccess(withStatus: status)
        case .error:
            SVProgressHUD.showError(withStatus: status)
        case .loading:
            SVProgressHUD.show(withStatus: status)
        case .info:
            SVProgressHUD.showInfo(withStatus: status)
        case .progress:
            SVProgressHUD.showProgress(Float(progress), status: status)
        }
    }
}
