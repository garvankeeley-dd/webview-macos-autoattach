import Foundation

public struct CreateOrderSessionResponse: Decodable {
    public let orderSessionId: String
    public let checkoutUrl: String
}

struct OrderSessionAPI {
    func getOrderSessionId() async {
        let url = URL(string: "https://openapi.doordash.com/storefront/api/v1/orders/order_session")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //request.setValue("AfroEatz/0 CFNetwork/1568.200.51 Darwin/24.3.0", forHTTPHeaderField: "User-Agent")
        request.setValue("Bearer \(Globals.jwt)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let requestBody = currentCart
        request.httpBody = requestBody.data(using: .utf8)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            print("Response: \(String(data: data, encoding: .utf8) ?? "")")
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(CreateOrderSessionResponse.self, from: data)
            print("result: \(result)")
            
            Globals.orderSessionId = result.orderSessionId
            UserDefaults.standard.set(Globals.orderSessionId, forKey: "orderSessionId")
        } catch {
            UserDefaults.standard.set("", forKey: "orderSessionId")
            print("Error: \(error.localizedDescription)")
        }
    }
}
