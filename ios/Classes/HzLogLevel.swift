//
//  HzLogLevel.swift
//  hz_log_plugin
//
//  Created by itbox_djx on 2024/10/15.
//

import Foundation

public enum HzLogLevel: Int {
    case all = 0
    case trace = 1000
    case debug = 2000
    case info = 3000
    case warning = 4000
    case error = 5000
    case fatal = 6000

    // 日志级别对应的字符串表示
    public func levelString() -> String {
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
    
    public func levelShortString() -> String {
        switch self {
        case .all:
            return "ALL"
        case .trace:
            return "T"
        case .debug:
            return "D"
        case .info:
            return "I"
        case .warning:
            return "W"
        case .error:
            return "E"
        case .fatal:
            return "F"
        }
    }

    // 日志级别对应的描述和表情
    public func emoji() -> String {
        switch self {
        case .all:
            return "📝"
        case .trace:
            return "🔍"
        case .debug:
            return "🔧"
        case .info:
            return "ℹ️"
        case .warning:
            return "⚠️"
        case .error:
            return "❌"
        case .fatal:
            return "💀"
        }
    }
}
