//
//  HzLogManager.swift
//  hz_log_plugin
//
//  Created by itbox_djx on 2024/10/15.
//

import Foundation

public class HzLogManager {

    public static let shared = HzLogManager()
    
    private init() {
//        fileOutputs.append(HzFileLogOutput.shared)
        fileOutputs.append(HzLogFileOutput.shared)
//        fileOutputs.append(HzLogFileJsonOutput.shared)
        consoleOutputs.append(HzConsoleLogPrinter.shared)
//        serverOutputs.append(HzServerLogOutput(serverURL: URL(fileURLWithPath: "https://www.baidu.com")))
    }
    
    private var serverOutputs = Array<HzLogOutput>()
    private var fileOutputs = Array<HzLogOutput>()
    private var consoleOutputs = Array<HzLogOutput>()
    
    public static func addServerOutput(_ output: HzLogOutput) {
        shared.serverOutputs.append(output)
    }
    
    public  static func removeServerOutput(_ output: HzLogOutput) {
         shared.serverOutputs.removeAll { $0 === output }
     }
    
    public static func removeAllServerOutput() {
         shared.serverOutputs.removeAll()
     }
    
    
    public static func addFileOutput(_ output: HzLogOutput) {
        shared.serverOutputs.append(output)
    }
    
    public static func removeFileOutput(_ output: HzLogOutput) {
         shared.serverOutputs.removeAll { $0 === output }
     }
    
    public static func removeAllFileOutput() {
         shared.serverOutputs.removeAll()
     }
    
    
    public static func addConsoleOutput(_ output: HzLogOutput) {
        shared.serverOutputs.append(output)
    }
    
    public static func removeConsoleOutput(_ output: HzLogOutput) {
         // 使用引用比较来删除元素
         shared.serverOutputs.removeAll { $0 === output }
     }
    
    public static func removeAllConsoleOutput() {
         // 使用引用比较来删除元素
         shared.serverOutputs.removeAll()
     }
    
    
    // 设置回调输出开关
    public static func enableServerLog(enable: Bool) {
        // 开关回调输出的实现
        HzLogConfig.serverEnabled = enable
    }

    // 设置文件输出开关
    public static func enableFileLog(enable: Bool) {
        // 文件输出的实现
        HzLogConfig.fileEnabled = enable
    }

    // 设置飞书输出
    public static func enableFeishuNotify(hookId: String, enable: Bool, projectId: String, logStoreId: String) {
        // 飞书输出的实现
        HzLogConfig.feishuNotifyEnabled = enable
    }

    // 设置其他信息
    public static func setExtra(extra: Any?) {
        if let extra = extra as? Dictionary<String, Any> {
            HzLogConfig.extra.merge(extra) { (_, new) in new }
        }
    }
    
    // 设置附加信息
    public static func setExtra(key: String, value: Any) {
        HzLogConfig.extra[key] = value
    }
    
    // 设置当前日志级别
    public static func setLogLevel(_ level: HzLogLevel) {
        HzLogConfig.logLevel = level
    }
    
    // 设置前缀
    public static func setPrefix(_ prefix: String) {
        HzLogConfig.prefix = prefix
    }
    
    // 设置最大字符个数，最大值为8000
    public static func setMaxServerLogSize(_ maxSize: Int) {
        if (maxSize > 0 && maxSize <= 8000) {
            HzLogConfig.maxServerLogSize = maxSize
        } else {
            HzLog.e(message: "最大上传日志字符长度超过0~8000的区间", tag: "HzLogManager", stackLimit: 2)
        }
    }
    
    // 设置最大合并日志个数
    public static func setMaxServerLogCount(_ logCount: Int) {
        HzLogConfig.maxServerLogCount = logCount
    }
    
    // 设置最大日志上传间隔
    public static func setMaxServerLogInterval(_ timeInterval: Int) {
        HzLogConfig.maxServerLogInterval = TimeInterval(timeInterval)
    }
    
    // 判断日志是否需要打印
    public static func shouldLog(level: HzLogLevel) -> Bool {
        return level.rawValue >= HzLogConfig.logLevel.rawValue
    }
    
    public static func log(tag: String? = nil,
                           message: String,
                           level: HzLogLevel,
                           date: Date,
                           error: String? = nil,
                           stack: String? = nil,
                           print: Bool = true,
                           report: Bool = false) {
        guard shouldLog(level: level) else {
            return // 不打印低于当前日志级别的日志
        }

        let threadId = Thread.isMainThread ? "main-thread": String(cString: __dispatch_queue_get_label(nil), encoding: .utf8) ?? Thread.current.description
        // 构建日志信息
        let logEvent = HzLogEvent(level: level, 
                                  message: message,
                                  tag: tag,
                                  error: error,
                                  stackTrace: stack,
                                  date: date,
                                  threadID: threadId,
                                  report: report)
        // 日志级别大于或等于info才会上传
        if report && HzLogConfig.serverEnabled && level.rawValue >= HzLogLevel.info.rawValue {
            shared.serverOutputs.forEach { output in
                output.log(logEvent)
            }
        }
        
        if HzLogConfig.fileEnabled {
            shared.fileOutputs.forEach { output in
                output.log(logEvent)
            }
        }
        
        if HzLogConfig.consoleEnabled && print {
            shared.consoleOutputs.forEach { output in
                output.log(logEvent)
            }
        }
    }

    public static func reportLog(tag: String? = nil,
                                 message: String,
                                 level: HzLogLevel,
                                 date: Date,
                                 error: String? = nil,
                                 stack: String? = nil,
                                 report: Bool = false) {
    
        let threadId = Thread.isMainThread ? "main-thread": String(cString: __dispatch_queue_get_label(nil), encoding: .utf8) ?? Thread.current.description
        // 构建日志信息
        let logEvent = HzLogEvent(level: level,
                                  message: message,
                                  tag: tag ?? HzLogConfig.prefix,
                                  error: error,
                                  stackTrace: stack,
                                  date: date,
                                  threadID: threadId,
                                  report: report)
        // 在后台线程执行日志写入操作
        if report && HzLogConfig.serverEnabled {
            shared.serverOutputs.forEach { output in
                output.log(logEvent)
            }
        }
        
        if HzLogConfig.fileEnabled {
            shared.fileOutputs.forEach { output in
                output.log(logEvent)
            }
        }
    }

    public static func clearLog() -> Void {
        HzLogFileOutput.shared.clearAllLogFiles()
    }

    public static func getLogFiles() -> String  {
        return HzLogFileOutput.shared.readEntireLogFiles()
    }
    
}
