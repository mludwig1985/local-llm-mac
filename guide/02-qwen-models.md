# Qwen3 Models Overview

Qwen is a model family from Alibaba. The current **Qwen3** generation is the
best choice for local use — strong quality, Apache 2.0 license, and native
Ollama support.

---

## All Qwen3 models on Ollama

### Dense models (standard)

In dense models, all parameters are active for every request.

| Model | Download | RAM needed | Context | Command |
|-------|----------|------------|---------|---------|
| Qwen3-0.6B | 523 MB | ~1 GB | 40K | `ollama run qwen3:0.6b` |
| Qwen3-1.7B | 1.4 GB | ~2 GB | 40K | `ollama run qwen3:1.7b` |
| Qwen3-4B | 2.5 GB | ~3 GB | 256K | `ollama run qwen3:4b` |
| Qwen3-8B | 5.2 GB | ~6 GB | 40K | `ollama run qwen3:8b` |
| Qwen3-14B | 9.3 GB | ~10 GB | 40K | `ollama run qwen3:14b` |
| Qwen3-32B | 20 GB | ~22 GB | 40K | `ollama run qwen3:32b` |

### MoE models (Mixture of Experts)

MoE models have many parameters, but only activate a fraction per request.
Result: quality of a large model at the speed of a small one.

| Model | Total / Active | Download | RAM needed | Context | Command |
|-------|---------------|----------|------------|---------|---------|
| Qwen3-30B-A3B | 30B / 3B | 19 GB | ~20 GB | 256K | `ollama run qwen3:30b-a3b` |
| Qwen3-235B-A22B | 235B / 22B | 142 GB | ~144 GB | 256K | `ollama run qwen3:235b-a22b` |

> **Tip:** `qwen3:30b-a3b` is the hidden gem of the family — it often
> outperforms 32B dense models while running at the speed of a 3B model.
> The top pick for 32 GB Macs.

---

## Thinking mode (Qwen3 exclusive)

Qwen3 has a built-in "Thinking" mode: the model reasons step-by-step before
answering, similar to OpenAI o1. This significantly improves quality on
complex tasks.

```bash
# Start a model session:
ollama run qwen3:8b

# Enable Thinking mode (prefix your prompt):
/think Explain the difference between TCP and UDP

# Disable Thinking (faster responses):
/no_think What is the capital of France?
```

---

## Understanding quantization

Ollama downloads Q4_K_M quantizations by default — a good balance between
quality and size.

| Quantization | Quality | Size | When to use |
|--------------|---------|------|-------------|
| Q2_K | ⭐⭐ | Very small | Only when RAM is extremely limited |
| Q4_K_M | ⭐⭐⭐⭐ | Medium | Default — good balance |
| Q5_K_M | ⭐⭐⭐⭐½ | Large | When you have RAM to spare |
| Q8_0 | ⭐⭐⭐⭐⭐ | Very large | Maximum quality |

```bash
# Choose a specific quantization:
ollama run qwen3:8b-q8_0    # Full quality, ~9 GB
ollama run qwen3:8b-q4_K_M  # Default
```

---

## What is Qwen3 good at?

| Task | Recommended model |
|------|------------------|
| General chat | Qwen3-4B to Qwen3-14B |
| Writing / explaining code | Qwen3-8B+ |
| Complex analysis | Qwen3-14B+ (with /think) |
| Summarizing text | Qwen3-4B (more than enough) |
| Long documents | Qwen3-4B or Qwen3-30B-A3B (256K context) |
| AI agents | Qwen3-8B+ |

---

## Using the Ollama API

Ollama exposes an OpenAI-compatible API — use it anywhere you would otherwise
use the OpenAI API:

```bash
# Direct API call:
curl http://localhost:11434/api/generate \
  -d '{"model": "qwen3:8b", "prompt": "What is Docker?", "stream": false}'

# OpenAI-compatible endpoint:
curl http://localhost:11434/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen3:8b",
    "messages": [{"role": "user", "content": "What is an AI agent?"}]
  }'
```

In Python (using the `openai` library):

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:11434/v1",
    api_key="ollama"  # any value works, it's ignored
)

response = client.chat.completions.create(
    model="qwen3:8b",
    messages=[{"role": "user", "content": "What is an AI agent?"}]
)
print(response.choices[0].message.content)
```

---

## Next step

→ [Mac-specific recommendations](03-mac-recommendations.md)
