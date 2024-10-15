//
//  HzLog.swift
//  hz_log_plugin
//
//  Created by itbox_djx on 2024/10/14.
//

import Foundation

class HzLog {

    // 默认日志级别
    static var _currentLevel: HzLogLevel = .all

    // 默认前缀
    static var _prefix: String = "HzLog"
    
    // 设置当前日志级别
    static func setLogLevel(_ level: HzLogLevel) {
        _currentLevel = level
    }
    
    static func setPrefix(_ prefix: String) {
        _prefix = prefix
    }

    // 判断日志是否需要打印
    static func shouldLog(level: HzLogLevel) -> Bool {
        return level.rawValue >= _currentLevel.rawValue
    }

    static func log(tag: String? = nil, content: String, level: HzLogLevel, error: String? = nil, stack: String? = nil, report: Bool = false) {
        guard shouldLog(level: level) else {
            return // 不打印低于当前日志级别的日志
        }

        // 构建日志信息
        let logMessage = buildLogMessage(tag: tag ?? _prefix, level: level)

        // 打印开始行、日志内容和结束行
        printFormattedLog(logMessage: logMessage, content: content, level: level, error: error, stack: stack)

        // 如果需要上报
        if report {
            reportLog(tag: tag ?? _prefix, content: content, level: level, error: error, stack: stack)
        }
    }

    private static func buildLogMessage(tag: String, level: HzLogLevel) -> String {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
        let processID = ProcessInfo.processInfo.processIdentifier
        let threadID = Thread.isMainThread ? "Main" : "Background"
        return "\(timestamp) [\(level.rawValue)] [\(processID): \(threadID)] - \(tag)"
    }

    private static func printFormattedLog(logMessage: String, content: String, level: HzLogLevel, error: String?, stack: String?) {
        let startLine = "┌-------------------------\(level.emoji())\(level.levelString()) START \(level.emoji())---------------------------------"
        let endLine =   "└-------------------------\(level.emoji())\(level.levelString())  END  \(level.emoji())---------------------------------"

        print(startLine)
//        print(logMessage)
        var fullMessage = "[\(logMessage)] \(content)"
        
        if let error = error {
            fullMessage += "\nError: \(error)"
        }
        if let stack = stack {
            fullMessage += "\nStackTrace: \(stack)"
        }
        print(fullMessage)
        print(endLine)
    }


    // 上报日志方法（实现上报逻辑，如飞书、远程日志服务器）
    static func reportLog(tag: String?, content: String, level: HzLogLevel, error: String?, stack: String?) {
        // 模拟上报行为
        print("上报日志: [\(tag ?? _prefix)] [\(level)] \(content)")
    }

    // 设置额外信息
    static func setExtra(key: String, value: String?) {
        // 处理附加信息
    }

    // 设置回调输出开关
    static func setCallbackOutput(open: Bool) {
        // 开关回调输出的实现
    }

    // 设置文件输出开关
    static func setFileOutput(open: Bool) {
        // 文件输出的实现
    }

    // 打开 Logcat
    static func openLogcat(open: Bool) {
        // Logcat 输出的实现
    }

    // 设置飞书输出
    static func setFeishuOutput(hookId: String, open: Bool, projectId: String, logStoreId: String) {
        // 飞书输出的实现
    }

    // 快捷日志方法
    static func t(tag: String, content: String, error: String? = nil, stack: String? = nil, report: Bool = false) {
        log(tag: tag, content: content, level: .trace, error: error, stack: stack, report: report)
    }

    static func d(tag: String, content: String, error: String? = nil, stack: String? = nil, report: Bool = false) {
        log(tag: tag, content: content, level: .debug, error: error, stack: stack, report: report)
    }

    static func i(tag: String, content: String, error: String? = nil, stack: String? = nil, report: Bool = false) {
        log(tag: tag, content: content, level: .info, error: error, stack: stack, report: report)
    }

    static func w(tag: String, content: String, error: String? = nil, stack: String? = nil, report: Bool = false) {
        log(tag: tag, content: content, level: .warning, error: error, stack: stack, report: report)
    }

    static func e(tag: String, content: String, error: String? = nil, stack: String? = nil, report: Bool = false) {
        log(tag: tag, content: content, level: .error, error: error, stack: stack, report: report)
    }

    static func f(tag: String, content: String, error: String? = nil, stack: String? = nil, report: Bool = false) {
        log(tag: tag, content: content, level: .fatal, error: error, stack: stack, report: report)
    }
}
