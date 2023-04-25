from http.server import HTTPSERVER, BaseHTTPRequestHandler

class helloHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_nandler('content-type','text/html')
        self.end_headers()
        self.wfile.write('Hello Luxor!'.encode())

HOST = 73.247.245.12
PORT = 9999

def main():
    PORT = 8000
    server = HTTPServer((HOST,PORT), helloHandler)
    print ('Server running on port %s' % PORT)
    server.server_forever()
    server.server_close()
    print("Server stopped!")



    if __name__ == '_main_':
        main()