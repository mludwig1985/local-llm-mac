#!/usr/bin/env bash
# ============================================================
# Install Open WebUI (browser chat interface for Ollama)
# Requires: Docker Desktop must be running
# Usage: bash scripts/install-open-webui.sh
# ============================================================

set -euo pipefail

GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'
BOLD='\033[1m'; RESET='\033[0m'
info()    { echo -e "${BLUE}▶${RESET}  $*"; }
success() { echo -e "${GREEN}✓${RESET}  $*"; }
warn()    { echo -e "${YELLOW}⚠${RESET}  $*"; }

echo ""
echo -e "${BOLD}Install Open WebUI${RESET}"
echo "──────────────────────────────────"

# Check Docker
if ! command -v docker &>/dev/null; then
  warn "Docker is not installed."
  echo ""
  echo "  Install Docker Desktop first:"
  echo "  https://www.docker.com/products/docker-desktop"
  echo ""
  echo "  Then re-run this script."
  exit 1
fi

if ! docker info &>/dev/null 2>&1; then
  warn "Docker is not running. Please start Docker Desktop."
  echo ""
  echo "  Open Docker Desktop and wait for the whale icon in the menu bar."
  echo "  Then re-run: bash scripts/install-open-webui.sh"
  exit 1
fi

success "Docker is running."

# Check Ollama
if ! curl -sf http://localhost:11434 &>/dev/null; then
  warn "Ollama is not running at localhost:11434."
  warn "Please start Ollama first, then install Open WebUI."
  exit 1
fi

success "Ollama is reachable."

# Already installed?
if docker ps -a --format '{{.Names}}' | grep -q "^open-webui$"; then
  if docker ps --format '{{.Names}}' | grep -q "^open-webui$"; then
    success "Open WebUI is already running at http://localhost:3000"
    exit 0
  else
    info "Open WebUI container exists but is not running — restarting..."
    docker start open-webui
    success "Open WebUI started."
    echo ""
    echo -e "  Open in browser: ${BOLD}http://localhost:3000${RESET}"
    exit 0
  fi
fi

# Install Open WebUI
info "Downloading Open WebUI (~1 GB) and starting container..."

docker run -d \
  -p 3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main

# Wait until reachable
info "Waiting for Open WebUI to start..."
for i in $(seq 1 30); do
  if curl -sf http://localhost:3000 &>/dev/null; then
    break
  fi
  sleep 2
done

echo ""
success "Open WebUI installed successfully!"
echo ""
echo -e "  Open in browser: ${BOLD}http://localhost:3000${RESET}"
echo ""
echo "  On first visit: create a local admin account."
echo "  (Stays completely local — no real account needed.)"
echo ""
echo -e "  Manage Open WebUI:"
echo -e "  ${BOLD}docker stop open-webui${RESET}    — stop"
echo -e "  ${BOLD}docker start open-webui${RESET}   — start"
echo -e "  ${BOLD}docker rm open-webui${RESET}      — remove"
echo ""

# Open browser
read -rp "  Open browser now? (Y/n): " OPEN_BROWSER
if [[ ! "$OPEN_BROWSER" =~ ^[nN]$ ]]; then
  open "http://localhost:3000"
fi
