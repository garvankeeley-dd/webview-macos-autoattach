import WebKit
import Cocoa

class ViewController: NSViewController {
    var webView: WKWebView!
    var cook: String = "no";

    enum URLs {
        static let precheckout = "https://order.online/precheckout/"
    }

    override func loadView() {
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.preferredContentMode = .mobile
        // Fresh slate every execution, no cookies from previous session.
        config.websiteDataStore = .nonPersistent()

        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 500, height: 800),
                            configuration: config)
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.3 Mobile/15E148 Safari/604.1"

        // Enable right click inspect
        config.preferences.setValue(true, forKey: "developerExtrasEnabled")

        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.isInspectable = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        view = webView
    }

    func loadMainPage() {
        let url = URL(string: URLs.precheckout)!
        let myRequest = createURLRequest(with: url, cookies: [])
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
        if let url = webView.url { print(url) }
    }
}

extension ViewController: WKUIDelegate {
    // New windows, not supported on mobile!
    public func webView(_ webView: WKWebView,
                        createWebViewWith configuration: WKWebViewConfiguration,
                        for navigationAction: WKNavigationAction,
                        windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            self.webView.load(navigationAction.request)
        }
        return nil
    }
}

extension WKWebView {
    private var httpCookieStore: WKHTTPCookieStore  {
        WKWebsiteDataStore.default().httpCookieStore
    }

    func getCookies(for domain: String? = nil, completion: @escaping ([String : String])->())  {
        var cookieDict = [String : String]()
        httpCookieStore.getAllCookies { cookies in
            for cookie in cookies {
                if let domain = domain {
                    if cookie.domain.contains(domain) {
                        cookieDict[cookie.name] = cookie.value
                    }
                } else {
                    cookieDict[cookie.name] = cookie.value
                }
            }
            completion(cookieDict)
        }
    }
}
