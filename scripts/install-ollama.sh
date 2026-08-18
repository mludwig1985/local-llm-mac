#!/usr/bin/env bash
# ============================================================
# Nur Ollama installieren (ohne Modell-Download)
# Verwendung: bash scripts/install-ollama.sh
# ============================================================

set -euo pipefail

GREEN='\033[0;32m'; BLUE='\033[0;34m'; BOLD='\033[1m'; RESET='\033[0m'
info()    { echo -e "${BLUE}▶${RESET}  $*"; }
success() { echo -e "${GREEN}✓${RESET}  $*"; }

if [[ "$(uname)" != "Darwin" ]]; then
  echo "Dieses Skript läuft nur auf macOS." && exit 1
fi

echo -e "\n${BOLD}Ollama installieren${RESET}"
echo "──────────────────────────────────"

if command -v ollama &>/dev/null; then
  success "Ollama ist bereits installiert: $(ollama --version | head -1)"
  exit 0
fi

if command -v brew &>/dev/null; then
  info "Homebrew gefunden — installiere Ollama App via Homebrew Cask..."
  brew install --cask ollama
  success "Ollama App installiert."
  info "Starte Ollama..."
  open -a Ollama 2>/dev/null || open /Applications/Ollama.app 2>/dev/null || true
  echo ""
  echo -e "  Update später: ${BOLD}brew upgrade --cask ollama${RESET}"
else
  warn "Homebrew nicht gefunden."
  echo ""
  echo -e "  Homebrew installieren (empfohlen):"
  echo -e '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  echo -e "  Danach: ${BOLD}bash scripts/install-ollama.sh${RESET}"
  echo ""
  echo -e "  Oder Ollama App direkt herunterladen: https://ollama.com/download"
  info "Öffne Download-Seite im Browser..."
  open "https://ollama.com/download"
fi

echo ""
success "Fertig! Starte jetzt ein Modell:"
echo -e "  ${BOLD}ollama run qwen3:8b${RESET}"
echo ""
echo -e "  Oder nutze den interaktiven Installer:"
echo -e "  ${BOLD}bash scripts/install.sh${RESET}"
echo ""
