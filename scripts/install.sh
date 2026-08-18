#!/usr/bin/env bash
# ============================================================
# localLLM — Interactive installer for Ollama + Qwen on Mac
# Usage: bash scripts/install.sh
# ============================================================

set -euo pipefail

# ── Colors ──────────────────────────────────────────────────
BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
RESET='\033[0m'

# ── Helpers ─────────────────────────────────────────────────
info()    { echo -e "${BLUE}▶${RESET}  $*"; }
success() { echo -e "${GREEN}✓${RESET}  $*"; }
warn()    { echo -e "${YELLOW}⚠${RESET}  $*"; }
error()   { echo -e "${RED}✗${RESET}  $*"; exit 1; }
header()  { echo -e "\n${BOLD}$*${RESET}"; echo "────────────────────────────────────"; }

# ── Platform check ──────────────────────────────────────────
if [[ "$(uname)" != "Darwin" ]]; then
  error "This script only runs on macOS."
fi

# ── Detect RAM ──────────────────────────────────────────────
RAM_BYTES=$(sysctl -n hw.memsize)
RAM_GB=$(( RAM_BYTES / 1073741824 ))

# ── Detect chip architecture ─────────────────────────────────
ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
  CHIP_INFO="Apple Silicon (ARM)"
else
  CHIP_INFO="Intel"
fi

# ── Header ──────────────────────────────────────────────────
echo ""
echo -e "${BOLD}╔══════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║     Local LLM Installer — Ollama + Qwen  ║${RESET}"
echo -e "${BOLD}╚══════════════════════════════════════════╝${RESET}"
echo ""
echo -e "  Mac:   ${CHIP_INFO}"
echo -e "  RAM:   ${BOLD}${RAM_GB} GB${RESET}"
echo ""

# ── Model recommendation based on RAM ───────────────────────
header "Recommendation for your Mac"

if [[ $RAM_GB -le 8 ]]; then
  RECOMMENDED_MODEL="qwen3:1.7b"
  RECOMMENDED_SIZE="1.4 GB"
  RECOMMENDED_RAM="~2 GB"
  RECOMMENDED_NOTE="Good for chat, text summaries, and simple tasks."
  warn "8 GB RAM — limited options. Qwen3-4B is possible but tight."

elif [[ $RAM_GB -le 12 ]]; then
  RECOMMENDED_MODEL="qwen3:4b"
  RECOMMENDED_SIZE="2.5 GB"
  RECOMMENDED_RAM="~3 GB"
  RECOMMENDED_NOTE="Excellent quality/size ratio. Fast and versatile."

elif [[ $RAM_GB -le 20 ]]; then
  RECOMMENDED_MODEL="qwen3:8b"
  RECOMMENDED_SIZE="5.2 GB"
  RECOMMENDED_RAM="~6 GB"
  RECOMMENDED_NOTE="Sweet spot for 16 GB Macs. Great for code, chat, and analysis."

elif [[ $RAM_GB -le 28 ]]; then
  RECOMMENDED_MODEL="qwen3:14b"
  RECOMMENDED_SIZE="9.3 GB"
  RECOMMENDED_RAM="~10 GB"
  RECOMMENDED_NOTE="Excellent quality. Especially strong with /think mode."

elif [[ $RAM_GB -le 48 ]]; then
  RECOMMENDED_MODEL="qwen3:30b-a3b"
  RECOMMENDED_SIZE="19 GB"
  RECOMMENDED_RAM="~20 GB"
  RECOMMENDED_NOTE="MoE model: 30B quality at 3B inference speed. Hidden gem."

else
  RECOMMENDED_MODEL="qwen3:32b"
  RECOMMENDED_SIZE="20 GB"
  RECOMMENDED_RAM="~22 GB"
  RECOMMENDED_NOTE="Dense flagship for large Macs. Or qwen3:235b-a22b for 192 GB+."
fi

echo -e "  Model:  ${BOLD}${RECOMMENDED_MODEL}${RESET}"
echo -e "  Size:   ${RECOMMENDED_SIZE} download / ${RECOMMENDED_RAM} RAM"
echo -e "  Note:   ${RECOMMENDED_NOTE}"
echo ""

# ── Model selection ──────────────────────────────────────────
header "Select a model"
echo "  All available Qwen3 models:"
echo ""
echo "  1)  qwen3:0.6b    —   523 MB,  ~1 GB RAM   (Minimal)"
echo "  2)  qwen3:1.7b    —   1.4 GB,  ~2 GB RAM   (Small)"
echo "  3)  qwen3:4b      —   2.5 GB,  ~3 GB RAM   (Compact, very good)"
echo "  4)  qwen3:8b      —   5.2 GB,  ~6 GB RAM   (Standard)"
echo "  5)  qwen3:14b     —   9.3 GB, ~10 GB RAM   (Strong)"
echo "  6)  qwen3:30b-a3b —    19 GB, ~20 GB RAM   (MoE, recommended for 32 GB+)"
echo "  7)  qwen3:32b     —    20 GB, ~22 GB RAM   (Dense flagship)"
echo ""
echo -e "  Recommended for your Mac: ${BOLD}${RECOMMENDED_MODEL}${RESET}"
echo ""
read -rp "  Enter choice (1-7) or press Enter for recommendation: " CHOICE

case "$CHOICE" in
  1) MODEL="qwen3:0.6b"     ;;
  2) MODEL="qwen3:1.7b"     ;;
  3) MODEL="qwen3:4b"       ;;
  4) MODEL="qwen3:8b"       ;;
  5) MODEL="qwen3:14b"      ;;
  6) MODEL="qwen3:30b-a3b"  ;;
  7) MODEL="qwen3:32b"      ;;
  *) MODEL="$RECOMMENDED_MODEL" ;;
esac

echo ""
info "Selected model: ${BOLD}${MODEL}${RESET}"

# ── Step 1: Install Ollama ───────────────────────────────────
header "Step 1: Install Ollama"

if command -v ollama &>/dev/null; then
  OLLAMA_VERSION=$(ollama --version 2>/dev/null | head -1)
  success "Ollama is already installed: ${OLLAMA_VERSION}"
else
  info "Installing Ollama..."

  if command -v brew &>/dev/null; then
    info "Homebrew found — installing Ollama App via Homebrew Cask..."
    brew install --cask ollama
    success "Ollama App installed."
    info "Launching Ollama..."
    open -a Ollama 2>/dev/null || open /Applications/Ollama.app 2>/dev/null || true
    info "Waiting 5 seconds for Ollama to start..."
    sleep 5
  else
    warn "Homebrew is not installed."
    echo ""
    echo "  Option 1 (recommended): Install Homebrew first:"
    echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    echo "  Then re-run: bash scripts/install.sh"
    echo ""
    echo "  Option 2: Download Ollama App manually:"
    echo "  https://ollama.com/download"
    echo ""
    info "Opening download page in browser..."
    open "https://ollama.com/download"
    echo ""
    read -rp "  Press Enter once Ollama is installed and running..." _
  fi
fi

# ── Check Ollama is running ──────────────────────────────────
info "Checking if Ollama is running..."

if ! curl -sf http://localhost:11434 &>/dev/null; then
  info "Starting Ollama in the background..."
  ollama serve &>/dev/null &
  sleep 3

  if curl -sf http://localhost:11434 &>/dev/null; then
    success "Ollama is running at http://localhost:11434"
  else
    warn "Could not start Ollama automatically."
    warn "Please launch the Ollama App from your Applications folder."
    echo ""
    read -rp "  Press Enter once Ollama is running..." _
  fi
else
  success "Ollama is already running at http://localhost:11434"
fi

# ── Step 2: Pull the Qwen model ──────────────────────────────
header "Step 2: Download ${MODEL}"

if ollama list 2>/dev/null | grep -q "${MODEL}"; then
  success "${MODEL} is already installed."
else
  info "Downloading ${MODEL} — this may take a few minutes depending on your connection..."
  ollama pull "$MODEL"
  success "${MODEL} installed successfully."
fi

# ── Step 3: Open WebUI (optional) ────────────────────────────
header "Step 3: Open WebUI (optional)"
echo "  Open WebUI is a ChatGPT-style browser interface for your local models."
echo "  Requires: Docker Desktop must be installed and running."
echo ""
read -rp "  Install Open WebUI? (y/N): " INSTALL_WEBUI

if [[ "$INSTALL_WEBUI" =~ ^[yY]$ ]]; then
  bash "$(dirname "$0")/install-open-webui.sh"
fi

# ── Done ─────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}╔══════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║           Installation complete!         ║${RESET}"
echo -e "${BOLD}╚══════════════════════════════════════════╝${RESET}"
echo ""
echo -e "  Start your model:"
echo -e "  ${BOLD}ollama run ${MODEL}${RESET}"
echo ""
echo -e "  Useful commands:"
echo -e "  ${BOLD}ollama list${RESET}           — show installed models"
echo -e "  ${BOLD}ollama pull qwen3:Xb${RESET}  — download another model"
echo -e "  ${BOLD}ollama rm qwen3:Xb${RESET}    — remove a model"
echo ""
if [[ "$INSTALL_WEBUI" =~ ^[yY]$ ]]; then
  echo -e "  Chat interface: ${BOLD}http://localhost:3000${RESET}"
  echo ""
fi
echo -e "  Tip: Prefix your prompt with ${BOLD}/think${RESET} to activate"
echo -e "  Thinking mode for more thorough reasoning."
echo ""
