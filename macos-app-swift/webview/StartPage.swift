struct StartPage {

    static let signinButton = "signin_url"
    static let orderSessionButton = "order_session_url"
    static let precheckoutButton = "precheckout_url"
    static let fetchJwtButton = "fetch_jwt_url"

    static var htmlSource: String { """
            <!DOCTYPE html>
            <html lang="en">
            <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>startpage</title>
              <style>
                body {
                  font-family: Arial, sans-serif;
                  display: flex;
                  justify-content: center;
                  align-items: center;
                  height: 100vh;
                  margin: 0;
                  background-color: #f0f0f0;
                }
                .container {
                  text-align: center;
                  background-color: #fff;
                  padding: 20px;
                  border-radius: 8px;
                  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                }
                input[type="text"] {
                  padding: 10px;
                  width: 300px;
                  border: 1px solid #ccc;
                  border-radius: 4px;
                  font-size: 16px;
                }
                button {
                  padding: 10px 20px;
                  margin-top: 10px;
                  background-color: #007bff;
                  color: #fff;
                  border: none;
                  border-radius: 4px;
                  font-size: 16px;
                  cursor: pointer;
                }
                button:hover {
                  background-color: #0056b3;
                }
              </style>
            </head>
            <body>
              <div class="container">
                <h4>business ID: \(businessId)</h4>
                <h3>JWT: \(Globals.jwt.isEmpty ? "unset" : Globals.jwt.prefix(10)) </h3>
                <h3>ddweb_token: \(Globals.ddweb_token.isEmpty ? "unset" : Globals.ddweb_token.prefix(10)) </h3>
                <h3>ddweb_session_id: \(Globals.ddweb_session_id.isEmpty ? "unset" : Globals.ddweb_session_id.prefix(10)) </h3>
    
                <h3>Loyalty Session ID: \(Globals.sessionId.isEmpty ? "unset" : Globals.sessionId) </h3>
                <h3>Order Session ID: \(Globals.orderSessionId.isEmpty ? "unset" : Globals.orderSessionId) </h3>
                <h1>fetch JWT
                <button onclick="fetchJwtButton()">Go</button></h1>
                <h1>signin page
                <button onclick="redirect()">Go</button></h1>
                <h1>get order session 
                <button onclick="orderSession()">Go</button></h1>
                <h1>precheckout page
                <button onclick="precheckout()">Go</button></h1>
              </div>

              <script>
                function redirect() {
                  window.location.href = "https://\(signinButton)"
                }
                function orderSession() {
                    window.location.href = "https://\(orderSessionButton)"
                }
                function precheckout() {
                    window.location.href = "https://\(precheckoutButton)"
                }
                
                    function fetchJwtButton() {
                        window.location.href = "https://\(fetchJwtButton)"
                    }
        
              </script>
            </body>
            </html>
    """
    }
}
