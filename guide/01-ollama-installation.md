# Ollama installieren — GUI & CLI

Ollama ist das Fundament: Es lädt Modelle herunter, verwaltet sie und stellt
eine lokale API bereit. Alles andere (Chat-Oberflächen, Skripte, eigene
Agenten) baut darauf auf.

---

## Option A — GUI-App (empfohlen für Einsteiger)

Die offiziellen App ist der einfachste Weg. Sie installiert automatisch den
`ollama`-Befehl im Terminal und läuft als Menu-Bar-App im Hintergrund.

### Schritte

1. Gehe zu **[ollama.com/download](https://ollama.com/download)**
2. Klicke **"Download for macOS"**
3. Die heruntergeladene `.zip`-Datei öffnen → `Ollama.app` extrahiert sich
4. `Ollama.app` in den **Programme**-Ordner ziehen
5. App starten — beim ersten Start erscheint ein Einrichtungsassistent

### Was passiert beim ersten Start

- Ollama fragt, ob es den `ollama`-Befehl in den Terminal-PATH installieren
  darf → **"Install Command Line Tools"** bestätigen
- Ein kleines Lama-Icon erscheint in der Menüleiste — das zeigt, dass
  Ollama im Hintergrund läuft und bereit ist
- Der API-Server startet automatisch auf `http://localhost:11434`

### Menu-Bar-App nutzen

| Aktion | Weg |
|--------|-----|
| Ollama starten | App aus Programme öffnen |
| Status prüfen | Lama-Icon in Menüleiste |
| Beenden | Lama-Icon → "Quit Ollama" |
| Autostart | Läuft automatisch beim Login (Standard) |

---

## Option B — Homebrew (empfohlen für Entwickler)

Für alle die Homebrew bereits nutzen — ein Befehl genügt:

```bash
brew install ollama
```

Nach der Installation als Dienst starten:

```bash
brew services start ollama
```

> **Hinweis:** Die Homebrew-Version enthält keine GUI-App, nur die
> Kommandozeile. Dafür lässt sie sich einfach updaten: `brew upgrade ollama`.

---

## CLI-Grundbefehle

Nach der Installation steht der `ollama`-Befehl im Terminal zur Verfügung:

```bash
# Version prüfen
ollama --version

# Modell herunterladen (ohne zu starten)
ollama pull qwen3:8b

# Modell herunterladen und direkt starten
ollama run qwen3:8b

# Laufendes Modell beenden
/bye

# Alle installierten Modelle anzeigen
ollama list

# Modell entfernen
ollama rm qwen3:8b

# API-Status prüfen
curl http://localhost:11434
```

---

## Open WebUI — Chat-Oberfläche im Browser

Die Kommandozeile reicht zum Testen, aber für den täglichen Gebrauch ist
**Open WebUI** deutlich komfortabler: Es ist eine ChatGPT-ähnliche
Oberfläche, die direkt auf deinen lokalen Ollama-Modellen läuft.

**Was Open WebUI bietet:**
- Chat-Oberfläche wie ChatGPT
- Gesprächshistorie
- Mehrere Modelle gleichzeitig verfügbar
- Datei-Upload (PDFs, Bilder)
- Kein Account, keine Cloud, alles lokal

### Installation mit Docker (einfachste Methode)

Voraussetzung: [Docker Desktop](https://www.docker.com/products/docker-desktop)
ist installiert und läuft.

```bash
docker run -d \
  -p 3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main
```

Danach im Browser: **http://localhost:3000**

Beim ersten Aufruf einen Admin-Account anlegen (bleibt lokal, kein echter
Account). Open WebUI erkennt Ollama automatisch und zeigt alle installierten
Modelle.

### Automatische Installation

```bash
bash scripts/install-open-webui.sh
```

---

## Ollama updaten

```bash
# GUI-App: Im Menüleisten-Icon → "Check for Updates"
# oder manuell neu von ollama.com/download herunterladen

# Homebrew:
brew upgrade ollama
```

---

## Nächster Schritt

→ [Qwen-Modelle verstehen](02-qwen-models.md)
