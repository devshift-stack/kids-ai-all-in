# Datenschutzerklärung für Google Play Console

## ⚠️ WICHTIG: Datenschutzerklärung erforderlich

Die App verwendet die Berechtigung `android.permission.RECORD_AUDIO` (Mikrofon-Zugriff) und benötigt daher eine Datenschutzerklärung.

## Was du tun musst:

### 1. Datenschutzerklärung erstellen

Du musst eine Datenschutzerklärung (Privacy Policy) auf einer öffentlich zugänglichen Webseite bereitstellen.

**Beispiel-Inhalt für Li KI Training:**

```
Datenschutzerklärung für Li KI Training

1. Erhebung von Daten
   - Die App verwendet das Mikrofon, um Sprachaufnahmen für Therapiezwecke zu erstellen.
   - Audioaufnahmen werden lokal auf dem Gerät gespeichert.
   - Optional können Aufnahmen in Firebase gespeichert werden (nur mit Zustimmung).

2. Verwendung der Daten
   - Audioaufnahmen werden ausschließlich für Sprachtherapie-Übungen verwendet.
   - Keine Weitergabe an Dritte.
   - Keine kommerzielle Nutzung.

3. Speicherung
   - Lokale Speicherung auf dem Gerät.
   - Optional: Cloud-Speicherung in Firebase (mit Zustimmung).

4. Ihre Rechte
   - Sie können jederzeit die App löschen.
   - Sie können gespeicherte Daten löschen.
   - Sie können der Datenspeicherung widersprechen.

5. Kontakt
   [Ihre Kontaktinformationen]
```

### 2. Datenschutzerklärung in Google Play Console hinzufügen

1. Gehe zu **Google Play Console** → **Richtlinie** → **App-Inhalt**
2. Scrolle zu **Datenschutz**
3. Klicke auf **Datenschutzerklärung**
4. Füge die URL deiner Datenschutzerklärung ein (z.B. `https://deine-website.de/datenschutz`)

### 3. Alternative: Temporäre Datenschutzerklärung

Falls du noch keine Webseite hast, kannst du eine kostenlose Datenschutzerklärung erstellen:

- **Option 1:** Google Sites (kostenlos)
  - Erstelle eine Google Site mit der Datenschutzerklärung
  - URL: `https://sites.google.com/view/li-ki-training-datenschutz`

- **Option 2:** GitHub Pages (kostenlos)
  - Erstelle eine GitHub-Seite mit der Datenschutzerklärung
  - URL: `https://dein-username.github.io/li-ki-training-datenschutz`

- **Option 3:** Datenschutz-Generator
  - Nutze einen kostenlosen Datenschutz-Generator
  - z.B. https://www.datenschutz-generator.de/

## Wichtige Hinweise:

- ✅ Die Datenschutzerklärung muss **öffentlich zugänglich** sein
- ✅ Die URL muss **HTTPS** verwenden (nicht HTTP)
- ✅ Die Datenschutzerklärung muss **auf Deutsch** sein (oder in der Sprache deiner Zielgruppe)
- ✅ Die Datenschutzerklärung muss **aktuell** sein und alle verwendeten Berechtigungen abdecken

## Berechtigungen in der App:

Die App verwendet folgende Berechtigungen, die in der Datenschutzerklärung erwähnt werden müssen:

- `android.permission.RECORD_AUDIO` - Mikrofon-Zugriff für Sprachaufnahmen
- `android.permission.INTERNET` - Internet-Zugriff für Firebase
- `android.permission.WRITE_EXTERNAL_STORAGE` - Speicher-Zugriff (falls verwendet)

## Nächste Schritte:

1. ✅ Version Code erhöht (1 → 2)
2. ✅ Neue AAB-Datei erstellt
3. ⏳ Datenschutzerklärung erstellen und URL bereitstellen
4. ⏳ Datenschutzerklärung in Google Play Console hinzufügen
5. ⏳ Neue AAB-Datei hochladen

