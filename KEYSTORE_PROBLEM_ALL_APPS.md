# ⚠️ KRITISCH: Keystore-Problem für alle Apps

## Problem
**Alle drei Apps** (Alanko, Lianko, Parent) wurden mit dem **falschen Keystore** signiert.

## Erwarteter SHA1-Fingerabdruck (von Google Play):
```
SHA1: 8B:D6:C9:61:7D:6D:A6:28:15:73:89:4D:8D:76:51:3A:3D:0D:46:E2
```

## Aktueller SHA1-Fingerabdruck (der hochgeladenen AABs):
```
SHA1: D8:DE:0E:C5:F2:BD:03:86:A2:F7:F8:46:08:0E:AB:BC:CB:91:84:2D
```

**WICHTIG:** Alle drei Apps verwenden **denselben ursprünglichen Keystore**!

---

## Lösung: Den ursprünglichen Keystore finden

### Option 1: Den ursprünglichen Keystore verwenden (EMPFOHLEN)

**Schritte:**
1. Suche nach dem ursprünglichen Keystore auf deinem Computer
2. Prüfe den SHA1-Fingerabdruck:
   ```bash
   keytool -list -v -keystore [KEystore-Pfad] -alias [Alias-Name]
   ```
3. Der SHA1-Fingerabdruck muss sein: `8B:D6:C9:61:7D:6D:A6:28:15:73:89:4D:8D:76:51:3A:3D:0D:46:E2`

**Wo könnte der Keystore sein?**
- Auf deinem Computer (Backup-Ordner, Downloads, Desktop)
- In einem Passwort-Manager (als Backup)
- Bei einem Kollegen/Team-Mitglied
- In einem Cloud-Backup (Dropbox, Google Drive, OneDrive, etc.)
- In einem alten Projekt-Ordner

### Option 2: Google Play App Signing verwenden

Wenn du **Google Play App Signing** aktiviert hast, kann Google den Keystore für dich verwalten.

**Prüfe in Google Play Console:**
1. Gehe zu: **Release** → **Setup** → **App Signing**
2. Wenn "Google Play App Signing" aktiviert ist:
   - Du kannst einen neuen Upload-Key erstellen
   - Google verwaltet den App-Signing-Key für dich
   - Folge den Anweisungen in der Console

**WICHTIG:** In der Console siehst du auch den Link **"Signaturschlüssel ändern"** (Change signing key) - das ist die Lösung!

### Option 3: Neuen Upload-Key hochladen (nur wenn App Signing aktiviert)

Wenn Google Play App Signing aktiviert ist:
1. Klicke auf **"Signaturschlüssel ändern"** in der Google Play Console
2. Erstelle einen neuen Upload-Key
3. Lade den neuen Upload-Key in Google Play Console hoch
4. Verwende diesen neuen Key für zukünftige Uploads

---

## Wenn der ursprüngliche Keystore verloren ist

⚠️ **WARNUNG:** Wenn der ursprüngliche Keystore verloren ist, ist es **sehr schwierig**, die Apps zu aktualisieren.

**Mögliche Lösungen:**
1. **Google Play Support kontaktieren** - Sie können helfen, aber es ist ein langer Prozess
2. **Google Play App Signing aktivieren** - Wenn noch nicht aktiviert, kann Google helfen
3. **Neue Apps erstellen** - Erstelle neue Apps mit neuen Package-IDs (nicht empfohlen, verliert alle Bewertungen/Downloads)

---

## Aktuelle Situation

Alle drei Apps wurden wahrscheinlich mit einem **Debug-Keystore** oder einem **neuen Keystore** signiert, der nicht mit dem ursprünglichen übereinstimmt.

**Was du jetzt tun musst:**
1. ✅ Finde den ursprünglichen Keystore mit SHA1: `8B:D6:C9:61:7D:6D:A6:28:15:73:89:4D:8D:76:51:3A:3D:0D:46:E2`
2. ✅ Erstelle `key.properties` Dateien für alle drei Apps mit diesem Keystore
3. ✅ Baue die AAB-Dateien neu mit dem richtigen Keystore
4. ✅ Lade die neuen AAB-Dateien hoch

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

## Setup für alle drei Apps

Sobald du den richtigen Keystore gefunden hast, erstelle `key.properties` für alle drei Apps:

### apps/alanko/android/key.properties
```
storePassword=[DEIN_KEYSTORE_PASSWORT]
keyPassword=[DEIN_KEY_PASSWORT]
keyAlias=[DEIN_ALIAS]
storeFile=[PFAD_ZUM_KEYSTORE]
```

### apps/lianko/android/key.properties
```
storePassword=[DEIN_KEYSTORE_PASSWORT]
keyPassword=[DEIN_KEY_PASSWORT]
keyAlias=[DEIN_ALIAS]
storeFile=[PFAD_ZUM_KEYSTORE]
```

### apps/parent/android/key.properties
```
storePassword=[DEIN_KEYSTORE_PASSWORT]
keyPassword=[DEIN_KEY_PASSWORT]
keyAlias=[DEIN_ALIAS]
storeFile=[PFAD_ZUM_KEYSTORE]
```

**WICHTIG:** Alle drei Apps verwenden **denselben Keystore**!

---

## Neue AAB-Dateien erstellen

Nachdem du die `key.properties` Dateien erstellt hast:

```bash
# Alanko
cd apps/alanko
flutter clean
flutter build appbundle --release

# Lianko
cd apps/lianko
flutter clean
flutter build appbundle --release

# Parent
cd apps/parent
flutter clean
flutter build appbundle --release
```

---

## Schnelllösung: Google Play App Signing

**Die einfachste Lösung:** Nutze die Funktion **"Signaturschlüssel ändern"** in der Google Play Console!

1. Gehe zu jeder App in Google Play Console
2. Klicke auf **"Signaturschlüssel ändern"** (Change signing key)
3. Folge den Anweisungen, um einen neuen Upload-Key zu erstellen
4. Verwende diesen neuen Key für zukünftige Uploads

---

## Hilfe

Wenn du den ursprünglichen Keystore nicht findest:
- ✅ Nutze **"Signaturschlüssel ändern"** in Google Play Console (EMPFOHLEN)
- Kontaktiere Google Play Support
- Prüfe, ob Google Play App Signing aktiviert ist
- Suche in Backups und Passwort-Managern

