# Which Qwen3 Model for Which Mac?

Apple Silicon (M1–M5) uses Unified Memory: RAM and GPU share the same pool.
This makes Macs exceptionally good for local LLMs — a MacBook Pro with 32 GB
unified memory outperforms a dedicated Nvidia card with 16 GB VRAM.

---

## Quick reference

| Mac | RAM | Recommended | Command |
|-----|-----|-------------|---------|
| MacBook Air M1/M2/M3/M4 | 8 GB | Qwen3-1.7B | `ollama run qwen3:1.7b` |
| MacBook Air M1/M2/M3 | 16 GB | Qwen3-8B | `ollama run qwen3:8b` |
| MacBook Air M4 | 32 GB | Qwen3-14B | `ollama run qwen3:14b` |
| MacBook Pro M2/M3/M4 | 16 GB | **Qwen3-8B** ⭐ | `ollama run qwen3:8b` |
| MacBook Pro M3/M4 Pro | 24 GB | **Qwen3-14B** ⭐ | `ollama run qwen3:14b` |
| MacBook Pro M3/M4 Pro | 48 GB | **Qwen3-30B-A3B** ⭐ | `ollama run qwen3:30b-a3b` |
| MacBook Pro M3/M4 Max | 36–48 GB | Qwen3-30B-A3B | `ollama run qwen3:30b-a3b` |
| MacBook Pro M3/M4 Max | 64–128 GB | **Qwen3-32B-Q8** ⭐ | `ollama run qwen3:32b-q8_0` |
| Mac Mini M4 | 16–24 GB | Qwen3-8B | `ollama run qwen3:8b` |
| Mac Mini M4 Pro | 24–48 GB | Qwen3-14B / 30B-A3B | `ollama run qwen3:30b-a3b` |
| Mac Studio M4 Max | 32–96 GB | Qwen3-32B-Q8 | `ollama run qwen3:32b-q8_0` |
| Mac Studio / Mac Pro Ultra | 192 GB+ | Qwen3-235B-A22B | `ollama run qwen3:235b-a22b` |

---

## RAM rule of thumb

```
Headroom for the model  =  Total RAM  −  4 GB (for macOS)
Model fits when:          model file size × 1.2  ≤  available headroom
```

| RAM | Available for model | Fits comfortably |
|-----|--------------------|--------------------|
| 8 GB | ~4 GB | Qwen3-1.7B (2 GB) |
| 16 GB | ~12 GB | Qwen3-8B (6 GB) ✓ |
| 24 GB | ~20 GB | Qwen3-14B (10 GB) ✓ |
| 32 GB | ~28 GB | Qwen3-30B-A3B (20 GB) ✓ |
| 48 GB | ~44 GB | Qwen3-30B-A3B (20 GB) ✓ or Qwen3-32B (22 GB) ✓ |
| 64 GB | ~60 GB | Qwen3-32B-Q8 (36 GB) ✓ |
| 96 GB | ~92 GB | Qwen3-32B-Q8 (36 GB) ✓ |
| 128 GB | ~124 GB | Qwen3-32B-Q8 (36 GB) ✓ — 235B does NOT fit (142 GB) |
| 192 GB | ~188 GB | Qwen3-235B-A22B (144 GB) ✓ |

---

## Detailed recommendations

### MacBook Air M1 / M2 / M3 — 8 GB RAM

**Recommended: `qwen3:1.7b`**

- Download: 1.4 GB
- RAM usage: ~2 GB — leaves 6 GB for macOS
- Quality: Good for chat, text summaries, simple tasks

```bash
ollama run qwen3:1.7b
```

**Alternative: `qwen3:4b`** (if few other apps are open)
- RAM usage: ~3 GB — works, may occasionally slow down
- Noticeably better quality than 1.7B

> ⚠️ Qwen3-8B is not recommended on 8 GB — not enough headroom for macOS.

---

### MacBook Air M1 / M2 / M3 — 16 GB RAM

**Recommended: `qwen3:8b`**

- Download: 5.2 GB
- RAM usage: ~6 GB — leaves 10 GB for macOS and other apps
- Quality: Excellent for code, chat, analysis

```bash
ollama run qwen3:8b
```

**Alternative: `qwen3:4b`** for faster responses with slightly lower quality.

---

### MacBook Air M4 — 32 GB RAM

The M4 Air starts at 16 GB (see above) but the 32 GB config is a big jump.

**Recommended: `qwen3:14b`**

- RAM usage: ~10 GB — plenty of headroom
- Quality: Very strong, especially with `/think` mode

```bash
ollama run qwen3:14b
```

---

### MacBook Pro M2 / M3 / M4 — 16 GB RAM

**Recommended: `qwen3:8b`**

- Download: 5.2 GB
- RAM usage: ~6 GB
- Speed: ~20–30 tokens/second on M3/M4
- Quality: Excellent for code, chat, analysis

```bash
ollama run qwen3:8b
```

---

### MacBook Pro M3 Pro / M4 Pro — 24 GB RAM

**Recommended: `qwen3:14b`**

- Download: 9.3 GB
- RAM usage: ~10 GB — leaves plenty for macOS and other apps
- Quality: Very strong, especially with `/think` mode for complex tasks

```bash
ollama run qwen3:14b
```

---

### MacBook Pro M3 Pro / M4 Pro — 48 GB RAM

**Recommended: `qwen3:30b-a3b`** (MoE — the hidden gem)

- Download: 19 GB
- RAM usage: ~20 GB
- Speed: ~15–20 tokens/second (despite 30B total size)
- Quality: Often outperforms dense models in the 32B range
- Context: 256K tokens

```bash
ollama run qwen3:30b-a3b
```

---

### MacBook Pro M3 Max / M4 Max — 36–48 GB RAM

**Recommended: `qwen3:30b-a3b`** (MoE)

Same reasoning as above — MoE beats dense 32B at this RAM level.

```bash
# Best choice — MoE, 256K context:
ollama run qwen3:30b-a3b

# Dense alternative (slightly more RAM, 40K context):
ollama run qwen3:32b
```

---

### MacBook Pro M3 Max / M4 Max — 64–128 GB RAM

**Recommended: `qwen3:32b-q8_0`** (full quality)

This is the most important correction vs. common advice: at 64 GB you have
the headroom to run the full-precision (Q8_0) version, which is significantly
better than the standard Q4 quantization.

> ⚠️ `qwen3:235b-a22b` requires ~142 GB — it does **not** fit in 128 GB RAM.

- Download: ~35 GB
- RAM usage: ~36 GB — leaves over 25 GB headroom on 64 GB
- Quality: Maximum quality for the 32B model (Q8 = essentially lossless)

```bash
ollama run qwen3:32b-q8_0
```

---

### Mac Mini M4 — 16–24 GB RAM

**Recommended: `qwen3:8b`** (16 GB) or **`qwen3:14b`** (24 GB)

The Mac Mini M4 is ideal as an always-on local AI server — it draws only
~20W under load.

```bash
ollama run qwen3:8b   # 16 GB config
ollama run qwen3:14b  # 24 GB config
```

---

### Mac Mini M4 Pro — 24–48 GB RAM

**Recommended: `qwen3:30b-a3b`**

```bash
ollama run qwen3:30b-a3b
```

---

### Mac Studio M4 Max — 32–128 GB RAM

| RAM | Recommended | Command |
|-----|-------------|---------|
| 32 GB | Qwen3-30B-A3B | `ollama run qwen3:30b-a3b` |
| 64 GB | **Qwen3-32B-Q8** | `ollama run qwen3:32b-q8_0` |
| 96 GB | **Qwen3-32B-Q8** | `ollama run qwen3:32b-q8_0` |
| 128 GB | **Qwen3-32B-Q8** | `ollama run qwen3:32b-q8_0` |

> Note: `qwen3:235b-a22b` (142 GB) does not fit in 128 GB.

---

### Mac Studio Ultra / Mac Pro Ultra — 192 GB+ RAM

**Recommended: `qwen3:235b-a22b`**

- Download: 142 GB
- RAM usage: ~144 GB
- Quality: Competes with GPT-4 class models
- Requires 192 GB minimum

```bash
ollama run qwen3:235b-a22b
```

---

## Check your Mac's RAM

```bash
# Find out your total RAM:
sysctl hw.memsize | awk '{printf "%.0f GB\n", $2/1073741824}'

# See currently used RAM:
top -l 1 | grep PhysMem
```

---

## Run the automated installer

```bash
bash scripts/install.sh
```
