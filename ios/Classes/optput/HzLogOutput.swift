//
//  HzLogOutput.swift
//  hz_log_plugin
//
//  Created by itbox_djx on 2024/10/15.
//

import Foundation

public protocol HzLogOutput: AnyObject {
    func log(_ logEvent: HzLogEvent);
}
