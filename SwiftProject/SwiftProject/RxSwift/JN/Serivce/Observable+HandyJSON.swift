//
//  HandyJSON+Rx.swift
//  SwiftProject
//
//  Created by Miles on 2021/8/9.
//

import Foundation
import RxSwift
import HandyJSON
import Moya

enum APIError : Swift.Error {
    // 解析失败
    case ParseJSONError
    // 网络请求发生错误
    case RequestFailed
    // 接收到的返回没有data
    case NoResponse
    //服务器返回了一个错误代码
    case UnexpectedResult(resultCode: Int?, resultMsg: String?)
}

enum RequestStatus: Int {
    case requestSuccess = 200
    case requestError
}

/*
 根据项目实际修改
 */
fileprivate let RESULT_CODE = "code"
fileprivate let RESULT_MSG = "message"
fileprivate let RESULT_DATA = "data"

// MARK: - Json -> Model
public extension Response {
    
    //将Json解析为当个Model
    func mapObject<T: HandyJSON>(_ type: T.Type, designatedPath: String? = nil)  throws -> T {
        
        // 检查状态码
        guard ((200...209) ~= statusCode) else {
            throw APIError.RequestFailed
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]  else {
            throw APIError.NoResponse
        }
        
        // 服务器返回code
        if let code = json[RESULT_CODE] as? Int {
            if code == RequestStatus.requestSuccess.rawValue {
                let jsonString = String(data: data, encoding: .utf8)
                // 使用HandyJSON解析成对象
                let path = (designatedPath != nil) ? designatedPath! : "\(RESULT_DATA)"
                if let object = JSONDeserializer<T>.deserializeFrom(json: jsonString, designatedPath: path) {
                    return object
                }else {
                    throw APIError.ParseJSONError
                }
            } else {
                throw APIError.UnexpectedResult(resultCode: json[RESULT_CODE] as? Int , resultMsg: json[RESULT_MSG] as? String)
            }
        } else {
            throw APIError.ParseJSONError
        }
    }
    
    //将Json解析为多个Model，返回数组
    func mapArray<T: HandyJSON>(_ type: T.Type, designatedPath: String? = nil) throws -> [T] {

        // 检查状态码
        guard ((200...209) ~= statusCode) else {
            throw APIError.RequestFailed
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]  else {
            throw APIError.NoResponse
        }

        // 服务器返回code
//        if let code = json[RESULT_CODE] as? Int {
//            if code == RequestStatus.requestSuccess.rawValue {
//
                // get data
                let jsonString = String(data: data, encoding: .utf8)
                // 使用HandyJSON解析成对象
                let path = (designatedPath != nil) ? designatedPath! : "\(RESULT_DATA)"
                if let array = JSONDeserializer<T>.deserializeModelArrayFrom(json: jsonString, designatedPath: path) as? [T] {
                    return array
                }else {
                    throw APIError.ParseJSONError
                }
                
                
//            }
//            else {
//                throw APIError.UnexpectedResult(resultCode: json[RESULT_CODE] as? Int , resultMsg: json[RESULT_MSG] as? String)
//
//            }
//        }
//        else {
//            throw APIError.ParseJSONError
//        }
    }
}


// MARK: - Json -> Observable<Model>
public extension ObservableType where Element == Response {
    
    // 将Json解析为Observable<Model>
    func mapObject<T: HandyJSON>(_ type: T.Type, designatedPath: String? = nil) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject(T.self, designatedPath: designatedPath))
        }
    }
    
    // 将Json解析为Observable<[Model]>
    func mapArray<T: HandyJSON>(_ type: T.Type, designatedPath: String? = nil) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapArray(T.self, designatedPath: designatedPath))
        }
    }
}
