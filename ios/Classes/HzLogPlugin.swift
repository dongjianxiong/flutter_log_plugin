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
      result("iOS " + UIDevice.current.systemVersion)
    case "log":
        if let arguments = call.arguments as? Dictionary<String, Any?>, let content = arguments["content"] as? String {
            HzLog.log(tag: arguments["tag"] as? String ?? "HzLog" , content: content, level: HzLevel(rawValue: arguments["level"] as? Int ?? 1000) ?? HzLevel.trace, stack: arguments["staHck"] as? String, report:  arguments["report"] as? Bool ?? false)
        }
        result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
