#!/usr/bin/env bash
# ============================================================
# localLLM — Interaktiver Installer für Ollama + Qwen auf Mac
# Verwendung: bash scripts/install.sh
# ============================================================

set -euo pipefail

# ── Farben ──────────────────────────────────────────────────
BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
RESET='\033[0m'

# ── Hilfsfunktionen ─────────────────────────────────────────
info()    { echo -e "${BLUE}▶${RESET}  $*"; }
success() { echo -e "${GREEN}✓${RESET}  $*"; }
warn()    { echo -e "${YELLOW}⚠${RESET}  $*"; }
error()   { echo -e "${RED}✗${RESET}  $*"; exit 1; }
header()  { echo -e "\n${BOLD}$*${RESET}"; echo "────────────────────────────────────"; }

# ── Plattform prüfen ────────────────────────────────────────
if [[ "$(uname)" != "Darwin" ]]; then
  error "Dieses Skript läuft nur auf macOS."
fi

# ── RAM ermitteln ────────────────────────────────────────────
RAM_BYTES=$(sysctl -n hw.memsize)
RAM_GB=$(( RAM_BYTES / 1073741824 ))

# ── Chip-Architektur ─────────────────────────────────────────
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

# ── Modell-Empfehlung basierend auf RAM ──────────────────────
header "Empfehlung für deinen Mac"

if [[ $RAM_GB -le 8 ]]; then
  RECOMMENDED_MODEL="qwen3:1.7b"
  RECOMMENDED_SIZE="1,4 GB"
  RECOMMENDED_RAM="~2 GB"
  RECOMMENDED_NOTE="Geeignet für Chat, Textzusammenfassungen, einfache Aufgaben."
  warn "8 GB RAM — eingeschränkte Auswahl. Qwen3-4B ist möglich aber eng."

elif [[ $RAM_GB -le 12 ]]; then
  RECOMMENDED_MODEL="qwen3:4b"
  RECOMMENDED_SIZE="2,5 GB"
  RECOMMENDED_RAM="~3 GB"
  RECOMMENDED_NOTE="Exzellentes Qualitäts-/Größen-Verhältnis. Schnell und vielseitig."

elif [[ $RAM_GB -le 20 ]]; then
  RECOMMENDED_MODEL="qwen3:8b"
  RECOMMENDED_SIZE="5,2 GB"
  RECOMMENDED_RAM="~6 GB"
  RECOMMENDED_NOTE="Sweet Spot für 16 GB Macs. Stark für Code, Chat und Analysen."

elif [[ $RAM_GB -le 28 ]]; then
  RECOMMENDED_MODEL="qwen3:14b"
  RECOMMENDED_SIZE="9,3 GB"
  RECOMMENDED_RAM="~10 GB"
  RECOMMENDED_NOTE="Hervorragende Qualität. Besonders stark mit /think-Modus."

elif [[ $RAM_GB -le 48 ]]; then
  RECOMMENDED_MODEL="qwen3:30b-a3b"
  RECOMMENDED_SIZE="19 GB"
  RECOMMENDED_RAM="~20 GB"
  RECOMMENDED_NOTE="MoE-Modell: Qualität eines 30B-Modells, Geschwindigkeit eines 3B-Modells."

else
  RECOMMENDED_MODEL="qwen3:32b"
  RECOMMENDED_SIZE="20 GB"
  RECOMMENDED_RAM="~22 GB"
  RECOMMENDED_NOTE="Dense-Flaggschiff für große Macs. Oder qwen3:235b-a22b für 192 GB+."
fi

echo -e "  Modell:  ${BOLD}${RECOMMENDED_MODEL}${RESET}"
echo -e "  Größe:   ${RECOMMENDED_SIZE} Download / ${RECOMMENDED_RAM} RAM"
echo -e "  Hinweis: ${RECOMMENDED_NOTE}"
echo ""

# ── Modell-Auswahl bestätigen oder ändern ────────────────────
header "Modell auswählen"
echo "  Alle verfügbaren Qwen3-Modelle:"
echo ""
echo "  1)  qwen3:0.6b   —  523 MB,  ~1 GB RAM   (Minimal)"
echo "  2)  qwen3:1.7b   —  1,4 GB,  ~2 GB RAM   (Klein)"
echo "  3)  qwen3:4b     —  2,5 GB,  ~3 GB RAM   (Kompakt, sehr gut)"
echo "  4)  qwen3:8b     —  5,2 GB,  ~6 GB RAM   (Standard)"
echo "  5)  qwen3:14b    —  9,3 GB, ~10 GB RAM   (Stark)"
echo "  6)  qwen3:30b-a3b — 19 GB,  ~20 GB RAM   (MoE, empfohlen für 32 GB+)"
echo "  7)  qwen3:32b    —   20 GB, ~22 GB RAM   (Dense-Flaggschiff)"
echo ""
echo -e "  Empfehlung für deinen Mac: ${BOLD}${RECOMMENDED_MODEL}${RESET}"
echo ""
read -rp "  Wahl eingeben (1-7) oder Enter für Empfehlung: " CHOICE

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
info "Gewähltes Modell: ${BOLD}${MODEL}${RESET}"

# ── Schritt 1: Ollama installieren ───────────────────────────
header "Schritt 1: Ollama installieren"

if command -v ollama &>/dev/null; then
  OLLAMA_VERSION=$(ollama --version 2>/dev/null | head -1)
  success "Ollama ist bereits installiert: ${OLLAMA_VERSION}"
else
  info "Ollama wird installiert..."

  if command -v brew &>/dev/null; then
    info "Homebrew gefunden — installiere über Homebrew..."
    brew install ollama
    brew services start ollama
    success "Ollama via Homebrew installiert und gestartet."
  else
    info "Installiere Ollama via offiziellem Installer..."
    curl -fsSL https://ollama.com/install.sh | sh
    success "Ollama installiert."
  fi
fi

# ── Ollama-Dienst starten ────────────────────────────────────
info "Prüfe ob Ollama läuft..."

if ! curl -sf http://localhost:11434 &>/dev/null; then
  info "Starte Ollama im Hintergrund..."
  ollama serve &>/dev/null &
  sleep 3

  if curl -sf http://localhost:11434 &>/dev/null; then
    success "Ollama läuft auf http://localhost:11434"
  else
    warn "Ollama konnte nicht automatisch gestartet werden."
    warn "Bitte starte die Ollama-App manuell aus dem Programme-Ordner."
    echo ""
    read -rp "  Drücke Enter sobald Ollama läuft..." _
  fi
else
  success "Ollama läuft bereits auf http://localhost:11434"
fi

# ── Schritt 2: Qwen-Modell herunterladen ────────────────────
header "Schritt 2: ${MODEL} herunterladen"

if ollama list 2>/dev/null | grep -q "^${MODEL%%:*}"; then
  if ollama list 2>/dev/null | grep -q "${MODEL}"; then
    success "${MODEL} ist bereits installiert."
  else
    info "Lade ${MODEL} herunter..."
    ollama pull "$MODEL"
    success "${MODEL} erfolgreich installiert."
  fi
else
  info "Lade ${MODEL} herunter (das kann je nach Verbindung einige Minuten dauern)..."
  ollama pull "$MODEL"
  success "${MODEL} erfolgreich installiert."
fi

# ── Schritt 3: Open WebUI (optional) ────────────────────────
header "Schritt 3: Open WebUI (optional)"
echo "  Open WebUI ist eine ChatGPT-ähnliche Oberfläche für deine lokalen Modelle."
echo "  Voraussetzung: Docker Desktop muss installiert und gestartet sein."
echo ""
read -rp "  Open WebUI installieren? (j/N): " INSTALL_WEBUI

if [[ "$INSTALL_WEBUI" =~ ^[jJyY]$ ]]; then
  bash "$(dirname "$0")/install-open-webui.sh"
fi

# ── Fertig ───────────────────────────────────────────────────
echo ""
echo -e "${BOLD}╔══════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║              Installation fertig!        ║${RESET}"
echo -e "${BOLD}╚══════════════════════════════════════════╝${RESET}"
echo ""
echo -e "  Modell starten:"
echo -e "  ${BOLD}ollama run ${MODEL}${RESET}"
echo ""
echo -e "  Nützliche Befehle:"
echo -e "  ${BOLD}ollama list${RESET}           — installierte Modelle"
echo -e "  ${BOLD}ollama pull qwen3:Xb${RESET}  — weiteres Modell laden"
echo -e "  ${BOLD}ollama rm qwen3:Xb${RESET}    — Modell entfernen"
echo ""
if [[ "$INSTALL_WEBUI" =~ ^[jJyY]$ ]]; then
  echo -e "  Chat-Oberfläche: ${BOLD}http://localhost:3000${RESET}"
  echo ""
fi
echo -e "  Tipp: Mit ${BOLD}/think${RESET} vor deiner Frage aktivierst du den"
echo -e "  Thinking-Modus für komplexere Analysen."
echo ""
