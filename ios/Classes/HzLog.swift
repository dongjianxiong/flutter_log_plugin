//
//  HzLog.swift
//  hz_log_plugin
//
//  Created by itbox_djx on 2024/10/14.
//

import Foundation

public class HzLog {

    public static func log(
        message: String,
        tag: String? = nil,
        level: HzLogLevel,
        error: String? = nil,
        stackLimit: Int = 0,
        report: Bool = false
    ) {
        // 获取调用堆栈符号
        var stackTrace : String?
        if stackLimit > 0 {
            let stackSymbols = Thread.callStackSymbols
            stackTrace = logLimitedStackTrace(stackSymbols: stackSymbols, level: level, limit: stackLimit)
        }
        
        // 记录日志，限制堆栈跟踪的数量
        HzLogManager.log(
            tag: tag,
            message: message,
            level: level,
            date: Date(),
            error: error,
            stack: stackTrace,
            report: report
        )
    }

    
    public static func logLimitedStackTrace(stackSymbols:[String], level: HzLogLevel, limit: Int = 10) -> String {
        let stackSymbols = Thread.callStackSymbols
        let filteredStack = stackSymbols.dropFirst(1).prefix(limit) // 跳过第一行，限制为前10行
        var stack: String = ""
        for symbol in filteredStack {
//            print(symbol)
            stack.append("\n#\(symbol)")
        }
        return stack
    }
    
    // 快捷日志方法
    public static func t(message: String, tag: String? = nil, error: String? = nil, stackLimit: Int = 0, report: Bool = false) {
        log(message: message, tag: tag, level: .trace, error: error, stackLimit: stackLimit, report: report)
    }

    public static func d(message: String, tag: String? = nil, error: String? = nil, stackLimit: Int = 0, report: Bool = false) {
        log(message: message, tag: tag, level: .debug, error: error, stackLimit: stackLimit, report: report)
    }

    public static func i(message: String, tag: String? = nil, error: String? = nil, stackLimit: Int = 0, report: Bool = true) {
        log(message: message, tag: tag, level: .info, error: error, stackLimit: stackLimit, report: report)
    }

    public static func w(message: String, tag: String? = nil, error: String? = nil, stackLimit: Int = 0, report: Bool = true) {
        log(message: message, tag: tag, level: .warning, error: error, stackLimit: stackLimit, report: report)
    }

    public static func e(message: String, tag: String? = nil, error: String? = nil, stackLimit: Int = 5, report: Bool = true) {
        log(message: message, tag: tag, level: .error, error: error, stackLimit: stackLimit, report: report)
    }

    public static func f(message: String, tag: String? = nil, error: String? = nil, stackLimit: Int = 5, report: Bool = true) {
        log(message: message, tag: tag, level: .fatal, error: error, stackLimit: stackLimit, report: report)
    }
}
