import Flutter
import UIKit

public class HzLogPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "hz_log_plugin", binaryMessenger: registrar.messenger())
        let instance = HzLogPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            handleGetPlatformVersion(result: result)
        case "log":
            handleLog(call: call, result: result)
        case "setLogLevel":
            handleSetLogLevel(call: call, result: result)
        case "setPrefix":
            handleSetPrefix(call: call, result: result)
        case "reportLog":
            handleReportLog(call: call, result: result)
        case "openLogcat":
            handleOpenLogcat(call: call, result: result)
        case "setExtra":
            handleSetExtra(call: call, result: result)
        case "setFeishuOutput":
            handleSetFeishuOutput(call: call, result: result)
        case "setFileOutput":
            handleSetFileOutput(call: call, result: result)
        case "setCallbackOutput":
            handleSetCallbackOutput(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // 处理获取平台版本号
    private func handleGetPlatformVersion(result: FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
    }

    // 处理日志记录
    private func handleLog(call: FlutterMethodCall, result: FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let content = arguments["content"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for log", details: call.arguments))
            return
        }
        let tag = arguments["tag"] as? String
        let level = HzLogLevel(rawValue: arguments["level"] as? Int ?? 1000) ?? .trace
        let stack = arguments["stack"] as? String
        let error = arguments["error"] as? String
        let report = arguments["report"] as? Bool ?? false
        HzLog.log(tag: tag, content: content, level: level, error: error, stack: stack, report: report)
        result(nil)
    }

    // 处理日志级别设置
    private func handleSetLogLevel(call: FlutterMethodCall, result: FlutterResult) {
        
        guard let arguments = call.arguments as? [String: Any],
            let levelRawValue = arguments["level"] as? Int, 
            let level = HzLogLevel(rawValue: levelRawValue) else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for setFileOutput", details: call.arguments))
            return
        }
        HzLog.setLogLevel(level)
        result(nil)
    }
    
    // 处理设置前缀方法
    private func handleSetPrefix(call: FlutterMethodCall, result: FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
            let prefix = arguments["prefix"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for setFileOutput", details: call.arguments))
            return
        }
        HzLog.setPrefix(prefix)
        result(nil)
    }
    
    // 处理日志记录
    private func handleReportLog(call: FlutterMethodCall, result: FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let content = arguments["content"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for log", details: call.arguments))
            return
        }
        let tag = arguments["tag"] as? String
        let level = HzLogLevel(rawValue: arguments["level"] as? Int ?? 1000) ?? .trace
        let stack = arguments["stack"] as? String
        let error = arguments["error"] as? String
        HzLog.reportLog(tag: tag, content: content, level: level, error: error, stack: stack)
        result(nil)
    }

    // 处理开启 Logcat
    private func handleOpenLogcat(call: FlutterMethodCall, result: FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let open = arguments["open"] as? Bool else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for setFileOutput", details: call.arguments))
            return
        }
        HzLog.openLogcat(open: open)
        result(nil)
    }

    // 处理设置额外信息
    private func handleSetExtra(call: FlutterMethodCall, result: FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let key = arguments["key"] as? String,
              let value = arguments["value"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for setExtra", details: call.arguments))
            return
        }
        HzLog.setExtra(key: key, value: value)
        result(nil)
    }

    // 处理飞书日志输出设置
    private func handleSetFeishuOutput(call: FlutterMethodCall, result: FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let hookId = arguments["hookId"] as? String,
              let open = arguments["open"] as? Bool,
              let projectId = arguments["projectId"] as? String,
              let logStoreId = arguments["logStoreId"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for setFeishuOutput", details: call.arguments))
            return
        }
        HzLog.setFeishuOutput(hookId: hookId, open: open, projectId: projectId, logStoreId: logStoreId)
        result(nil)
    }

    // 处理文件输出设置
    private func handleSetFileOutput(call: FlutterMethodCall, result: FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let open = arguments["open"] as? Bool else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for setFileOutput", details: call.arguments))
            return
        }
        HzLog.setFileOutput(open: open)
        result(nil)
    }

    // 处理回调输出设置
    private func handleSetCallbackOutput(call: FlutterMethodCall, result: FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let open = arguments["open"] as? Bool else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for setCallbackOutput", details: call.arguments))
            return
        }
        HzLog.setCallbackOutput(open: open)
        result(nil)
    }
}
