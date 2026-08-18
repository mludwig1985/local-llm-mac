#!/usr/bin/env bash
# ============================================================
# Install Ollama only (without pulling a model)
# Usage: bash scripts/install-ollama.sh
# ============================================================

set -euo pipefail

GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'
BOLD='\033[1m'; RESET='\033[0m'
info()    { echo -e "${BLUE}▶${RESET}  $*"; }
success() { echo -e "${GREEN}✓${RESET}  $*"; }
warn()    { echo -e "${YELLOW}⚠${RESET}  $*"; }

if [[ "$(uname)" != "Darwin" ]]; then
  echo "This script only runs on macOS." && exit 1
fi

echo -e "\n${BOLD}Install Ollama${RESET}"
echo "──────────────────────────────────"

if command -v ollama &>/dev/null; then
  success "Ollama is already installed: $(ollama --version | head -1)"
  exit 0
fi

if command -v brew &>/dev/null; then
  info "Homebrew found — installing Ollama App via Homebrew Cask..."
  brew install --cask ollama
  success "Ollama App installed."
  info "Launching Ollama..."
  open -a Ollama 2>/dev/null || open /Applications/Ollama.app 2>/dev/null || true
  echo ""
  echo -e "  Update later: ${BOLD}brew upgrade --cask ollama${RESET}"
else
  warn "Homebrew not found."
  echo ""
  echo -e "  Install Homebrew (recommended):"
  echo -e '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  echo -e "  Then re-run: ${BOLD}bash scripts/install-ollama.sh${RESET}"
  echo ""
  echo -e "  Or download Ollama App directly: https://ollama.com/download"
  info "Opening download page in browser..."
  open "https://ollama.com/download"
fi

echo ""
success "Done! Start a model with:"
echo -e "  ${BOLD}ollama run qwen3:8b${RESET}"
echo ""
echo -e "  Or use the interactive installer:"
echo -e "  ${BOLD}bash scripts/install.sh${RESET}"
echo ""
