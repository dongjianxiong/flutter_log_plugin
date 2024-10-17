//
//  HzLog.swift
//  hz_log_plugin
//
//  Created by itbox_djx on 2024/10/14.
//

import Foundation

public class HzLog {

    public static func log(
        tag: String? = nil,
        content: String,
        level: HzLogLevel,
        error: String? = nil,
        stackLimit: Int = 0,
        report: Bool = false
    ) {
        // 获取调用堆栈符号
        let stackSymbols = Thread.callStackSymbols
        // 记录日志，限制堆栈跟踪的数量
        HzLogManager.log(
            tag: tag,
            content: content,
            level: level,
            date: Date(),
            error: error,
            stack: logLimitedStackTrace(stackSymbols: stackSymbols, level: level, limit: stackLimit),
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
    public static func t(tag: String, content: String, error: String? = nil, stackLimit: Int = 0, report: Bool = false) {
        log(tag: tag, content: content, level: .trace, error: error, stackLimit: stackLimit, report: report)
    }

    public static func d(tag: String, content: String, error: String? = nil, stackLimit: Int = 0, report: Bool = false) {
        log(tag: tag, content: content, level: .debug, error: error, stackLimit: stackLimit, report: report)
    }

    public static func i(tag: String, content: String, error: String? = nil, stackLimit: Int = 0, report: Bool = false) {
        log(tag: tag, content: content, level: .info, error: error, stackLimit: stackLimit, report: report)
    }

    public static func w(tag: String, content: String, error: String? = nil, stackLimit: Int = 0, report: Bool = false) {
        log(tag: tag, content: content, level: .warning, error: error, stackLimit: stackLimit, report: report)
    }

    public static func e(tag: String, content: String, error: String? = nil, stackLimit: Int = 10, report: Bool = false) {
        log(tag: tag, content: content, level: .error, error: error, stackLimit: stackLimit, report: report)
    }

    public static func f(tag: String, content: String, error: String? = nil, stackLimit: Int = 10, report: Bool = false) {
        log(tag: tag, content: content, level: .fatal, error: error, stackLimit: stackLimit, report: report)
    }
}
