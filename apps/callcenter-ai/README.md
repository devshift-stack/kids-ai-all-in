# Callcenter AI - KI-gestützter Verkaufsagent

Eine Flutter-App mit einem KI-gestützten Verkaufsagenten (Lisa), der Solarmodule verkauft. Die App unterstützt sowohl Text-Chat als auch Voice-Interaktion.

## Features

- 🤖 **KI-Verkaufsagent (Lisa)**: Charmanter, empathischer Verkaufsagent basierend auf Google Gemini
- 💬 **Text-Chat**: Vollständige Chat-Funktionalität für Text-Nachrichten
- 🎤 **Voice-Input**: Spracherkennung für Spracheingabe (Speech-to-Text)
- 🔊 **Voice-Output**: Text-to-Speech für gesprochene Antworten von Lisa
- 🎨 **Professionelles Design**: Business-orientiertes UI für Verkaufsgespräche
- 🌍 **Mehrsprachig**: Unterstützung für Deutsch und Englisch

## Setup

### Voraussetzungen

- Flutter SDK 3.10.1 oder höher
- Dart SDK
- Android Studio / Xcode für Plattform-spezifische Entwicklung
- Google Gemini API Key

### Installation

1. **Dependencies installieren:**
```bash
cd apps/callcenter-ai
flutter pub get
```

2. **App mit API-Key starten:**
```bash
flutter run --dart-define=GEMINI_API_KEY=AIzaSyC4hhRA_tpmX-TXGBsDhfE9B4pmmr1Sfsk
```

Oder für Android:
```bash
flutter run --dart-define=GEMINI_API_KEY=AIzaSyC4hhRA_tpmX-TXGBsDhfE9B4pmmr1Sfsk -d android
```

Oder für iOS:
```bash
flutter run --dart-define=GEMINI_API_KEY=AIzaSyC4hhRA_tpmX-TXGBsDhfE9B4pmmr1Sfsk -d ios
```

### Permissions

Die App benötigt folgende Berechtigungen:

- **Android**: `RECORD_AUDIO` (für Mikrofon-Zugriff)
- **iOS**: `NSMicrophoneUsageDescription` und `NSSpeechRecognitionUsageDescription`

Diese sind bereits in den entsprechenden Konfigurationsdateien eingetragen.

## Verwendung

1. **App starten**: Die App startet direkt mit einem Begrüßungsgespräch von Lisa
2. **Text-Chat**: Tippen Sie Ihre Nachricht ein und senden Sie sie ab
3. **Voice-Chat**: 
   - Klicken Sie auf das Mikrofon-Icon
   - Sprechen Sie Ihre Nachricht
   - Die App erkennt Ihre Sprache automatisch
4. **Antworten**: Lisa antwortet sowohl textuell als auch gesprochen

## Architektur

```
apps/callcenter-ai/
├── lib/
│   ├── core/
│   │   ├── config/
│   │   │   └── api_config.dart      # API-Konfiguration
│   │   └── theme/
│   │       └── app_theme.dart       # App-Theme
│   ├── models/
│   │   └── chat_message.dart        # Chat-Message Model
│   ├── providers/
│   │   └── sales_agent_provider.dart # Riverpod Providers
│   ├── screens/
│   │   └── chat/
│   │       └── sales_chat_screen.dart # Haupt-Chat-Screen
│   ├── services/
│   │   └── sales_agent_service.dart  # KI-Service für Lisa
│   └── main.dart                     # App-Entry-Point
├── android/                          # Android-Konfiguration
├── ios/                              # iOS-Konfiguration
└── assets/
    └── locales/                      # Lokalisierungsdateien
```

## KI-Prompt

Der Verkaufsagent (Lisa) verwendet einen detaillierten System-Prompt, der:
- Charmant und empathisch kommuniziert
- Fragen-basierte Gesprächsführung nutzt
- Auf Ziele, Wünsche, Emotionen und Ängste des Kunden eingeht
- Eine strukturierte Verkaufsstruktur befolgt (Greeting → Qualify → Present → Handle Objections → Close)
- Fokus auf Solarmodule-Verkauf legt

## Anpassungen

### Andere Produkte verkaufen

Um andere Produkte zu verkaufen, passen Sie den System-Prompt in `lib/services/sales_agent_service.dart` an.

### Andere KI-APIs verwenden

Die App ist aktuell auf Google Gemini ausgelegt. Um andere APIs zu verwenden:
1. Passen Sie `SalesAgentService` an
2. Aktualisieren Sie `api_config.dart` mit den entsprechenden Parametern

## Entwicklung

```bash
# App im Debug-Modus starten
flutter run --dart-define=GEMINI_API_KEY=AIzaSyC4hhRA_tpmX-TXGBsDhfE9B4pmmr1Sfsk

# Build für Android
flutter build apk --dart-define=GEMINI_API_KEY=AIzaSyC4hhRA_tpmX-TXGBsDhfE9B4pmmr1Sfsk

# Build für iOS
flutter build ios --dart-define=GEMINI_API_KEY=AIzaSyC4hhRA_tpmX-TXGBsDhfE9B4pmmr1Sfsk
```

## Lizenz

Siehe Haupt-Repository für Lizenzinformationen.

