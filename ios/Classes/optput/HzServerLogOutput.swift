import Foundation

class HzServerLogOutput: HzLogBaseServerOutput {
  
    private let serverURL: URL
    init(serverURL: URL) {
        self.serverURL = serverURL
        super.init()
    }

    internal override func uploadLogToServer(_ message: String, completion: @escaping (Bool) -> Void) {
        
        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        request.httpBody = message.data(using: .utf8)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to upload log: \(error)")
                completion(false)
                return
            }
            print("Log uploaded successfully")
            completion(true)
        }
        task.resume()
    }
}
