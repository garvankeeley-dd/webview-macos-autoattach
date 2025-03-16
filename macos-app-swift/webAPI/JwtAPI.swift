import Foundation

func fetchJWT() async throws -> String {
    let url = URL(string: "https://openapi.doordash.com/storefront/api/v1/jwt")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let bodyData = """
    {"integration_id":"\(native_mobile_integration_id)","integration_type":"\(native_mobile_integration_type)"}
    """.data(using: .utf8)
    request.httpBody = bodyData
    
    do {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.unknown)
        }
        
        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
           let jwt = json["jwt"] as? String {
            Globals.jwt = jwt
            return jwt
        } else {
            throw URLError(.unknown)
        }
    }
}
