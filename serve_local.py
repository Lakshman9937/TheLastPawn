import http.server
import socketserver
import os
import sys

PORT = 5500
DIRECTORY = os.path.dirname(os.path.abspath(__file__))

class CleanURLHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def do_GET(self):
        # Support clean URLs like /about -> /about.html
        path = self.path.split('?')[0].split('#')[0]
        if path != '/' and not os.path.splitext(path)[1]:
            html_candidate = os.path.join(DIRECTORY, path.lstrip('/\\') + '.html')
            if os.path.isfile(html_candidate):
                query = ('?' + self.path.split('?', 1)[1]) if '?' in self.path else ''
                self.path = path + '.html' + query
        return super().do_GET()

    def end_headers(self):
        self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate')
        super().end_headers()

    def log_message(self, format, *args):
        # Suppress verbose log spam
        pass

if __name__ == '__main__':
    socketserver.TCPServer.allow_reuse_address = True
    with socketserver.TCPServer(("", PORT), CleanURLHandler) as httpd:
        print(f"Server started on http://localhost:{PORT}")
        sys.stdout.flush()
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            pass
