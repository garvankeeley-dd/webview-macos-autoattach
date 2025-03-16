import WebKit
import Cocoa

class ViewController: NSViewController {
    var webView: WKWebView!
    var backButton = NSButton()
    var buttonConstraints: [NSLayoutConstraint] = []

    enum URLs {
        static var precheckout: String { "https://order.online/precheckout/\(Globals.orderSessionId)?storeId=\(businessId)&code=\(Globals.sessionId)" }
        static let signin = "https://order.online/bz-\(businessId)/login"
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
