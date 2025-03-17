import Foundation

// Function to create a URLRequest with cookies directly in the header
func createURLRequest(with url: URL, cookies: [(String, String)]) -> URLRequest {
    // Create cookies and store them in HTTPCookieStorage
    let cookieStorage = HTTPCookieStorage.shared
    var httpCookies: [HTTPCookie] = []
    
    [".order.online", "localhost"].forEach { host in
        for (name, value) in cookies {
            let cookieProperties: [HTTPCookiePropertyKey: Any] = [
                .domain: host,
                .path: "/",
                .name: name,
                .value: value,
                .secure: false, // Allow insecure localhost
                .expires: Date().addingTimeInterval(31556926) // 1 year expiration
            ]
            
            if let cookie = HTTPCookie(properties: cookieProperties) {
                httpCookies.append(cookie)
                cookieStorage.setCookie(cookie)
            }
        }
    }
    
   var request = URLRequest(url: url)
   let cookieHeader = cookies.map { "\($0.0)=\($0.1)" }.joined(separator: "; ")
   request.addValue(cookieHeader, forHTTPHeaderField: "Cookie")
   return request
}

