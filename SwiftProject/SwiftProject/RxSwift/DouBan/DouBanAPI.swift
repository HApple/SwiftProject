//
//  DouBanAPI.swift
//  SwiftProject
//
//  Created by Miles on 2021/8/9.
//

import Foundation
import Moya

let DouBanProvider = MoyaProvider<DouBanAPI>()

public enum DouBanAPI {
    case channels
    case playlist(String)
}

extension DouBanAPI: TargetType {
    
    public var baseURL: URL {
        switch self {
        case .channels:
            return URL(string: "https://www.douban.com")!
        case .playlist(_):
            return URL(string: "https://douban.fm")!
        }
    }
    
    public var path: String {
        switch self {
        case .channels:
            return "/j/app/radio/channels"
        case .playlist(_):
            return "/j/mine/playlist"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .channels,
             .playlist(_):
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .playlist(let channel):
            var params: [String: Any] = [:]
            params["channel"] = channel
            params["type"] = "n"
            params["from"] = "mainsite"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    //是否执行Alamofire验证
    public var validationType: ValidationType {
        return .none
    }
    
    public var sampleData: Data {
        return "{}".data(using: .utf8)!
    }
    
    //请求头
    public var headers: [String : String]? {
        return nil
    }
}
