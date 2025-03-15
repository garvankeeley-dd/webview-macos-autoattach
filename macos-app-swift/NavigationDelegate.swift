@preconcurrency import WebKit

extension ViewController: WKNavigationDelegate {
    // Called when the web view begins to receive web content.
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Web view started loading.")
    }

    // Called when the web view receives a server redirect.
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("Received server redirect.")
    }

    // Called when an error occurs during web content loading.
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Failed provisional navigation with error: \(error.localizedDescription)")
    }

    // Called when the web view begins to load web content.
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Web view committed navigation.")
    }

    // Called when the web view finishes loading web content.
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Web view finished loading.")

        Attacher.exec()
    }

    // Called when an error occurs during web content loading after navigation has started.
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Failed navigation with error: \(error.localizedDescription)")
    }

    // Called when the web view needs to respond to an authentication challenge.
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("Received authentication challenge.")
        // Handle the authentication challenge (e.g., provide credentials).
        completionHandler(.performDefaultHandling, nil)
    }

    // Called when the web view's web content process is terminated.
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("Web content process terminated.")
    }

    // Called to decide whether to allow or cancel a navigation.
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("Deciding policy for navigation action.")

        if navigationAction.request.url?.absoluteString.contains(StartPage.buttonPressed) == true {
            decisionHandler(.cancel)

            loadMainPage()
            
            return
        }

        decisionHandler(.allow)
    }

    // Called to decide whether to allow or cancel a navigation after the response is received.
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("Deciding policy for navigation response.")
        // Allow or cancel the navigation based on the response.
        decisionHandler(.allow)
    }
}

