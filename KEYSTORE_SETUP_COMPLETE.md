# ✅ Keystore-Setup abgeschlossen

## Was wurde gemacht:

1. ✅ **Neuer gemeinsamer Keystore erstellt** für alle drei Apps
   - Datei: `kids-ai-shared-release-key.jks`
   - Alias: `kids-ai`
   - Passwort: `kidsai123456`

2. ✅ **key.properties Dateien erstellt** für alle drei Apps:
   - `apps/parent/android/key.properties`
   - `apps/alanko/android/key.properties`
   - `apps/lianko/android/key.properties`

3. ✅ **Keystore zu allen Apps kopiert**

4. ✅ **Parent AAB-Datei neu gebaut** mit dem neuen Keystore

---

## ⚠️ WICHTIG: Google Play Console Setup

Da der ursprüngliche Keystore nicht gefunden wurde, musst du **"Signaturschlüssel ändern"** in Google Play Console nutzen:

### Für jede App (Alanko, Lianko, Parent):

1. **Gehe zu Google Play Console** → Wähle die App
2. **Klicke auf "Signaturschlüssel ändern"** (Change signing key)
3. **Lade den neuen Upload-Key hoch:**
   - Keystore-Datei: `apps/[APP_NAME]/android/app/kids-ai-shared-release-key.jks`
   - Alias: `kids-ai`
   - Passwort: `kidsai123456`

4. **Folge den Anweisungen** in der Console

---

## Neue AAB-Dateien erstellen

Nachdem du den Upload-Key in Google Play Console hochgeladen hast:

```bash
# Alanko
cd apps/alanko
flutter clean
flutter build appbundle --release

# Lianko
cd apps/lianko
flutter clean
flutter build appbundle --release

# Parent (bereits erstellt)
# Datei: ~/Desktop/kids-ai-builds/parent-release.aab
```

---

## Keystore-Informationen

**Dateipfad:** `apps/[APP_NAME]/android/app/kids-ai-shared-release-key.jks`
**Alias:** `kids-ai`
**Store-Passwort:** `kidsai123456`
**Key-Passwort:** `kidsai123456`

**WICHTIG:** Bewahre diese Informationen sicher auf! Der Keystore ist für alle zukünftigen Updates erforderlich.

---

## Nächste Schritte

1. ✅ Keystore erstellt
2. ✅ key.properties konfiguriert
3. ✅ Parent AAB-Datei erstellt
4. ⏳ **"Signaturschlüssel ändern" in Google Play Console für alle drei Apps**
5. ⏳ Alanko und Lianko AAB-Dateien erstellen
6. ⏳ Alle AAB-Dateien hochladen

