import Foundation
import WebKit

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "sessionId", let messageBody = message.body as? String {
            print("Received message from JavaScript: \(messageBody)")
            
            let regex = try! NSRegularExpression(pattern: "\"([a-z_]+)\":\"([a-zA-Z0-9\\-]+)\"", options: [])
            if let match = regex.firstMatch(in: messageBody, options: [], range: NSRange(location: 0, length: messageBody.count)) {
                let uuidRange = match.range(at: 2) // Get the range of the second capture group (UUID)
                let uuid = (messageBody as NSString).substring(with: uuidRange)
                Globals.sessionId = uuid
                
                webView.evaluateJavaScript(
                    jsAlert(message: "iOS got Session ID: \(Globals.sessionId)")
                )
                
                UserDefaults.standard.set(uuid, forKey: "sessionId")
                
                readCookies()
            }
        }
        else if message.name == "criticalError", let messageBody = message.body as? String {
            print("Critical error from JavaScript: \(messageBody)")
        }
    }
}
