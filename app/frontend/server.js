const express = require("express");

const app = express();
const PORT = process.env.PORT || 3000;
const BACKEND_URL = process.env.BACKEND_URL || "http://127.0.0.1:5000";
app.get("/api/health", async (req, res) => {
  try {
    const response = await fetch(`${BACKEND_URL}/health`);
    const data = await response.json();
    res.status(response.status).json(data);
  } catch (error) {
    res.status(502).json({
      status: "error",
      message: "Flask backend is not reachable"
    });
  }
});

app.get("/", (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>AWS DevOps Assignment</title>
      <style>
        body { font-family: Arial, sans-serif; max-width: 700px;
               margin: 60px auto; padding: 20px; background: #f4f7fb; }
        main { background: white; padding: 28px; border-radius: 12px; }
        button { padding: 10px 16px; cursor: pointer; }
        #result { margin-top: 20px; }
      </style>
    </head>
    <body>
      <main>
        <h1>AWS DevOps Assignment</h1>
        <p>Express Frontend + Flask Backend</p>
        <button onclick="checkBackend()">Check Backend Health</button>
        <p id="result">Click the button to test the Flask API.</p>
      </main>
      <script>
        async function checkBackend() {
          const result = document.getElementById("result");
          result.textContent = "Checking backend...";
          try {
            const response = await fetch("/api/health");
            const data = await response.json();
            result.textContent = "Backend response: " + JSON.stringify(data);
          } catch (error) {
            result.textContent = "Could not connect to backend.";
          }
        }
      </script>
    </body>
    </html>
  `);
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Express frontend running on http://localhost:${PORT}`);
});
