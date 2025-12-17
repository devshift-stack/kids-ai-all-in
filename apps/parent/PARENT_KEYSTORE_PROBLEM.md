# ⚠️ WICHTIG: Parent App Keystore-Problem

## Problem
Die Parent App wurde mit dem **falschen Keystore** signiert. Google Play Console erwartet einen bestimmten SHA1-Fingerabdruck, aber die hochgeladene AAB-Datei hat einen anderen.

## Erwarteter SHA1-Fingerabdruck (von Google Play):
```
SHA1: 8B:D6:C9:61:7D:6D:A6:28:15:73:89:4D:8D:76:51:3A:3D:0D:46:E2
```

## Aktueller SHA1-Fingerabdruck (der hochgeladenen AAB):
```
SHA1: D8:DE:0E:C5:F2:BD:03:86:A2:F7:F8:46:08:0E:AB:BC:CB:91:84:2D
```

---

## Lösung: Den richtigen Keystore finden

### Option 1: Den ursprünglichen Keystore verwenden (EMPFOHLEN)

Wenn die Parent App bereits einmal im Play Store hochgeladen wurde, musst du den **ursprünglichen Keystore** verwenden.

**Schritte:**
1. Suche nach dem ursprünglichen Keystore auf deinem Computer
2. Prüfe den SHA1-Fingerabdruck:
   ```bash
   keytool -list -v -keystore [KEystore-Pfad] -alias [Alias-Name]
   ```
3. Der SHA1-Fingerabdruck muss sein: `8B:D6:C9:61:7D:6D:A6:28:15:73:89:4D:8D:76:51:3A:3D:0D:46:E2`

**Wo könnte der Keystore sein?**
- Auf deinem Computer (Backup-Ordner)
- In einem Passwort-Manager (als Backup)
- Bei einem Kollegen/Team-Mitglied
- In einem Cloud-Backup (Dropbox, Google Drive, etc.)

### Option 2: Google Play App Signing verwenden

Wenn du **Google Play App Signing** aktiviert hast, kann Google den Keystore für dich verwalten.

**Prüfe in Google Play Console:**
1. Gehe zu: **Release** → **Setup** → **App Signing**
2. Wenn "Google Play App Signing" aktiviert ist, kannst du einen neuen Upload-Key erstellen
3. Folge den Anweisungen in der Console

### Option 3: Neuen Upload-Key hochladen (nur wenn App Signing aktiviert)

Wenn Google Play App Signing aktiviert ist:
1. Erstelle einen neuen Upload-Key
2. Lade den neuen Upload-Key in Google Play Console hoch
3. Verwende diesen neuen Key für zukünftige Uploads

---

## Wenn der ursprüngliche Keystore verloren ist

⚠️ **WARNUNG:** Wenn der ursprüngliche Keystore verloren ist, ist es **sehr schwierig**, die App zu aktualisieren.

**Mögliche Lösungen:**
1. **Google Play Support kontaktieren** - Sie können helfen, aber es ist ein langer Prozess
2. **Neue App erstellen** - Erstelle eine neue App mit neuer Package-ID (nicht empfohlen, verliert alle Bewertungen/Downloads)
3. **Google Play App Signing** - Wenn bereits aktiviert, kann Google helfen

---

## Aktuelle Situation

Die Parent App wurde wahrscheinlich mit einem **Debug-Keystore** oder einem **neuen Keystore** signiert, der nicht mit dem ursprünglichen übereinstimmt.

**Was du jetzt tun musst:**
1. ✅ Finde den ursprünglichen Keystore mit SHA1: `8B:D6:C9:61:7D:6D:A6:28:15:73:89:4D:8D:76:51:3A:3D:0D:46:E2`
2. ✅ Erstelle eine `key.properties` Datei mit diesem Keystore
3. ✅ Baue die AAB-Datei neu mit dem richtigen Keystore
4. ✅ Lade die neue AAB-Datei hoch

---

## Prüfe alle vorhandenen Keystores

Führe diesen Befehl aus, um alle Keystores auf deinem Computer zu finden:

```bash
find ~ -name "*.jks" -o -name "*.keystore" 2>/dev/null
```

Dann prüfe jeden Keystore:

```bash
keytool -list -v -keystore [KEystore-Pfad] | grep SHA1
```

Suche nach dem Keystore mit SHA1: `8B:D6:C9:61:7D:6D:A6:28:15:73:89:4D:8D:76:51:3A:3D:0D:46:E2`

---

## Nächste Schritte

1. **Suche nach dem ursprünglichen Keystore**
2. **Erstelle `apps/parent/android/key.properties`** mit:
   ```
   storePassword=[DEIN_KEYSTORE_PASSWORT]
   keyPassword=[DEIN_KEY_PASSWORT]
   keyAlias=[DEIN_ALIAS]
   storeFile=[PFAD_ZUM_KEYSTORE]
   ```
3. **Baue die AAB-Datei neu:**
   ```bash
   cd apps/parent
   flutter clean
   flutter build appbundle --release
   ```
4. **Lade die neue AAB-Datei hoch**

---

## Hilfe

Wenn du den ursprünglichen Keystore nicht findest:
- Kontaktiere Google Play Support
- Prüfe, ob Google Play App Signing aktiviert ist
- Suche in Backups und Passwort-Managern

