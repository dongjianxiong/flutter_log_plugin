//
//  HzLogBaseServerOutput.swift
//  hz_log_plugin
//
//  Created by itbox_djx on 2024/10/17.
//


import Foundation

open class HzLogBaseServerOutput: HzLogOutput {
  

    var maxLogSize: Int { // 最大字符个数
        return HzLogConfig.maxServerLogSize
    }
    
    var maxLogCount: Int { // 最大合并日志个数
        return HzLogConfig.maxServerLogCount
    }
    
    var maxInterval: TimeInterval { // 5秒钟
        return HzLogConfig.maxServerLogInterval
    }
    
    private var logQueue: [String] = []
    private var currentLogSize: Int = 0

    private let uploadQueue = DispatchQueue(label: "cn.itbox.logUpload.queue") // 线程安全队列
    // 创建一个标识符
    private let queueKey = DispatchSpecificKey<Void>()
    
    private var lastUploadTime: Date = Date() // 记录上次上传时间
    private let backgroundQueue = DispatchQueue(label: "cn.itbox.logUpload.background", qos: .background) // 后台线程

    
    public init() {
        uploadQueue.setSpecific(key: queueKey, value: ())
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc func appDidEnterBackground() {
        self.uploadLogs()
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    public func log(_ logEvent: HzLogEvent) {
        uploadQueue.async { [weak self] in
            guard let self = self else { return }
            
            let message = logEvent.reportLog
            self.logQueue.append(message)
            self.currentLogSize += message.count // 计算字符个数
            // 检查当前日志字符个数是否超过阈值
            if canUpload {
                self.uploadLogs()
            }
        }
    }
    
    private var canUpload: Bool {
        let isSizeOut = self.currentLogSize >= self.maxLogSize
        let isCountOut = self.logQueue.count >= self.maxLogCount
        let currentTime = Date()
        let timeInterval = currentTime.timeIntervalSince(self.lastUploadTime)
        let isTimeOut = timeInterval >= self.maxInterval
        if isSizeOut || isCountOut || isTimeOut  {
#if DEBUG
            print("=====currentLogSize: \(self.currentLogSize), maxSize:\(self.maxLogSize)")
            print("=====currentLogCount: \(self.logQueue.count), maxCount:\(self.maxLogCount)")
            print("=====currentTimeInterval: \(timeInterval), maxInterval:\(self.maxInterval)")
            print("=====上传条件：isSizeOut-\(isSizeOut), isCountOut-\(isCountOut), isTimeOut:-\(isTimeOut)")#else

#endif
            return true
        } else {
            return false
        }
    }
    
    private var isTimeout: Bool {
        let currentTime = Date()
        return currentTime.timeIntervalSince(self.lastUploadTime) >= self.maxInterval
    }
    
    
    private func resetState() {
        self.currentLogSize = 0
        lastUploadTime = Date()
    }
    
    
    func safeQueueSync<T>(block: () -> T) -> T {
        if DispatchQueue.getSpecific(key: queueKey) != nil {
            return block()
        } else {
            return uploadQueue.sync {
                return block()
            }
        }
    }
    
    func safeQueueAsync(block: @escaping () -> Void) -> Void {
        if DispatchQueue.getSpecific(key: queueKey) != nil {
            block()
        } else {
            uploadQueue.async {
                block()
            }
        }
    }

    private func uploadLogs() {
        if self.logQueue.isEmpty {
            self.resetState()
            return
        }
        safeQueueAsync { [weak self] in
            guard let self = self else { return }
            let combinedLogs = self.logQueue.joined(separator: "\n\n")
            self.logQueue.removeAll()
            self.resetState()
            self.uploadLogToServer(combinedLogs) { success in
                if success {
                    print("Log upload success, retrying...")
                } else {
                    print("Log upload failed, retrying...")
                }
            }
        }
    }
    

    private func startBackgroundMonitoring() {
        backgroundQueue.async { [weak self] in
            guard let self = self else { return }
            
            while true {
                self.uploadQueue.async {
                    if Date().timeIntervalSince(self.lastUploadTime) >= self.maxInterval {
                        self.uploadLogs()
                    }
                }
                Thread.sleep(forTimeInterval: 1.0)
            }
        }
    }
    
    open func uploadLogToServer(_ message: String, completion: @escaping (Bool) -> Void) {
        fatalError("Subclasses must implement `uploadLogToServer`")
    }
    
}




//open class HzLogBaseServerOutput: HzLogOutput {
//  
//    private var logQueue: [String] = []
//    private var currentLogSize: Int = 0
//    private let maxLogSize: Int = 50 * 1024 // 3000K
//    private var timer: DispatchSourceTimer?
//    private let queue = DispatchQueue(label: "cn.itbox.logUpload.queue") // 线程安全队列
//    private var isTimerRunning = false // 标记计时器是否运行中
//    // 创建一个标识符
//    private let queueKey = DispatchSpecificKey<Void>()
//    public init() {
//        // 给队列设置特定值（这里可以是任意值，比如一个空的指针）
//        queue.setSpecific(key: queueKey, value: ())
//    }
//    
//    
//
//    public func log(_ logEvent: HzLogEvent) {
//        queue.async { [weak self] in
//            guard let self = self else { return }
//            
//            let message = logEvent.reportLog
//            self.logQueue.append(message)
//            self.currentLogSize += message.utf8.count
//            print("=====LogCount: \(self.logQueue.count)")
//            print("=====currentLogSize: \(self.currentLogSize)")
//            // 检查当前日志大小是否超过阈值
//            if self.currentLogSize >= self.maxLogSize {
//                self.uploadLogs()
//            } else if !self.isTimerRunning {
//                // 只有在没有定时器运行时才启动
//                self.startTimer()
//            }
//        }
//    }
//    
//    
//    private func startTimer() {
//        isTimerRunning = true
//        
//        // 取消之前的计时器（如果有）
//        timer?.cancel()
//        
//        // 创建新的 GCD 定时器
//        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
//        
//        // 设置定时器的触发时间
//        timer?.schedule(deadline: .now() + 1.0, repeating: .never)
//        
//        // 设置定时器的处理块
//        timer?.setEventHandler { [weak self] in
//            guard let self = self else { return }
//            self.uploadLogs()
//        }
//        
//        // 启动定时器
//        timer?.resume()
//    }
//    
//    func safeQueueSync<T>(block: () -> T) -> T {
//        if DispatchQueue.getSpecific(key: queueKey) != nil {
//            return block()
//        } else {
//            return queue.sync {
//                return block()
//            }
//        }
//    }
//    
//    func safeQueueAsync(block: @escaping () -> Void) -> Void {
//        if DispatchQueue.getSpecific(key: queueKey) != nil {
//            block()
//        } else {
//            queue.async {
//                block()
//            }
//        }
//    }
//
//
//    private func uploadLogs() {
//        
//        if self.logQueue.isEmpty {
//            self.resetState()
//            return // 如果没有日志，不上传
//        }
//        safeQueueAsync {  [weak self] in
//            guard let self = self else { return }
//            // 将日志合并成一条
//            let combinedLogs = self.logQueue.joined(separator: "\n\n")
//            // 清空日志队列并重置状态
//            self.logQueue.removeAll()
//            self.resetState()
//            // 上传日志到服务器
//            self.uploadLogToServer(combinedLogs) { success in
//    //            guard let self = self else { return }
//                if success {
//                    print("Log upload success, retrying...")
//                } else {
//                    // 处理上传失败的情况（例如保留日志，下次重试）
//                    print("Log upload failed, retrying...")
//                }
//            }
//        }
//    }
//    
//    private func resetState() {
//        self.currentLogSize = 0 // 重置当前日志大小
//        self.isTimerRunning = false // 上传后重置计时器状态
//        timer?.cancel()
//    }
//    
//    
//    open func uploadLogToServer(_ message: String, completion: @escaping (Bool) -> Void) {
//        fatalError("Subclasses must implement `uploadLogToServer`")
//    }
//}
