import UIKit
import Flutter
import AlibabaCloudRUM
import hz_log_plugin

let armsConfigAddress: String = "https://j1h07oev3e-default-cn.rum.aliyuncs.com/RUM/config"
let armsAppID: String = "j1h07oev3e@e5d6de2278c3293"

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        initLog()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    func initLog() -> Void {
        HzLogManager.addServerOutput(DriverServerOutput())
        HzLog.d(message: "日志初始化", tag: "demo", error: nil, report: true)
    }
    
}
