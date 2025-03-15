struct StartPage {

    static let buttonPressed = "start_app"

static let htmlSource = """
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
        <h1>Redirect to a New Location</h1>
        <input type="text" id="urlInput" placeholder="input">
        <button onclick="redirect()">Go</button>
      </div>

      <script>
        function redirect() {
          window.location.href = "https://\(buttonPressed)"
        }
      </script>
    </body>
    </html>
"""

}
