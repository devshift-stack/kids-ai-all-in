# Backend-Setup für 10-20 gleichzeitige Gespräche

## ✅ Was wurde erstellt

1. **Backend-Server** (Node.js/Express)
   - Session-Management für mehrere gleichzeitige Gespräche
   - REST API-Endpoints
   - Rate-Limiting
   - Automatische Session-Cleanup

2. **Flutter-Client** angepasst
   - BackendApiService für API-Kommunikation
   - Session-Management
   - Error-Handling

## 🚀 Schnellstart

### 1. Backend starten

```bash
cd apps/callcenter-ai/backend

# Dependencies installieren
npm install

# .env Datei erstellen
echo "GEMINI_API_KEY=AIzaSyC4hhRA_tpmX-TXGBsDhfE9B4pmmr1Sfsk" > .env
echo "PORT=3000" >> .env

# Backend starten
npm start
```

Backend läuft jetzt auf: `http://localhost:3000`

### 2. Flutter-App starten

```bash
cd apps/callcenter-ai
flutter pub get
flutter run --dart-define=GEMINI_API_KEY=AIzaSyC4hhRA_tpmX-TXGBsDhfE9B4pmmr1Sfsk -d android
```

**Wichtig:** Die Backend-URL ist in `lib/providers/backend_api_provider.dart` konfiguriert:
- Android Emulator: `http://10.0.2.2:3000` ✅ (bereits gesetzt)
- iOS Simulator: `http://localhost:3000`
- Physisches Gerät: IP-Adresse deines Macs (z.B. `http://192.168.1.100:3000`)

## 📊 API-Endpoints

```
GET    /api/v1/health                    # Health Check
POST   /api/v1/sessions                 # Neue Session erstellen
POST   /api/v1/sessions/:id/chat        # Nachricht senden
GET    /api/v1/sessions/:id             # Session-Status
DELETE /api/v1/sessions/:id             # Session beenden
GET    /api/v1/sessions                 # Alle Sessions (Admin)
```

## 🔧 Konfiguration

### Backend-URL in Flutter-App ändern

In `lib/providers/backend_api_provider.dart`:

```dart
final backendApiServiceProvider = Provider<BackendApiService>((ref) {
  return BackendApiService(
    baseUrl: 'http://10.0.2.2:3000', // Android Emulator
    // baseUrl: 'http://localhost:3000', // iOS Simulator
    // baseUrl: 'http://192.168.1.100:3000', // Physisches Gerät
  );
});
```

## 📈 Skalierung

### Aktuell unterstützt:
- ✅ 10-20 gleichzeitige Sessions (In-Memory)
- ✅ Automatische Session-Cleanup nach 1h Inaktivität
- ✅ Rate-Limiting (100 Requests/Minute)

### Für mehr Sessions:
1. **Datenbank hinzufügen** (z.B. MongoDB, PostgreSQL)
2. **Redis für Session-Storage**
3. **Queue-System** für Gemini API (Rate-Limiting)
4. **Load Balancer** für mehrere Backend-Instanzen

## 🐛 Troubleshooting

### Backend nicht erreichbar
- Prüfe ob Backend läuft: `curl http://localhost:3000/api/v1/health`
- Prüfe Firewall-Einstellungen
- Für Android: Verwende `10.0.2.2` statt `localhost`

### Session-Fehler
- Prüfe Backend-Logs
- Prüfe ob Gemini API Key korrekt ist
- Prüfe Rate-Limits

## 📝 Nächste Schritte

1. ✅ Backend starten
2. ✅ Flutter-App starten
3. ✅ Testen mit mehreren gleichzeitigen Gesprächen
4. ⏭️ Optional: Datenbank-Integration für Persistenz
5. ⏭️ Optional: Production-Deployment (Vercel, AWS, etc.)

