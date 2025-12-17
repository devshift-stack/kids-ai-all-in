# Backend Setup - Callcenter AI

## Schnellstart

### 1. Dependencies installieren

```bash
cd backend
npm install
```

### 2. Environment-Variablen setzen

Erstelle eine `.env` Datei:

```bash
cp .env.example .env
```

Bearbeite `.env` und setze deinen Gemini API Key:

```
GEMINI_API_KEY=AIzaSyC4hhRA_tpmX-TXGBsDhfE9B4pmmr1Sfsk
PORT=3000
NODE_ENV=development
```

### 3. Backend starten

```bash
# Option 1: Mit Start-Script
./start.sh

# Option 2: Direkt
npm start

# Option 3: Development mit Auto-Reload
npm run dev
```

### 4. Testen

```bash
# Health Check
curl http://localhost:3000/api/v1/health

# Neue Session erstellen
curl -X POST http://localhost:3000/api/v1/sessions

# Nachricht senden (Session-ID aus vorherigem Request)
curl -X POST http://localhost:3000/api/v1/sessions/YOUR_SESSION_ID/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "Hallo, worum geht es?"}'
```

## Flutter-App konfigurieren

In der Flutter-App muss die Backend-URL konfiguriert werden:

```dart
// In lib/services/backend_api_service.dart
BackendApiService(
  baseUrl: 'http://localhost:3000', // Lokal
  // baseUrl: 'http://192.168.1.100:3000', // Für Android-Emulator
  // baseUrl: 'https://your-backend.com', // Production
)
```

**Wichtig für Android-Emulator:**
- Verwende `http://10.0.2.2:3000` statt `localhost`
- Oder die IP-Adresse deines Macs

## Production-Deployment

### Option 1: Vercel/Netlify (Serverless)
- Backend als Serverless Functions deployen
- Automatisches Scaling

### Option 2: Docker
```dockerfile
FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

### Option 3: Cloud Run / AWS Lambda
- Skalierbar für viele gleichzeitige Sessions
- Pay-per-use

## Monitoring

- Health Check: `GET /api/v1/health`
- Aktive Sessions: `GET /api/v1/sessions`
- Logs: Console-Output

## Rate-Limiting

- 100 Requests pro Minute pro IP
- Gemini API: 15 Requests/Minute (Free Tier)
- Bei Überlastung: Queue-System implementieren

