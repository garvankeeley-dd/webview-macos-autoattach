import WebKit

struct Globals {
    static let store = WKWebsiteDataStore.nonPersistent()
    static var sessionId = ""
    static var orderSessionId = ""
    static var ddweb_token = ""
    static var ddweb_session_id = ""
    static var jwt = ""
}

// MARK: - Setup Web View
extension ViewController {
    func setupWebView() {
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.preferredContentMode = .mobile
        config.websiteDataStore = Globals.store
        
        let userContentController = WKUserContentController()
        ["sessionId", "criticalError"]
            .forEach { userContentController.add(self, name: $0) }
        config.userContentController = userContentController
        
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 500, height: 800),
                            configuration: config)
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.3 Mobile/15E148 Safari/604.1 iOSStorefrontMobileApp"
        
        // Enable right click inspect
        config.preferences.setValue(true, forKey: "developerExtrasEnabled")
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.isInspectable = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        view = webView
        
    }
}

// MARK: - Load Web Pages
extension ViewController {
    func loadSigninPage() {
        let url = URL(string: URLs.signin)!
        let myRequest = createURLRequest(with: url,
                                         cookies: [ ("native_mobile_integration_id", native_mobile_integration_id),
                                                    ("dd_device_id", dd_device_id),
                                                    ("native_mobile_integration_type", native_mobile_integration_type),
                                                    ("app_oauth_state", app_oauth_state)
                                                  ])
        webView.load(myRequest)
    }
    
    func loadPrecheckoutPage() {
        let url = URL(string: URLs.precheckout)!
        let myRequest = createURLRequest(with: url,
                                         cookies: [ ("native_mobile_integration_id", native_mobile_integration_id),
                                                    ("dd_device_id", dd_device_id),
                                                    ("native_mobile_integration_type", native_mobile_integration_type),
                                                    ("ddweb_session_id", Globals.ddweb_session_id),
                                                    ("ddweb_token", Globals.ddweb_token)
                                                  ])
        webView.load(myRequest)
    }
}
