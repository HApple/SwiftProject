//
//  JNAPI.swift
//  SwiftProject
//
//  Created by Miles on 2021/8/9.
//

import Foundation
import Moya

let JNAPIProvider = MoyaProvider<JNAPI>(plugins: [NetworkLoggerPlugin(), JNShowState(), JNPrintParameterAndJson()])

enum JNAPI {
    
    enum JNAPICategory: String {
        case all     = "all"
        case android = "Android"
        case ios     = "iOS"
        case welfare = "福利"
    }
    
    case data(type: JNAPICategory, size: Int, index: Int)
}

extension JNAPI: TargetType {
    
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL {
        return URL(string: "http://gank.io/api/data/")!
    }
    
    var path: String {
        switch self {
        case .data(let type, let size, let index):
            return "\(type.rawValue)/\(size)/\(index)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    /// The parameters to be encoded in the request.
    var parameters: [String: Any]? {
        return nil
    }
    
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    /// The type of HTTP task to be performed.
    var task: Task {
        return .requestPlain
    }
    
    /// Whether or not to perform Alamofire validation. Defaults to `false`.
    var validate: Bool {
        return false
    }
    
    /// 网络请求时是否显示loading...
    public var showStats: Bool {
        return true
    }
    
    /// 是否缓存结果数据
    public var cacheData: Bool {
        return true
    }

}
