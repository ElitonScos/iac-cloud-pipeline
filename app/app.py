import json
from http.server import BaseHTTPRequestHandler, HTTPServer

PORT = 8080


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path in ("/health", "/healthz"):
            body = {"status": "ok"}
        else:
            body = {"app": "vaultapi", "msg": "iac-cloud-pipeline demo"}
        payload = json.dumps(body).encode()
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(payload)))
        self.end_headers()
        self.wfile.write(payload)

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    print(f"vaultapi demo listening on port {PORT}")
    HTTPServer(("0.0.0.0", PORT), Handler).serve_forever()
