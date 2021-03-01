//
//  JNFileUtils.swift
//  SwiftProject
//
//  Created by hjn on 2021/2/23.
//

import Foundation

struct JNFileUtils {

    // Documents iCloud会同步 建议只存储重要数据 App更新不会被覆盖或清空
    static let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String
    
    // Caches 下载或产生的数据建议存在Caches  App更新不会被覆盖或清空
    static let cacheDirectoryPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! as String
    
    // Temp 不定期被系统清理 临时文件建议存在Temp
    static let tempDirectoryPath = NSTemporaryDirectory()
    
    
    //MARK:- 创建空文件
    private static func createFileAtPath(path: String) -> Bool {
        return FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
    }
    
    //MARK:- 创建文夹件
    static func createDirectoryIfNotExists(path:String) -> Result<Bool,Error> {
        
        if FileManager.default.fileExists(atPath: path) {
            return .success(true)
        }
        do {
            try FileManager.default.createDirectory(at: URL(fileURLWithPath: path), withIntermediateDirectories: true, attributes: nil)
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    //MARK:- 移动文件
    static func moveFile(fromPath:String,
                         toPath:String) -> Result<URL,Error> {
        
        let url: URL = URL(fileURLWithPath: fromPath)
        let newUrl: URL = URL(fileURLWithPath: toPath)
        let result = self.createDirectoryIfNotExists(path: toPath)
        switch result {
        case .success(_):
            break
        case .failure(let error):
            return .failure(error)
        }
        do {
            try FileManager.default.moveItem(at: url, to: newUrl)
            return .success(newUrl)
        } catch {
            return .failure(error)
        }
        
    }
    
    //MARK:- 清除对应文件
    static func  clearData(path: String) {
        guard let enumrator = FileManager.default.enumerator(atPath: path) else {
            return
        }
        for fileName in enumrator {
            if let name = fileName as? String {
                let filePath = path + "/" + name
                if let url = URL(string: filePath) {
                    try? FileManager.default.removeItem(at: url)
                }
            }
        }
    }

    
    //MARK: - 枚举文件目录
    public static func enumeratorCatalog(in path:String, completion: @escaping (Array<String>) -> Void) {
       
        var files: [String] = [String]()
        
        guard let enumerator = FileManager.default.enumerator(atPath: path) else {
            completion(files)
            return
        }
        
        
        for fileName in enumerator {
            if let name = fileName as? String {
                let filePath = path  + "/" + name
                files.append(filePath)
            }
        }
        
        completion(files)
    }
}


// File Size
extension JNFileUtils {
    
    
    //MARK:- 计算文件夹大小
    static func calculateSize(path: String) -> Float {

        var size: Float = 0

        if let attr = try? FileManager.default.attributesOfItem(atPath: path) {
            size += attr[.size] as! Float
        }
        
        return size
    }
    
    //MARK:- 将文件大小转成G单位或者M单位或者B单位
    static func getFileSizeString(size: Double) -> String {
    
        // 大于1G 则转化成G单位的字符串
        if size >= 1024 * 1024 * 1024{
            return String(format: "%1.2fG", size / 1024 / 1024 / 1024)
        }
        // 大于1M 则转化成M单位的字符串
        else if size >= 1024 * 1024 && size < 1024 * 1024 * 1024 {
            return String(format: "%1.2fM", size / 1024 / 1024)
        }
        // 不到1M 但是超过了1KB 则转化成KB单位
        else if size >= 1024 && size < 1024 * 1024 {
            return String(format: "%1.2fK", size / 1024)
        }
        //剩下的都是小于1K的，则转化成B单位
        else {
            return String(format: "%1.2fB", size)
        }
    }
    
    //MARK:- 将文件大小转化成不带单位的数字
    static func getFileSizeNumber(size: String) -> Float {
        let sizeSTR = size as NSString
        let indexG = sizeSTR.range(of: "G").location
        let indexM = sizeSTR.range(of: "M").location
        let indexK = sizeSTR.range(of: "K").location
        let indexB = sizeSTR.range(of: "B").location
        
        //是M单位的字符串
        if indexG < 1000 {
            return sizeSTR.substring(to: indexG).float ?? 0 * 1024 * 1024 * 1024
        }
        //是M单位的字符串
        else if indexM < 1000 {
            return sizeSTR.substring(to: indexM).float ?? 0 * 1024 * 1024
        }
        //是K单位的字符串
        else if indexK < 1000 {
            return sizeSTR.substring(to: indexK).float ?? 0 * 1024
        }
        //是B单位的字符串
        else if indexB < 1000 {
            return sizeSTR.substring(to: indexB).float ?? 0
        }
        //没有任何单位的数字字符串
        else {
            return size.float ?? 0
        }
    }
}


enum JNFileStatus {
    case isFile, isDir, isNotExist
}

extension String {
    var fileStatus: JNFileStatus {
        get {
            var filestatus: JNFileStatus = .isNotExist
            var isDir: ObjCBool = false
            if FileManager.default.fileExists(atPath: self, isDirectory: &isDir) {
                if isDir.boolValue {
                    // file exists and is a directory
                    filestatus = .isDir
                }else {
                    // file exists and is a file
                    filestatus = .isFile
                }
            }else {
                // file does not exist
                filestatus = .isNotExist
            }
            return filestatus
        }
    }
}
