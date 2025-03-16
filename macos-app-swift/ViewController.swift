import WebKit
import Cocoa

struct Globals {
    static let store = WKWebsiteDataStore.nonPersistent()
    static var sessionId = ""
    static var orderSessionId = ""
    static var ddweb_token = ""
    static var ddweb_session_id = ""
    static var jwt = ""
}

class ViewController: NSViewController {
    var webView: WKWebView!
    var backButton = NSButton()
    var buttonConstraints: [NSLayoutConstraint] = []

    enum URLs {
        static var precheckout: String { "https://order.online/precheckout/\(Globals.orderSessionId)?storeId=\(businessId)&code=\(Globals.sessionId)" }
        static let signin = "https://order.online/bz-\(businessId)/login"
    }
    
    override func loadView() {
//        Globals.sessionId = UserDefaults.standard.string(forKey: "sessionId") ?? ""
//        Globals.orderSessionId = UserDefaults.standard.string(forKey: "orderSessionId") ?? ""
//        Globals.ddweb_session_id = UserDefaults.standard.string(forKey: "ddweb_session_id") ?? ""
//        Globals.ddweb_token = UserDefaults.standard.string(forKey: "ddweb_token") ?? ""

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
        
        // Create and add floating back button
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
