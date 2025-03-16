import Foundation

// Function to create a URLRequest with cookies directly in the header
func createURLRequest(with url: URL, cookies: [(String, String)]) -> URLRequest {
   var request = URLRequest(url: url)
   let cookieHeader = cookies.map { "\($0.0)=\($0.1)" }.joined(separator: "; ")
   request.addValue(cookieHeader, forHTTPHeaderField: "Cookie")
   return request
}
