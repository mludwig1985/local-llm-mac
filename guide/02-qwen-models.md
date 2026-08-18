# Qwen-Modelle im Überblick

Qwen ist eine Modellfamilie von Alibaba. Für den lokalen Einsatz ist die
aktuelle **Qwen3**-Generation am besten geeignet — starke Qualität,
Apache 2.0-Lizenz, native Ollama-Unterstützung.

---

## Alle Qwen3-Modelle auf Ollama

### Dense-Modelle (Standard)

Bei Dense-Modellen sind alle Parameter bei jeder Anfrage aktiv.

| Modell | Download | RAM-Bedarf | Kontext | Ollama-Befehl |
|--------|----------|------------|---------|---------------|
| Qwen3-0.6B | 523 MB | ~1 GB | 40K | `ollama run qwen3:0.6b` |
| Qwen3-1.7B | 1,4 GB | ~2 GB | 40K | `ollama run qwen3:1.7b` |
| Qwen3-4B | 2,5 GB | ~3 GB | 256K | `ollama run qwen3:4b` |
| Qwen3-8B | 5,2 GB | ~6 GB | 40K | `ollama run qwen3:8b` |
| Qwen3-14B | 9,3 GB | ~10 GB | 40K | `ollama run qwen3:14b` |
| Qwen3-32B | 20 GB | ~22 GB | 40K | `ollama run qwen3:32b` |

### MoE-Modelle (Mixture of Experts)

MoE-Modelle haben viele Parameter, aktivieren aber pro Anfrage nur einen
Bruchteil davon. Ergebnis: Qualität eines großen Modells bei Geschwindigkeit
eines kleinen.

| Modell | Gesamt / Aktiv | Download | RAM-Bedarf | Kontext | Ollama-Befehl |
|--------|---------------|----------|------------|---------|---------------|
| Qwen3-30B-A3B | 30B / 3B | 19 GB | ~20 GB | 256K | `ollama run qwen3:30b-a3b` |
| Qwen3-235B-A22B | 235B / 22B | 142 GB | ~144 GB | 256K | `ollama run qwen3:235b-a22b` |

> **Tipp:** `qwen3:30b-a3b` ist das Hidden Gem der Familie — es übertrifft
> in der Qualität oft 32B-Dense-Modelle, läuft aber mit der Geschwindigkeit
> eines 3B-Modells. Für 32GB-Macs die beste Wahl.

---

## Thinking-Modus (Qwen3-Feature)

Qwen3 hat einen eingebauten "Thinking"-Modus: Das Modell denkt vor der
Antwort nach (ähnlich wie o1 von OpenAI), was bei komplexen Aufgaben die
Qualität deutlich steigert.

```bash
# Thinking-Modus aktivieren (in der Anfrage):
ollama run qwen3:8b
# Dann in der Eingabe:
/think Erkläre den Unterschied zwischen TCP und UDP

# Thinking deaktivieren (schnellere Antworten):
/no_think Was ist die Hauptstadt von Frankreich?
```

---

## Quantisierung verstehen

Ollama lädt standardmäßig Q4_K_M-Quantisierungen herunter — ein guter
Kompromiss zwischen Qualität und Größe.

| Quantisierung | Qualität | Größe | Wann nutzen |
|---------------|----------|-------|-------------|
| Q2_K | ⭐⭐ | Sehr klein | Nur wenn RAM extrem knapp |
| Q4_K_M | ⭐⭐⭐⭐ | Mittel | Standard — guter Kompromiss |
| Q5_K_M | ⭐⭐⭐⭐½ | Groß | Wenn RAM übrig ist |
| Q8_0 | ⭐⭐⭐⭐⭐ | Sehr groß | Maximale Qualität |

```bash
# Andere Quantisierung explizit wählen:
ollama run qwen3:8b:q8_0    # Volle Qualität, ~9 GB
ollama run qwen3:8b:q4_K_M  # Standard (Default)
```

---

## Wofür ist Qwen3 gut?

| Aufgabe | Geeignetes Modell |
|---------|------------------|
| Allgemeiner Chat | Qwen3-4B bis Qwen3-14B |
| Code schreiben/erklären | Qwen3-8B+ |
| Komplexe Analysen | Qwen3-14B+ (mit /think) |
| Texte zusammenfassen | Qwen3-4B (reicht völlig) |
| Lange Dokumente | Qwen3-4B oder Qwen3-30B-A3B (256K Kontext) |
| KI-Agenten | Qwen3-8B+ |

---

## Qwen-API mit Ollama nutzen

Ollama stellt eine OpenAI-kompatible API bereit — du kannst es überall
einsetzen wo du sonst die OpenAI-API nutzt:

```bash
# Direkte API-Anfrage:
curl http://localhost:11434/api/generate \
  -d '{"model": "qwen3:8b", "prompt": "Was ist Docker?", "stream": false}'

# OpenAI-kompatibler Endpunkt:
curl http://localhost:11434/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen3:8b",
    "messages": [{"role": "user", "content": "Was ist Docker?"}]
  }'
```

In Python (mit openai-Bibliothek):

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:11434/v1",
    api_key="ollama"  # beliebiger Wert, wird ignoriert
)

response = client.chat.completions.create(
    model="qwen3:8b",
    messages=[{"role": "user", "content": "Was ist ein KI-Agent?"}]
)
print(response.choices[0].message.content)
```

---

## Nächster Schritt

→ [Empfehlungen nach Mac-Modell](03-mac-recommendations.md)
