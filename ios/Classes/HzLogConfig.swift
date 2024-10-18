//
//  HzLogConfig.swift
//  hz_log_plugin
//
//  Created by itbox_djx on 2024/10/16.
//

import UIKit

class HzLogConfig: NSObject {

    static var consoleEnabled = true
    static var fileEnabled = true
    static var serverEnabled = true // 假设上传功能未实现
    static var feishuNotifyEnabled = true // 飞书通知默认未开启
    // 默认日志级别
    static var logLevel: HzLogLevel = .all
    // 默认前缀
    static var prefix: String = "HzLog"
    
    static var extra: Dictionary<String, Any> = [:]
    
    static var maxServerLogSize: Int = 5000 // 最大字符个数改为5000
    static var maxServerLogCount: Int = 10 // 最大合并日志个数
    static var maxServerLogInterval: TimeInterval = 5.0 // 5秒钟
}
