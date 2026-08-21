<p align="center">
  <img src="header.jpg" alt="Qwen + Ollama on Mac" width="700">
</p>

# Local LLM on Mac — Ollama + Qwen3 Setup Guide

> **Run powerful AI models locally on your Mac — no cloud, no API costs, no data leaving your device.**

A complete guide and automated installer for running [Qwen3](https://ollama.com/library/qwen3) models locally on macOS via [Ollama](https://ollama.com). Includes step-by-step documentation, Mac-specific model recommendations, and shell scripts that handle everything automatically.

---

## What you get

- **Qwen3 running locally** — state-of-the-art open-weight model from Alibaba
- **Ollama** — the easiest way to run LLMs on Mac (menu bar app + CLI)
- **Open WebUI** — a ChatGPT-style browser interface for your local models
- **Zero ongoing costs** — no subscription, no API key, no rate limits

---

## Quick Start

```bash
# Clone the repo
git clone https://github.com/mludwig1985/local-llm-mac.git
cd local-llm-mac

# Run the interactive installer
# → detects your Mac's RAM, recommends the right model, installs everything
bash scripts/install.sh
```

That's it. The script detects how much RAM your Mac has, recommends the right Qwen3 model, installs Ollama, and pulls the model. You'll be chatting with a local AI in minutes.

---

## Which Qwen3 model runs on which Mac?

| Mac | RAM | Recommended Model | Command |
|-----|-----|-------------------|---------|
| MacBook Air M1/M2/M3/M4 | 8 GB | Qwen3-1.7B | `ollama run qwen3:1.7b` |
| MacBook Air M1/M2/M3 | 16 GB | Qwen3-8B | `ollama run qwen3:8b` |
| MacBook Pro M2/M3/M4 | 16 GB | **Qwen3-8B** ⭐ | `ollama run qwen3:8b` |
| MacBook Pro M3/M4 Pro | 24 GB | **Qwen3-14B** ⭐ | `ollama run qwen3:14b` |
| MacBook Pro M3/M4 Pro | 48 GB | **Qwen3-30B-A3B** ⭐ | `ollama run qwen3:30b-a3b` |
| MacBook Pro M3/M4 Max | 36–48 GB | Qwen3-30B-A3B | `ollama run qwen3:30b-a3b` |
| MacBook Pro M3/M4 Max | 64–128 GB | **Qwen3-32B Q8** ⭐ | `ollama run qwen3:32b-q8_0` |
| Mac Mini M4 | 16–24 GB | Qwen3-8B | `ollama run qwen3:8b` |
| Mac Mini M4 Pro | 24–48 GB | Qwen3-30B-A3B | `ollama run qwen3:30b-a3b` |
| Mac Studio M4 Max | 32–128 GB | Qwen3-32B Q8 | `ollama run qwen3:32b-q8_0` |
| Mac Studio / Mac Pro Ultra | 192 GB+ | Qwen3-235B-A22B | `ollama run qwen3:235b-a22b` |

> **Apple Silicon advantage:** Unified memory means RAM and GPU share the same pool — a 64 GB Mac outperforms a dedicated 24 GB GPU card for local AI inference.

> ⚠️ `qwen3:235b-a22b` requires ~144 GB RAM — it does **not** fit in 128 GB.

---

## Prerequisites

- **macOS 13 Ventura or newer**
- **Apple Silicon (M1–M5)** recommended — Intel Macs work but are significantly slower
- Free disk space: 1.4 GB (smallest model) up to 35 GB (32B Q8) — the installer tells you exactly how much
- Internet connection for the initial download

No Python, no conda, no virtual environments. Ollama handles everything.

---

## What's inside

```
local-llm-mac/
├── docs/
│   ├── 01-ollama-installation.md   # Ollama GUI app, CLI, Homebrew + Open WebUI
│   ├── 02-qwen-models.md           # All Qwen3 models, sizes, quantization explained
│   └── 03-mac-recommendations.md   # Detailed per-Mac model recommendations
└── scripts/
    ├── install.sh                  # Interactive all-in-one installer
    ├── install-ollama.sh           # Install Ollama only
    └── install-open-webui.sh       # Install Open WebUI (Docker required)
```

### Docs

| Guide | Contents |
|-------|----------|
| [01 — Ollama Installation](docs/01-ollama-installation.md) | GUI app vs CLI, Homebrew, Open WebUI setup, RAM management |
| [02 — Qwen3 Models](docs/02-qwen-models.md) | All model sizes, quantization, API usage, Thinking mode |
| [03 — Mac Recommendations](docs/03-mac-recommendations.md) | Per-Mac RAM guide, MoE vs Dense explained |

### Scripts

| Script | What it does |
|--------|--------------|
| `scripts/install.sh` | **Start here.** Detects RAM, recommends a model, installs Ollama + pulls model, optionally sets up Open WebUI |
| `scripts/install-ollama.sh` | Installs Ollama only (via Homebrew Cask if available, otherwise opens download page) |
| `scripts/install-open-webui.sh` | Installs Open WebUI via Docker for a ChatGPT-style browser interface |

---

## Qwen3: Why this model family?

Qwen3 is released under **Apache 2.0** — fully open, commercial use allowed.

- **Thinking mode** built in: prefix your prompt with `/think` for step-by-step reasoning (like OpenAI o1)
- **256K context window** on several models — useful for long documents and codebases
- **MoE architecture** on the 30B model: full 30B quality at 3B inference speed
- Strong benchmark scores across coding, math, multilingual, and reasoning tasks

---

## After installation

```bash
# Start a chat session
ollama run qwen3:8b

# Use Thinking mode for complex questions
/think Explain the difference between TCP and UDP in detail

# Disable Thinking for quick answers
/no_think What is the capital of France?

# Exit
/bye

# List installed models
ollama list

# Unload a model from RAM when done (keeps it installed)
ollama stop qwen3:8b
```

**Open WebUI** (if installed): open [http://localhost:3000](http://localhost:3000) in your browser for a full chat interface with conversation history, file uploads, and model switching.

---

## License

MIT — do whatever you want with it.

---

*Maintained by [Mathias Ludwig](https://mathias-ludwig.tech)*
