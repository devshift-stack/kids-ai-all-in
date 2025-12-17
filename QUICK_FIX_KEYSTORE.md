# 🚀 Schnelllösung: Keystore-Problem beheben

## Die einfachste Lösung: Google Play App Signing

**Alle drei Apps** (Alanko, Lianko, Parent) haben das gleiche Problem - sie wurden mit dem falschen Keystore signiert.

### ✅ Lösung in 3 Schritten:

#### 1. Gehe zu Google Play Console
- Öffne jede App (Alanko, Lianko, Parent) in der Google Play Console

#### 2. Klicke auf "Signaturschlüssel ändern"
- In der Console siehst du den Link **"Signaturschlüssel ändern"** (Change signing key)
- Klicke darauf für jede App

#### 3. Folge den Anweisungen
- Google führt dich durch den Prozess
- Du kannst einen neuen Upload-Key erstellen
- Verwende diesen neuen Key für zukünftige Uploads

---

## Alternative: Ursprünglichen Keystore finden

Wenn du den ursprünglichen Keystore findest:

**Erwarteter SHA1:** `8B:D6:C9:61:7D:6D:A6:28:15:73:89:4D:8D:76:51:3A:3D:0D:46:E2`

**Suche nach:**
```bash
find ~ -name "*.jks" -o -name "*.keystore" 2>/dev/null
```

**Prüfe jeden Keystore:**
```bash
keytool -list -v -keystore [KEystore-Pfad] | grep SHA1
```

---

## Empfehlung

**Nutze "Signaturschlüssel ändern"** in Google Play Console - das ist die einfachste und sicherste Lösung!

