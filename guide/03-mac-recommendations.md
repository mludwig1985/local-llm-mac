# Which Qwen3 Model for Which Mac?

Apple Silicon (M1–M5) uses Unified Memory: RAM and GPU share the same pool.
This makes Macs exceptionally good for local LLMs — a MacBook Pro with 32 GB
unified memory outperforms a dedicated Nvidia card with 16 GB VRAM.

---

## Quick reference

| Mac | RAM | Recommended | Command |
|-----|-----|-------------|---------|
| MacBook Air M1/M2/M3 | 8 GB | Qwen3-1.7B | `ollama run qwen3:1.7b` |
| MacBook Air M1/M2/M3 | 16 GB | Qwen3-4B | `ollama run qwen3:4b` |
| MacBook Pro M2/M3/M4 | 16 GB | **Qwen3-8B** ⭐ | `ollama run qwen3:8b` |
| MacBook Pro M3/M4 Pro | 18–24 GB | **Qwen3-14B** ⭐ | `ollama run qwen3:14b` |
| MacBook Pro M3/M4 Max | 36–128 GB | **Qwen3-30B-A3B** ⭐ | `ollama run qwen3:30b-a3b` |
| Mac Mini M4 | 16 GB | Qwen3-8B | `ollama run qwen3:8b` |
| Mac Mini M4 Pro | 24–32 GB | Qwen3-14B | `ollama run qwen3:14b` |
| Mac Studio M4 Max | 64–96 GB | Qwen3-32B | `ollama run qwen3:32b` |
| Mac Pro M2 Ultra | 192 GB | Qwen3-235B-A22B | `ollama run qwen3:235b-a22b` |

---

## Detailed recommendations

### MacBook Air M1 / M2 / M3 — 8 GB RAM

The entry-level 8 GB config is limited but usable.

**Recommended: `qwen3:1.7b`**

- Download: 1.4 GB — fits comfortably
- RAM usage: ~2 GB — leaves 6 GB for macOS
- Quality: Good for simple tasks, text summaries, chat

```bash
ollama run qwen3:1.7b
```

**Alternative: `qwen3:4b`** (if few other apps are open)
- RAM usage: ~3 GB — works, may occasionally slow down
- Noticeably better quality than 1.7B

> ⚠️ Qwen3-8B is not recommended on 8 GB — not enough buffer for macOS.

---

### MacBook Air M1 / M2 / M3 — 16 GB RAM

With 16 GB you have solid headroom.

**Recommended: `qwen3:4b`** (for speed)
**Alternative: `qwen3:8b`** (for better quality)

- Qwen3-4B: ~3 GB RAM, very fast, excellent quality/size ratio
- Qwen3-8B: ~6 GB RAM, significantly stronger, runs comfortably on 16 GB

```bash
# Fast and efficient:
ollama run qwen3:4b

# Best quality at 16 GB:
ollama run qwen3:8b
```

---

### MacBook Pro M2 / M3 / M4 — 16 GB RAM

With the powerful M-chip, Qwen3-8B runs very smoothly.

**Recommended: `qwen3:8b`**

- Download: 5.2 GB
- RAM usage: ~6 GB
- Speed: ~20–30 tokens/second
- Quality: Excellent for code, chat, analysis

```bash
ollama run qwen3:8b
```

---

### MacBook Pro M3 Pro / M4 Pro — 18–24 GB RAM

The sweet spot — enough RAM for a serious model with no compromises.

**Recommended: `qwen3:14b`**

- Download: 9.3 GB
- RAM usage: ~10 GB — leaves plenty for macOS and other apps
- Quality: Very strong, especially with `/think` mode for complex tasks

```bash
ollama run qwen3:14b
```

---

### MacBook Pro M3 Max / M4 Max — 36–128 GB RAM

**Recommended: `qwen3:30b-a3b`** (MoE — the hidden gem)

This MoE model activates only 3B parameters per request out of 30B total —
it runs at the speed of a small model while delivering the quality of a 30B+
dense model.

- Download: 19 GB
- RAM usage: ~20 GB
- Speed: ~15–20 tokens/second (despite 30B total size)
- Quality: Often outperforms dense models in the 32B range

```bash
# MoE model (recommended):
ollama run qwen3:30b-a3b

# Dense alternative:
ollama run qwen3:32b
```

---

### Mac Mini M4 — 16 GB RAM

Same recommendation as MacBook Pro 16 GB.

**Recommended: `qwen3:8b`**

The Mac Mini M4 is an excellent always-on local AI server — it draws only
~20W under load, making it ideal for 24/7 operation.

```bash
ollama run qwen3:8b
```

---

### Mac Mini M4 Pro — 24–32 GB RAM

**Recommended: `qwen3:14b`**

```bash
ollama run qwen3:14b
```

---

### Mac Studio M4 Max / M2 Ultra — 64–192 GB RAM

**Recommended: `qwen3:32b`** (64 GB) or **`qwen3:235b-a22b`** (192 GB)

```bash
# 64 GB RAM:
ollama run qwen3:32b

# 192 GB RAM (flagship model, competes with GPT-4):
ollama run qwen3:235b-a22b
```

---

## RAM rule of thumb

```
Available RAM for model = Total RAM - 4 GB (reserved for macOS)
Model fits when:   model file size × 1.2 ≤ available RAM
```

Example: 16 GB Mac
- Available: 16 - 4 = 12 GB
- Qwen3-8B: 5.2 GB × 1.2 = 6.2 GB ✓ fits well
- Qwen3-14B: 9.3 GB × 1.2 = 11.2 GB ✓ fits, but tight

---

## Check your Mac

```bash
# Find out your total RAM:
sysctl hw.memsize | awk '{printf "%.0f GB\n", $2/1073741824}'

# See currently used RAM:
top -l 1 | grep PhysMem
```

---

## Next step

Run the automated installer:

```bash
bash scripts/install.sh
```
