import Foundation

// Function to create a URLRequest with cookies directly in the header
func createURLRequest(with url: URL, cookies: [(String, String)]) -> URLRequest {
   var request = URLRequest(url: url)
   let cookieHeader = cookies.map { "\($0.0)=\($0.1)" }.joined(separator: "; ")
   request.addValue(cookieHeader, forHTTPHeaderField: "Cookie")
   return request
}

//// Function to create a URLRequest with cookies
//func createURLRequest(with url: URL, cookies: [(String, String)]) -> URLRequest {
//    // Create and add cookies to the shared cookie storage
//    for (name, value) in cookies {
//        let cookieProperties: [HTTPCookiePropertyKey: Any] = [
//            .name: name,
//            .value: value,
//            .domain: url.host ?? "",
//            .path: "/",
//            .expires: Date().addingTimeInterval(31536000) // 1 year from now
//        ]
//
//        if let cookie = HTTPCookie(properties: cookieProperties) {
//            HTTPCookieStorage.shared.setCookie(cookie)
//        }
//    }
//
//    // Create a URLRequest
//    var request = URLRequest(url: url)
//
//    // Attach cookies to the request
//    if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
//        let cookieHeader = cookies.map { "\($0.name)=\($0.value)" }.joined(separator: "; ")
//        request.addValue(cookieHeader, forHTTPHeaderField: "Cookie")
//    }
//}
