# Installing Ollama — GUI & CLI

Ollama is the foundation: it downloads models, manages them, and exposes a
local API. Everything else — chat interfaces, scripts, custom agents — builds
on top of it.

---

## Option A — GUI App (recommended for most users)

The official app is the easiest path. It automatically installs the `ollama`
command in Terminal and runs as a menu bar app in the background.

### Steps

1. Go to **[ollama.com/download](https://ollama.com/download)**
2. Click **"Download for macOS"**
3. Open the downloaded `.zip` — `Ollama.app` extracts automatically
4. Drag `Ollama.app` to your **Applications** folder
5. Launch the app — a setup wizard appears on first run

### What happens on first launch

- Ollama asks to install the `ollama` command into your Terminal PATH →
  confirm **"Install Command Line Tools"**
- A small llama icon appears in the menu bar — Ollama is running in the
  background and ready
- The API server starts automatically on `http://localhost:11434`

### Menu bar app

| Action | How |
|--------|-----|
| Start Ollama | Open app from Applications |
| Check status | Llama icon in menu bar |
| Quit | Llama icon → "Quit Ollama" |
| Auto-start | Starts at login by default |

---

## Option B — Homebrew (recommended for developers)

If you already use Homebrew, one command does it all:

```bash
# Install the full GUI app (recommended):
brew install --cask ollama

# Or install CLI-only (no menu bar app):
brew install ollama
brew services start ollama
```

> **Note:** The Homebrew Cask installs the same GUI app as the DMG download.
> Update later with `brew upgrade --cask ollama`.

---

## CLI essentials

Once installed, the `ollama` command is available in Terminal:

```bash
# Check version
ollama --version

# Download a model (without starting it)
ollama pull qwen3:8b

# Download and run a model immediately
ollama run qwen3:8b

# Exit a running model session
/bye

# List all installed models
ollama list

# Remove a model
ollama rm qwen3:8b

# Check API status
curl http://localhost:11434
```

---

## Open WebUI — Browser chat interface

The command line works fine for testing, but for daily use **Open WebUI** is
far more comfortable: it's a ChatGPT-style interface that runs entirely on
your local Ollama models.

**What Open WebUI offers:**
- Full chat interface like ChatGPT
- Conversation history
- Switch between multiple models
- File upload (PDFs, images)
- No account, no cloud — everything local

### Install with Docker (easiest method)

Requires [Docker Desktop](https://www.docker.com/products/docker-desktop) to
be installed and running.

```bash
docker run -d \
  -p 3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main
```

Then open: **http://localhost:3000**

On first visit, create a local admin account (stays local, no real account
needed). Open WebUI auto-detects Ollama and shows all installed models.

### Automated install

```bash
bash scripts/install-open-webui.sh
```

---

## Updating Ollama

```bash
# GUI app: Llama icon in menu bar → "Check for Updates"
# or re-download from ollama.com/download

# Homebrew Cask:
brew upgrade --cask ollama
```

---

## Next step

→ [Understanding Qwen3 models](02-qwen-models.md)
