# Kids AI - Monorepo

Alle Kids AI Apps in einem Repository.

## Struktur

```
kids-ai-all-in/
├── apps/
│   ├── lianko/      # Lianko - App für Kinder mit Hörbehinderung
│   ├── alanko/      # Alanko - Lern-App für alle Kinder
│   └── parent/      # Parent Dashboard - Eltern-App
├── packages/
│   └── shared/      # Gemeinsamer Code (TTS, Design System, etc.)
```

## Apps

| App | Beschreibung | Zielgruppe |
|-----|--------------|------------|
| **Lianko** | Spezialisiert für Kinder mit Hörbehinderung | 3-12 Jahre |
| **Alanko** | Allgemeine Lern- und Spiel-App | 3-12 Jahre |
| **Parent** | Dashboard für Eltern | Eltern |

## Shared Package

Gemeinsam genutzte Komponenten:
- TTS Service (Edge TTS, Fluent TTS)
- Design System
- Sound Assets
- Lokalisierungen

## Setup

```bash
# Repository klonen
git clone https://github.com/devshift-stack/kids-ai-all-in.git

# Einzelne App starten
cd apps/lianko && flutter run
cd apps/alanko && flutter run
cd apps/parent && flutter run
```

## Originale Repos

Die einzelnen Repos bleiben weiterhin aktiv:
- [Kids-AI-Train-Lianko](https://github.com/devshift-stack/Kids-AI-Train-Lianko)
- [Kids-AI-Train-Alanko](https://github.com/devshift-stack/Kids-AI-Train-Alanko)
- [Kids-AI-Train-Parent](https://github.com/devshift-stack/Kids-AI-Train-Parent)
- [Kids-AI-Shared](https://github.com/devshift-stack/Kids-AI-Shared)
