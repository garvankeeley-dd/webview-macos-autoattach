import WebKit
import Cocoa

/**
 
 curl 'https://identity.spendgo.com/oauth2/v3/auth?scope=user_profile&redirect_uri=https%3A%2F%2Forder.online%2Fonline-ordering%2Fmobile_auth_callback%2F&response_type=code&client_id=3natives_oauth_doordash_sf&state=c8559b45-a9a1-4c69-9c7b-a17b81549db8' \
 -H 'Host: identity.spendgo.com' \
 -H 'Sec-Fetch-Site: none' \
 -H 'Connection: keep-alive' \
 -H 'Sec-Fetch-Mode: navigate' \
 -H 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 18_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 iOSStorefrontMobileApp' \
 -H 'Accept-Language: en-CA,en-US;q=0.9,en;q=0.8' \
 -H 'Sec-Fetch-Dest: document'
 
 */

let clientId = "3natives_oauth_doordash_sf"

class ViewController: NSViewController {
    var webView: WKWebView!
    var backButton = NSButton()
    var buttonConstraints: [NSLayoutConstraint] = []

    enum URLs {
        static var precheckout: String { "https://order.online/precheckout/\(Globals.orderSessionId)?storeId=\(businessId)&code=\(Globals.sessionId)" }
        
        static let signinLoyaltyless = "https://order.online/bz-\(businessId)/login"
        
        static var signinLoyalty: String {
            "https://identity.spendgo.com/oauth2/v3/auth?scope=user_profile&redirect_uri=https%3A%2F%2Forder.online%2Fonline-ordering%2Fmobile_auth_callback%2F&response_type=code&client_id=\(clientId)&state=c8559b45-a9a1-4c69-9c7b-a17b81549db8"
        }
    }
    
    override func loadView() {
        // Consider loading from UserDefaults so it is faster to re-run the app.
        /*
        Globals.sessionId = UserDefaults.standard.string(forKey: "sessionId") ?? ""
        Globals.orderSessionId = UserDefaults.standard.string(forKey: "orderSessionId") ?? ""
        Globals.ddweb_session_id = UserDefaults.standard.string(forKey: "ddweb_session_id") ?? ""
        Globals.ddweb_token = UserDefaults.standard.string(forKey: "ddweb_token") ?? ""
         */

        setupWebView()
        createFloatingBackButton()
    }
    
    func createFloatingBackButton() {
        backButton = NSButton()
        backButton.bezelStyle = .circular
        backButton.isBordered = false
        backButton.image = NSImage(systemSymbolName: "arrow.left", accessibilityDescription: "Back")
        backButton.target = self
        backButton.action = #selector(backButtonTapped)
        backButton.wantsLayer = true
        backButton.layer?.backgroundColor = NSColor.red.cgColor
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
       
        // Initial button constraints (positioned at the bottom right)
        updateButtonConstraints(for: view.frame.size)
    }

    // Update button position based on view size
    override func viewDidLayout() {
        updateButtonConstraints(for: view.frame.size)
    }

    // Helper function to update button constraints
    private func updateButtonConstraints(for size: NSSize) {
        NSLayoutConstraint.deactivate(buttonConstraints)
        buttonConstraints = [
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44)
        ]
        NSLayoutConstraint.activate(buttonConstraints)
    }
    
    @objc func backButtonTapped() {
        viewDidLoad()
    }
 
    override func viewDidLoad() {
        webView.loadHTMLString(StartPage.htmlSource, baseURL: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title", let title = webView.title {
            self.view.window?.title = title
            self.view.window?.update()
        }
    }
}

extension ViewController: WKUIDelegate {
    // New windows, not supported on mobile!
    public func webView(_ webView: WKWebView,
                        createWebViewWith configuration: WKWebViewConfiguration,
                        for navigationAction: WKNavigationAction,
                        windowFeatures: WKWindowFeatures) -> WKWebView? {
        assertionFailure("Unsupported feature: creating a new web view for navigation action \(navigationAction)")
        //        if navigationAction.targetFrame == nil {
        //            self.webView.load(navigationAction.request)
        //        }
        return nil
    }
}
