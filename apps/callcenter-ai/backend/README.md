# Callcenter AI Backend - Multi-Session System

Backend-System für 10-20 gleichzeitige Verkaufsgespräche mit Lisa.

## Architektur

```
┌─────────────┐
│ Flutter App │ (Client)
└──────┬──────┘
       │ HTTP/REST
       ▼
┌─────────────────────────────────┐
│     Backend Server              │
│  ┌──────────────────────────┐   │
│  │  Session Manager         │   │
│  │  - Session IDs           │   │
│  │  - Chat Histories        │   │
│  └──────────────────────────┘   │
│  ┌──────────────────────────┐   │
│  │  Gemini API Client       │   │
│  │  - Rate Limiting         │   │
│  │  - Connection Pool       │   │
│  └──────────────────────────┘   │
└─────────────────────────────────┘
       │
       ▼
┌─────────────┐
│ Gemini API  │
└─────────────┘
```

## Features

- ✅ **Session-Management**: Jede Chat-Session isoliert
- ✅ **Rate-Limiting**: Schutz vor API-Überlastung
- ✅ **Skalierbar**: Unterstützt 10-20 gleichzeitige Gespräche
- ✅ **REST API**: Einfache Integration mit Flutter-App
- ✅ **Error-Handling**: Robuste Fehlerbehandlung
- ✅ **Chat-Historie**: Optional in Datenbank speichern

## Technologie-Optionen

### Option 1: Node.js/Express (Empfohlen)
- ✅ Schnell zu implementieren
- ✅ Große Community
- ✅ Viele Libraries verfügbar

### Option 2: Dart Shelf
- ✅ Gleiche Sprache wie Flutter
- ✅ Code-Sharing möglich
- ✅ Weniger Libraries verfügbar

### Option 3: Python FastAPI
- ✅ Sehr schnell
- ✅ Gute AI-Integration
- ✅ Async-Support

## API-Endpoints

```
POST   /api/v1/sessions          # Neue Session erstellen
POST   /api/v1/sessions/:id/chat # Nachricht senden
GET    /api/v1/sessions/:id      # Session-Status abrufen
DELETE /api/v1/sessions/:id      # Session beenden
GET    /api/v1/health            # Health-Check
```

## Session-Management

Jede Session hat:
- **Session ID**: Eindeutige UUID
- **Chat History**: Array von Messages
- **Gemini ChatSession**: Isolierte Gemini-Session
- **Created At**: Zeitstempel
- **Last Activity**: Letzte Aktivität

## Rate-Limiting

- **Gemini API Limits**: 15 Requests/Minute (Free Tier)
- **Queue-System**: Anfragen in Queue bei Überlastung
- **Retry-Logic**: Automatische Wiederholung bei Fehlern

