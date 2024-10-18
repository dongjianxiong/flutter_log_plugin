//
//  HzFileLogOutput.swift
//  hz_log_plugin
//
//  Created by itbox_djx on 2024/10/15.
//

import Foundation

class HzFileLogOutput: HzLogOutput {
    
    static let shared = HzFileLogOutput()
    private init() {
        // 给队列设置特定值（这里可以是任意值，比如一个空的指针）
        fileQueue.setSpecific(key: queueKey, value: ())
        createLogDirectoryIfNeeded()
    }

    // 日志目录路径
    private let logDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("HzLogs")
    
    // 单个日志文件最大大小（以字节为单位），例如 5MB = 5 * 1024 * 1024 字节
    private let maxFileSize: UInt64 = 2 * 1024 * 1024
    
    // 日志文件最多保存的数量
    private let maxLogFilesCount = 5
    
    // 串行队列用于保证线程安全
    private let fileQueue = DispatchQueue(label: "cn.itbox.hzlog.file.queue")
    // 创建一个标识符
    private let queueKey = DispatchSpecificKey<Void>()
        


    func log(_ logEvent: HzLogEvent) {
        fileQueue.async {
            self.writeLog(logEvent.reportLog)
        }
    }
    
    func safeQueueSync<T>(block: () -> T) -> T {
        if DispatchQueue.getSpecific(key: queueKey) != nil {
            return block()
        } else {
            return fileQueue.sync {
                return block()
            }
        }
    }


    // 创建日志目录
    private func createLogDirectoryIfNeeded() {
        safeQueueSync {
            if !FileManager.default.fileExists(atPath: logDirectory.path) {
                do {
                    try FileManager.default.createDirectory(at: logDirectory, withIntermediateDirectories: true, attributes: nil)
                    print("Log directory created successfully.")
                } catch {
                    print("Failed to create log directory: \(error)")
                }
            }
        }
    }
    
    private func writeLog(_ message: String) {
        let currentLogFileURL = self.getCurrentLogFileURL()

        // 为日志消息手动添加换行符
        let logMessageWithNewline = message + "\n" + "\n"

        if let data = logMessageWithNewline.data(using: .utf8) {
            if FileManager.default.fileExists(atPath: currentLogFileURL.path) {
                do {
                    // 打开文件句柄，移动到文件末尾并写入新的日志
                    let fileHandle = try FileHandle(forWritingTo: currentLogFileURL)
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(data)
                    fileHandle.closeFile()
                } catch {
                    print("-------Failed to open file handle: \(error)")
                }
            } else {
                // 如果文件不存在，创建文件并写入日志
                do {
                    try data.write(to: currentLogFileURL, options: .atomic)
                } catch {
                    print("-------Failed to write log file: \(error)")
                }
            }
        }

        // 检查日志文件大小并进行日志轮换
        self.checkLogFileSizeAndRotateIfNeeded()
    }

    // 获取当前日志文件路径
    private func getCurrentLogFileURL() -> URL {
        return logDirectory.appendingPathComponent("log_current.txt")
    }

    // 检查日志文件大小并进行日志轮换
    private func checkLogFileSizeAndRotateIfNeeded() {
        let currentLogFileURL = getCurrentLogFileURL()

        if let attributes = try? FileManager.default.attributesOfItem(atPath: currentLogFileURL.path),
           let fileSize = attributes[.size] as? UInt64 {
            print("-------currentFileSize:\(fileSize), maxFileSize:\(maxFileSize)")
            if fileSize > maxFileSize {
                rotateLogFiles()
            }
        }
    }

    // 轮换日志文件
    private func rotateLogFiles() {
        print("-------rotateLogFiles")
        safeQueueSync {
            let fileManager = FileManager.default
            let currentLogFileURL = getCurrentLogFileURL()

            // 将现有文件重命名为 log_1.txt，依次递增
            for i in stride(from: maxLogFilesCount - 1, through: 1, by: -1) {
                let previousFileURL = logDirectory.appendingPathComponent("log_\(i).txt")
                let nextFileURL = logDirectory.appendingPathComponent("log_\(i + 1).txt")

                if fileManager.fileExists(atPath: previousFileURL.path) {
                    try? fileManager.moveItem(at: previousFileURL, to: nextFileURL)
                }
            }

            // 将当前日志文件重命名为 log_1.txt
            let newLogFileURL = logDirectory.appendingPathComponent("log_1.txt")
            try? fileManager.moveItem(at: currentLogFileURL, to: newLogFileURL)

            // 创建新的当前日志文件
            try? "".data(using: .utf8)?.write(to: currentLogFileURL)

            // 删除超过最大数量的日志文件
            deleteOldLogFilesIfNeeded()
        }
    }

    // 删除多余的日志文件
    private func deleteOldLogFilesIfNeeded() {
        print("-------deleteOldLogFilesIfNeeded")
        let fileManager = FileManager.default
        let oldestLogFileURL = logDirectory.appendingPathComponent("log_\(maxLogFilesCount).txt")

        if fileManager.fileExists(atPath: oldestLogFileURL.path) {
            try? fileManager.removeItem(at: oldestLogFileURL)
        }
    }

    // 读取日志文件内容
    func readLogFile() -> String {
        return safeQueueSync {
            let currentLogFileURL = getCurrentLogFileURL()
            do {
                let logContent = try String(contentsOf: currentLogFileURL, encoding: .utf8)
                return logContent
            } catch {
                print("-------Failed to read log file: \(error)")
                return ""
            }
        }
    }

    // 读取所有日志文件内容（用于上传）
    func readEntireLogFiles() -> String {
        print("-------readEntireLogFiles")
        return safeQueueSync {
            var allLogs = ""
            for i in 1...maxLogFilesCount {
                let logFileURL = logDirectory.appendingPathComponent("log_\(i).txt")
                if FileManager.default.fileExists(atPath: logFileURL.path) {
                    if let logContent = try? String(contentsOf: logFileURL, encoding: .utf8) {
                        allLogs += logContent
                    }
                }
            }
            let currentLog = readLogFile()
            
            if !currentLog.isEmpty {
                allLogs += currentLog
            }
            return allLogs
        }
    }

    // 清空日志文件
    func clearLogFile() -> Void {
        print("-------Attempting to clear log file")
        return safeQueueSync {
            let currentLogFileURL = getCurrentLogFileURL()
            do {
                let fileHandle = try FileHandle(forWritingTo: currentLogFileURL)
                fileHandle.closeFile()
                try "".data(using: .utf8)?.write(to: currentLogFileURL)
                print("-------Log file cleared successfully.")
            } catch {
                print("-------Failed to clear log file: \(error)")
            }
        }
    }
}

