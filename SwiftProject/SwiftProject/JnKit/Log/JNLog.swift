//
//  JNLog.swift
//  SwiftProject
//
//  Created by hjn on 2021/1/18.
//

import Foundation

#if DEBUG
private let shouldLog: Bool = true
#else
private let shouldLog: Bool = false
#endif

@inlinable
public func JNLogError(_ message: @autoclosure () -> String,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line) {
    
    JNLog.log(message(), type: .error, file: file, function: function, line: line)
}

@inlinable
public func JNLogWarn(_ message: @autoclosure () -> String,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line)
{
    JNLog.log(message(), type: .warning, file: file, function: function, line: line)
}

@inlinable
public func JNLogInfo(_ message: @autoclosure () -> String,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line)
{
    JNLog.log(message(), type: .info, file: file, function: function, line: line)
}

@inlinable
public func JNLogDebug(_ message: @autoclosure () -> String,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line)
{
    JNLog.log(message(), type: .debug, file: file, function: function, line: line)
}

@inlinable
public func JNLogVerbose(_ message: @autoclosure () -> String,
                         file: StaticString = #file,
                         function: StaticString = #function,
                         line: UInt = #line)
{
    JNLog.log(message(), type: .verbose, file: file, function: function, line: line)
}


public class JNLog {
    public enum logType {
        case error
        case warning
        case info
        case debug
        case verbose
    }
    
    public static func log(_ message: @autoclosure () -> String,
                          type: logType,
                          file: StaticString,
                          function: StaticString,
                          line: UInt) {
        guard shouldLog else { return }
        let fileName = String(describing: file).lastPathComponent
        let formattedMsg = "file:\(fileName) func:\(function) line:\(line) msg:--" + message()
        JNLogFormatter.shared.log(messge: formattedMsg, type: type)
        
    }
}


private extension String {
    var fileURL: URL {
        return URL(fileURLWithPath: self)
    }
    
    var pathExtension: String {
        return fileURL.pathExtension
    }
    
    var lastPathComponent: String {
        return fileURL.lastPathComponent
    }
}

class JNLogFormatter: NSObject {
    static let shared = JNLogFormatter()
    let dateFormatter: DateFormatter
    
    override init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
        super.init()
    }
    
    func log(messge logMessage: String, type: JNLog.logType) {
        var logLevelStr: String
        switch type {
        case .error:
            logLevelStr = "‼️ Error"
        case .warning:
            logLevelStr = "⚠️ Warning"
        case .info:
            logLevelStr = "ℹ️ Info"
        case .debug:
            logLevelStr = "✅ Debug"
        case .verbose:
            logLevelStr = "⚪ Verbose"
        }

        let dateStr = dateFormatter.string(from: Date())
        let finalMessage = logLevelStr + " | " + dateStr + " " + logMessage
        print(finalMessage)
    }
}
