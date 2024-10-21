//
//  HzConsoleLogOutput.swift
//  hz_log_plugin
//
//  Created by itbox_djx on 2024/10/15.
//

import Foundation


class HzConsoleLogPrinter: HzLogOutput {
    
    static let shared = HzConsoleLogPrinter()
    private init() {
        
    }
    // 用于同步的串行队列，保证线程安全
    private let logQueue = DispatchQueue(label: "cn.itbox.hzlog.console.queue")

    func log(_ logEvent: HzLogEvent) {
        logQueue.async {

            let startLine = "┌-------------------------\(logEvent.level.emoji()) \(logEvent.level.levelString()) START \(logEvent.level.emoji())---------------------------------"
            let endLine = "└-------------------------\(logEvent.level.emoji()) \(logEvent.level.levelString())  END  \(logEvent.level.emoji())---------------------------------"

            // 直接打印日志
            print(startLine)
            print(logEvent.consoleLog)
            print(endLine)
        }
    }
}
