import http.server
import socketserver
import webbrowser
import os

# --- Impostazioni ---
PORT = 8000
FILENAME = "visualizzation.html"
# --------------------

# Controlla se il file HTML esiste nella cartella corrente
if not os.path.exists(FILENAME):
    print(f"Errore: Il file '{FILENAME}' non è stato trovato in questa cartella.")
    print("Assicurati di eseguire lo script nella stessa directory del tuo file HTML.")
    input("Premi Invio per uscire.")
    exit()

# Configura il server per servire i file dalla cartella corrente
Handler = http.server.SimpleHTTPRequestHandler
httpd = socketserver.TCPServer(("", PORT), Handler)

# Costruisci l'URL completo
full_url = f"http://localhost:{PORT}/{FILENAME}"

print("-----------------------------------------")
print(f" Server in avvio su {full_url}")
print("-----------------------------------------")
print("Usa Ctrl+C nel terminale per fermare il server.")

try:
    # Apre il browser web all'URL specificato
    webbrowser.open(full_url)
    
    # Avvia il server
    httpd.serve_forever()

except KeyboardInterrupt:
    print("\n✅ Server fermato correttamente.")
    httpd.shutdown()