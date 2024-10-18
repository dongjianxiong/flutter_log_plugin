//
//  DriverServerOutput.swift
//  Runner
//
//  Created by itbox_djx on 2024/10/17.
//

import UIKit
import AlibabaCloudRUM
import hz_log_plugin

class DriverServerOutput: HzLogBaseServerOutput {

    override init() {
        super.init()
        initArmsSDK()
    }
    // ARMS应用实时监控服务SDK
    func initArmsSDK() {
        AlibabaCloudRUM.setConfigAddress(armsConfigAddress)// ConfigAddress，创建RUM应用时获取。
        AlibabaCloudRUM.setChannelID("AppStore")
        AlibabaCloudRUM.setEnvironment(AlibabaCloudRUM.Env.DAILY)
        AlibabaCloudRUM.start(armsAppID)// AppID，创建RUM应用时获取。
    }
    
    override func uploadLogToServer(_ message: String, completion: @escaping (Bool) -> Void) {
        print("======logEvent.reportLog:\(message)")
        AlibabaCloudRUM.setCustomLog(message, name: "demo", snapshots: "12345678", level: "INFO_ERROR")
        completion(true)
    }
}
