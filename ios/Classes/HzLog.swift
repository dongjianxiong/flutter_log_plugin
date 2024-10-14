//
//  HzLog.swift
//  hz_log_plugin
//
//  Created by itbox_djx on 2024/10/14.
//

import Foundation

enum HzLevel: Int {
    case all = 0
    case trace = 1000
    case debug = 2000
    case info = 3000
    case warning = 4000
    case error = 5000
    case fatal = 6000
    
    func levelString() -> String {
        switch self {
        case .all:
            return "ALL"
        case .trace:
            return "TRACE"
        case .debug:
            return "DEBUG"
        case .info:
            return "INFO"
        case .warning:
            return "WARNING"
        case .error:
            return "ERROR"
        case .fatal:
            return "FATAL"
        }
    }
    
    // 日志级别对应的描述和表情
    func descriptionWithEmoji() -> String {
        switch self {
        case .all:
            return "📝 ALL"
        case .trace:
            return "🔍 TRACE"
        case .debug:
            return "🐞 DEBUG"
        case .info:
            return "ℹ️ INFO"
        case .warning:
            return "⚠️ WARNING"
        case .error:
            return "❌ ERROR"
        case .fatal:
            return "💀 FATAL"
        }
    }
}

class HzLog {

    // 默认日志级别
    static var currentLevel: HzLevel = .all

    // 设置当前日志级别
    static func setLogLevel(_ level: HzLevel) {
        currentLevel = level
    }

    // 判断日志是否需要打印
    static func shouldLog(level: HzLevel) -> Bool {
        return level.rawValue >= currentLevel.rawValue
    }

    // 记录日志
    static func log(tag: String, content: String, level: HzLevel, error: String? = nil, stack: String? = nil, report: Bool = false) {
        guard shouldLog(level: level) else {
            return // 不打印低于当前日志级别的日志
        }

        var message = "[\(tag)] [\(level.descriptionWithEmoji())] \(content)"
        if let error = error {
            message += "\nError: \(error)"
        }
        if let stack = stack {
            message += "\nStackTrace: \(stack)"
        }

        // 输出到控制台（可扩展为其他输出方式）
        print(message)

        // 如果需要上报（如飞书、远程服务器等）
        if report {
            reportLog(tag: tag, content: content, level: level, error: error, stack: stack)
        }
    }

    // 上报日志方法（实现上报逻辑，如飞书、远程日志服务器）
    static func reportLog(tag: String, content: String, level: HzLevel, error: String?, stack: String?) {
        // 模拟上报行为
        print("上报日志: [\(tag)] [\(level)] \(content)")
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
