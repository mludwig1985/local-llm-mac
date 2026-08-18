# Welches Qwen-Modell für welchen Mac?

Apple Silicon (M1–M5) nutzt Unified Memory: RAM und GPU-Speicher teilen sich
denselben Pool. Das macht Macs besonders gut für lokale LLMs — ein
MacBook Pro mit 32 GB schlägt eine Nvidia-Karte mit 16 GB VRAM.

---

## Schnell-Referenz

| Mac | RAM | Empfehlung | Ollama-Befehl |
|-----|-----|------------|---------------|
| MacBook Air M1/M2/M3 | 8 GB | Qwen3-1.7B | `ollama run qwen3:1.7b` |
| MacBook Air M1/M2/M3 | 16 GB | Qwen3-4B | `ollama run qwen3:4b` |
| MacBook Pro M2/M3/M4 | 16 GB | **Qwen3-8B** | `ollama run qwen3:8b` |
| MacBook Pro M3/M4 Pro | 18–24 GB | **Qwen3-14B** | `ollama run qwen3:14b` |
| MacBook Pro M3/M4 Max | 36–48 GB | **Qwen3-30B-A3B** | `ollama run qwen3:30b-a3b` |
| Mac Mini M4 | 16 GB | Qwen3-8B | `ollama run qwen3:8b` |
| Mac Mini M4 Pro | 24–32 GB | Qwen3-14B | `ollama run qwen3:14b` |
| Mac Studio M4 Max | 64–96 GB | Qwen3-32B | `ollama run qwen3:32b` |
| Mac Pro M2 Ultra | 192 GB | Qwen3-235B-A22B | `ollama run qwen3:235b-a22b` |

---

## Detailierte Empfehlungen

### MacBook Air M1 / M2 / M3 — 8 GB RAM

Das Einstiegsmodell mit 8 GB ist eingeschränkt, aber nutzbar.

**Empfehlung: `qwen3:1.7b`**

- Download: 1,4 GB — passt problemlos
- RAM-Nutzung: ~2 GB — lässt 6 GB für macOS
- Qualität: Gut für einfache Aufgaben, Textzusammenfassungen, Chat

```bash
ollama run qwen3:1.7b
```

**Alternativ: `qwen3:4b`** (wenn wenige andere Apps offen sind)
- RAM-Nutzung: ~3 GB — funktioniert, kann gelegentlich lahmen
- Deutlich bessere Qualität als 1.7B

> ⚠️ Qwen3-8B ist auf 8 GB nicht empfehlenswert — zu wenig Puffer für macOS.

---

### MacBook Air M1 / M2 / M3 — 16 GB RAM

Mit 16 GB hat man deutlich mehr Spielraum.

**Empfehlung: `qwen3:4b`** (für Geschwindigkeit)
**Alternativ: `qwen3:8b`** (für bessere Qualität)

- Qwen3-4B: ~3 GB RAM, sehr schnell, exzellentes Qualitäts-/Größen-Verhältnis
- Qwen3-8B: ~6 GB RAM, deutlich stärker, läuft komfortabel auf 16 GB

```bash
# Schnell und effizient:
ollama run qwen3:4b

# Beste Qualität bei 16 GB:
ollama run qwen3:8b
```

---

### MacBook Pro M2 / M3 / M4 — 16 GB RAM

Mit dem leistungsstarken M-Chip läuft Qwen3-8B sehr flüssig.

**Empfehlung: `qwen3:8b`**

- Download: 5,2 GB
- RAM-Nutzung: ~6 GB
- Geschwindigkeit: ~20–30 Token/Sekunde
- Qualität: Ausgezeichnet für Code, Chat, Analysen

```bash
ollama run qwen3:8b
```

---

### MacBook Pro M3 Pro / M4 Pro — 18–24 GB RAM

Der "Sweet Spot" — genug RAM für ein ernsthaftes Modell ohne Kompromisse.

**Empfehlung: `qwen3:14b`**

- Download: 9,3 GB
- RAM-Nutzung: ~10 GB — lässt viel für macOS und andere Apps
- Qualität: Sehr stark, besonders mit `/think`-Modus für komplexe Aufgaben

```bash
ollama run qwen3:14b
```

---

### MacBook Pro M3 Max / M4 Max — 36–128 GB RAM

**Empfehlung: `qwen3:30b-a3b`** (MoE — das Hidden Gem)

Das MoE-Modell mit 30B Parametern aktiviert pro Anfrage nur 3B — es läuft
mit der Geschwindigkeit eines kleinen Modells, liefert aber die Qualität
eines 30B+ Dense-Modells.

- Download: 19 GB
- RAM-Nutzung: ~20 GB
- Geschwindigkeit: ~15–20 Token/Sekunde (trotz 30B Gesamtgröße)
- Qualität: Übertrifft oft Dense-Modelle in der 32B-Klasse

```bash
# MoE-Modell (empfohlen):
ollama run qwen3:30b-a3b

# Dense-Alternative:
ollama run qwen3:32b
```

---

### Mac Mini M4 — 16 GB RAM

Identisch zur MacBook Pro 16 GB-Empfehlung.

**Empfehlung: `qwen3:8b`**

Der Mac Mini M4 eignet sich hervorragend als dauerhaft laufender lokaler
KI-Server — er verbraucht nur ~20W unter Last.

```bash
ollama run qwen3:8b
```

---

### Mac Mini M4 Pro — 24–32 GB RAM

**Empfehlung: `qwen3:14b`**

```bash
ollama run qwen3:14b
```

---

### Mac Studio M4 Max / M2 Ultra — 64–192 GB RAM

**Empfehlung: `qwen3:32b`** (64 GB) oder **`qwen3:235b-a22b`** (192 GB)

```bash
# 64 GB RAM:
ollama run qwen3:32b

# 192 GB RAM (Flagship-Modell, konkurriert mit GPT-4):
ollama run qwen3:235b-a22b
```

---

## RAM-Faustregel

```
Verfügbares RAM für Modell = Gesamt-RAM - 4 GB (für macOS)
Modell passt wenn:   Modell-Dateigröße × 1,2 ≤ verfügbares RAM
```

Beispiel: 16 GB Mac
- Verfügbar: 16 - 4 = 12 GB
- Qwen3-8B: 5,2 GB × 1,2 = 6,2 GB ✓ passt gut
- Qwen3-14B: 9,3 GB × 1,2 = 11,2 GB ✓ passt, aber eng

---

## Eigenen Mac prüfen

```bash
# RAM-Größe ermitteln:
sysctl hw.memsize | awk '{printf "%.0f GB\n", $2/1073741824}'

# Aktuell genutzten RAM anzeigen:
top -l 1 | grep PhysMem
```

---

## Nächster Schritt

→ [Automatische Installation](../scripts/install.sh)

```bash
bash scripts/install.sh
```
