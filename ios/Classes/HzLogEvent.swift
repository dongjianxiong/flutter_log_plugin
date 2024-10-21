//
//  HzLogEvent.swift
//  hz_log_plugin
//
//  Created by itbox_djx on 2024/10/17.
//

import Foundation

// HzLogEvent 类
public class HzLogEvent {
    public var level: HzLogLevel       // 日志级别
    public var message: String         // 日志内容
    public var tag: String?            // 日志标签
    public var error: String?          // 错误信息，可选
    public var stackTrace: String?     // 堆栈信息，可选
    public var date: Date              // 日志时间
    public var threadID: String        // 线程 ID
    public var report: Bool            // 是否需要上报
    
    // 初始化方法
    init(level: HzLogLevel,
         message: String,
         tag: String?,
         error: String? = nil,
         stackTrace: String? = nil,
         date: Date = Date(),
         threadID: String,
         report: Bool = false) {
        
        self.level = level
        self.message = message
        self.tag = tag
        self.error = error
        self.stackTrace = stackTrace
        self.date = date
        self.threadID = threadID
        self.report = report
    }
    
    public var tagFormat: String {
        if let tag = tag {
            return "\(HzLogConfig.prefix)|\(tag)"
        }
        return HzLogConfig.prefix
    }
    
    public var baseInfo: String {
        return "[\(level.levelShortString())]-[\(tagFormat)]-[\(threadID)]"
    }
    
    public var consoleLog: String {
        var logMsg = "[\(date.timeString())]-\(baseInfo) \(message)"
        if let error = error, !error.isEmpty {
            logMsg += "\nError: \(error)"
        }
        if let stackTrace = stackTrace, !stackTrace.isEmpty {
            logMsg += "\nStackTrace: \(stackTrace)"
        }
        return logMsg
    }
    
    public var reportLog: String {
        
        var logMsg = "[\(date.toFormatString())]-\(baseInfo) \(message)"
        
        let extraString = HzLogConfig.extra.map { "\($0):\($1)" }.joined(separator: "|")
        logMsg += "\n\(extraString)"

        if let error = error, !error.isEmpty {
            logMsg += "\nError: \(error)"
        }
        if let stackTrace = stackTrace, !stackTrace.isEmpty {
            logMsg += "\nStackTrace: \(stackTrace)"
        }
        return logMsg
    }
    
    // 日志事件的描述信息
    func description() -> String {
        let errorMessage = error != nil ? "Error: \(error!)" : "No Error"
        let stackMessage = stackTrace != nil ? "Stack Trace: \(stackTrace!)" : "No Stack Trace"
        return """
        [\(date)] [\(level.rawValue)] [\(tag ?? "No Tag")] [Thread: \(threadID)] [Report: \(report)]
        Message: \(message)
        \(errorMessage)
        \(stackMessage)
        """
    }

    // 实现 copy 方法
    // 实现 copy 方法
    func copy(level: HzLogLevel? = nil,
              message: String? = nil,
              tag: String? = nil,
              error: String? = nil,
              stackTrace: String? = nil,
              date: Date? = nil,
              threadID: String? = nil,
              report: Bool? = nil) -> HzLogEvent {
        
        return HzLogEvent(
            level: level ?? self.level,
            message: message ?? self.message,
            tag: tag ?? self.tag,
            error: error ?? self.error,
            stackTrace: stackTrace ?? self.stackTrace,
            date: date ?? self.date,        // 使用相同的 date 对象（深拷贝不必要）
            threadID: threadID ?? self.threadID,
            report: report ?? self.report
        )
    }

}



extension Date {
    /// 将字符串转化为 Date 对象，格式为 `yyyy-MM-dd HH:mm:ss.SSS`
    static func dateFromFormatString(dateString: String?) -> Date {
        
        var date: Date?
        
        if let formatString = dateString {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            formatter.locale = Locale(identifier: "zh_CN") // 设置为固定区域，确保解析正确
            date = formatter.date(from: formatString )
        }

        return date ?? Date()
    }

    /// 将 Date 对象格式化为 `yyyy-MM-dd HH:mm:ss.SSS` 字符串
    func toFormatString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.locale = Locale(identifier: "zh_CN") // 确保格式的一致性
        
        return formatter.string(from: self)
    }

    /// 只获取时间部分的字符串，格式为 `HH:mm:ss.SSS`
    func timeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: self)
    }
}
