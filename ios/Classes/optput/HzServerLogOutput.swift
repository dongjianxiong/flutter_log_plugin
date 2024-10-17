//
//  HzServerLogOutput.swift
//  hz_log_plugin
//
//  Created by itbox_djx on 2024/10/15.
//

import Foundation


class HzServerLogOutput: HzLogOutput {
  
    private let serverURL: URL

    init(serverURL: URL) {
        self.serverURL = serverURL
    }

    func log(_ logEvent: HzLogEvent) {
        uploadLogToServer(logEvent.reportLog)
    }
    
    private func uploadLogToServer(_ message: String) {
        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        request.httpBody = message.data(using: .utf8)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to upload log: \(error)")
                return
            }
            print("Log uploaded successfully")
        }
        task.resume()
    }
}
