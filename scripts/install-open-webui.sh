#!/usr/bin/env bash
# ============================================================
# Open WebUI installieren (Chat-Oberfläche für Ollama)
# Voraussetzung: Docker Desktop muss laufen
# Verwendung: bash scripts/install-open-webui.sh
# ============================================================

set -euo pipefail

GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'
BOLD='\033[1m'; RESET='\033[0m'
info()    { echo -e "${BLUE}▶${RESET}  $*"; }
success() { echo -e "${GREEN}✓${RESET}  $*"; }
warn()    { echo -e "${YELLOW}⚠${RESET}  $*"; }

echo ""
echo -e "${BOLD}Open WebUI installieren${RESET}"
echo "──────────────────────────────────"

# Docker prüfen
if ! command -v docker &>/dev/null; then
  warn "Docker ist nicht installiert."
  echo ""
  echo "  Bitte Docker Desktop installieren:"
  echo "  https://www.docker.com/products/docker-desktop"
  echo ""
  echo "  Danach dieses Skript erneut ausführen."
  exit 1
fi

if ! docker info &>/dev/null 2>&1; then
  warn "Docker läuft nicht. Bitte Docker Desktop starten."
  echo ""
  echo "  Docker Desktop öffnen → Warten bis der Wal-Icon in der Menüleiste erscheint."
  echo "  Dann erneut ausführen: bash scripts/install-open-webui.sh"
  exit 1
fi

success "Docker läuft."

# Ollama prüfen
if ! curl -sf http://localhost:11434 &>/dev/null; then
  warn "Ollama läuft nicht auf localhost:11434."
  warn "Bitte Ollama zuerst starten, dann Open WebUI installieren."
  exit 1
fi

success "Ollama ist erreichbar."

# Bereits installiert?
if docker ps -a --format '{{.Names}}' | grep -q "^open-webui$"; then
  if docker ps --format '{{.Names}}' | grep -q "^open-webui$"; then
    success "Open WebUI läuft bereits auf http://localhost:3000"
    exit 0
  else
    info "Open WebUI-Container existiert aber läuft nicht — starte neu..."
    docker start open-webui
    success "Open WebUI gestartet."
    echo ""
    echo -e "  Öffne im Browser: ${BOLD}http://localhost:3000${RESET}"
    exit 0
  fi
fi

# Open WebUI installieren
info "Lade Open WebUI herunter (~1 GB) und starte Container..."

docker run -d \
  -p 3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main

# Warten bis erreichbar
info "Warte auf Open WebUI..."
for i in $(seq 1 30); do
  if curl -sf http://localhost:3000 &>/dev/null; then
    break
  fi
  sleep 2
done

echo ""
success "Open WebUI erfolgreich installiert!"
echo ""
echo -e "  Öffne im Browser: ${BOLD}http://localhost:3000${RESET}"
echo ""
echo "  Beim ersten Aufruf einen lokalen Admin-Account anlegen."
echo "  (Bleibt komplett lokal — kein echter Account nötig.)"
echo ""
echo -e "  Open WebUI verwalten:"
echo -e "  ${BOLD}docker stop open-webui${RESET}    — stoppen"
echo -e "  ${BOLD}docker start open-webui${RESET}   — starten"
echo -e "  ${BOLD}docker rm open-webui${RESET}      — entfernen"
echo ""

# Browser öffnen
read -rp "  Browser jetzt öffnen? (J/n): " OPEN_BROWSER
if [[ ! "$OPEN_BROWSER" =~ ^[nN]$ ]]; then
  open "http://localhost:3000"
fi
