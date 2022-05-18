from http.server import HTTPServer, BaseHTTPRequestHandler
import threading, os, json, asyncio, subprocess, json

APPS_ROOT = os.getenv('APPS_ROOT')

class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        destination = self.headers.get("x-alloverse-server")
        launchargs = self.headers.get("x-alloverse-launchargs") or "{}"
        app_name = self.path

        app_path = "." # by default, just launch current app
        if APPS_ROOT and app_name:
            # if serving many apps, pick the app based on root and given name
            app_path = APPS_ROOT+'/'+app_name

        print(f"Booting app {app_name or ''} into {destination}...")
        try:
            subprocess.Popen(
                ["./allo/assist", "run", destination, launchargs],
                cwd=app_path
            )
            # todo: reap it when it exits
            # pls somehow capture avatar id
            avatar_id = "unknown"
            self.send_response(200)
            self.end_headers()
            self.wfile.write(bytes(json.dumps({"status": "ok", "avatar_id": avatar_id}), "utf-8"))
        except Exception as e:
            error = f"Failed to boot app: {e}"
            self.send_response(502)
            self.end_headers()
            self.wfile.write(bytes(json.dumps({"error": error}), "utf-8"))

def start_server(handler, port=8000):
    '''Start a simple webserver serving path on port'''
    httpd = HTTPServer(('', port), handler)
    httpd.serve_forever()

def run_gateway_server(handler = Handler, port = 8000):
    # Start the server in a new thread
    daemon = threading.Thread(name='daemon_server', target=start_server, args=(handler, port))
    daemon.setDaemon(True) # Set as a daemon so it will be killed once the main thread is dead.
    daemon.start()
    return daemon

if __name__ == "__main__":
    print(f"Serving AlloApp(s) from {APPS_ROOT or 'current directory'}")
    run_gateway_server().join()
