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
  info "Homebrew gefunden — installiere über Homebrew..."
  brew install ollama
  brew services start ollama
  success "Ollama installiert und als Dienst gestartet."
  echo ""
  echo -e "  Dienst-Management:"
  echo -e "  ${BOLD}brew services start ollama${RESET}   — starten"
  echo -e "  ${BOLD}brew services stop ollama${RESET}    — stoppen"
  echo -e "  ${BOLD}brew services restart ollama${RESET} — neustarten"
else
  info "Installiere Ollama via offiziellem Installer..."
  curl -fsSL https://ollama.com/install.sh | sh
  success "Ollama installiert."
  echo ""
  echo -e "  Starten: ${BOLD}ollama serve${RESET} oder Ollama-App aus Programme öffnen."
fi

echo ""
success "Fertig! Starte jetzt ein Modell:"
echo -e "  ${BOLD}ollama run qwen3:8b${RESET}"
echo ""
echo -e "  Oder nutze den interaktiven Installer:"
echo -e "  ${BOLD}bash scripts/install.sh${RESET}"
echo ""
