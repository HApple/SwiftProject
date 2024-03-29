//
//  JNMoyaPlugin.swift
//  SwiftProject
//
//  Created by Miles on 2021/8/10.
//

import Foundation
import Moya
import SwiftyJSON

/// Moya插件: 网络请求时显示loading...
internal final class JNShowState: PluginType {
    
    /// 在发送之前调用来修改请求
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.timeoutInterval = 15 //超时时间
        return request
    }
    
    /// 在通过网络发送请求(或存根)之前立即调用
    func willSend(_ request: RequestType, target: TargetType) {
        
        guard let target = target as? JNAPI
            else { return }
        /// 判断是否需要显示
        DispatchQueue.main.async {
            target.showStats ? JNProgressHUD.showLoading("加载中...") : ()
        }
    }
    
    /// 在收到响应之后调用，但是在MoyaProvider调用它的完成处理程序之前调用
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        DispatchQueue.main.async {
            JNProgressHUD.dismissHUD()
        }
    }
    
    /// 调用以在完成之前修改结果
//    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {}
}

/// Moya插件: 控制台打印请求的参数和服务器返回的json数据
internal final class JNPrintParameterAndJson: PluginType {
    
    func willSend(_ request: RequestType, target: TargetType) {
        #if DEBUG
        print("""
            
            
            请求参数=====> \(target)
            
            """)
        #endif
    }
    

    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
    
        #if DEBUG
        switch result {
        case .success(let response):
            do {
                let jsonObiect = try response.mapJSON()
                print("""
                    
                    请求成功=====> \(target)
                    \(JSON(jsonObiect))
                    
                    
                    """)
            } catch {
                print("""
                    
                
                
                请求成功=====> \(target)
                无返回数据
                
                """)
            }
            break
        default:
            print("""
            
            
            
            请求失败=====> \(target)
            
            
            """)
            break
        }
        #endif
    }
    
}
