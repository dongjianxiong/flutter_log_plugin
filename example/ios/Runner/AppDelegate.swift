import UIKit
import Flutter
import AlibabaCloudRUM
import hz_log_plugin

let armsConfigAddress: String = "https://j1h07oev3e-default-cn.rum.aliyuncs.com/RUM/config"
let armsAppID: String = "j1h07oev3e@e5d6de2278c3293"

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, HzLogOutput {
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        initLog()
        initArmsSDK()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    // ARMS应用实时监控服务SDK
    func initArmsSDK() {
        AlibabaCloudRUM.setConfigAddress(armsConfigAddress)// ConfigAddress，创建RUM应用时获取。
        AlibabaCloudRUM.setChannelID("AppStore")
        AlibabaCloudRUM.setEnvironment(AlibabaCloudRUM.Env.DAILY)
        AlibabaCloudRUM.start(armsAppID)// AppID，创建RUM应用时获取。
    }
    
    
    
    func initLog() -> Void {
        HzLogManager.addServerOutput(self)
        HzLog.d(tag: "init", content: "日志初始化", error: nil, report: true)
    }
    
    func log(_ logEvent: HzLogEvent) {
        AlibabaCloudRUM.setCustomLog(logEvent.reportLog, name: logEvent.tag, level: logEvent.level.levelString(), info: ["baseInfo": logEvent.baseInfo])
    }
    
}
