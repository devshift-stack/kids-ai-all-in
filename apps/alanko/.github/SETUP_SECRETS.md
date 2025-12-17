# GitHub Secrets Setup für Alanko CI/CD

Diese Anleitung zeigt, wie du GitHub Secrets für automatische Builds einrichtest.

---

## 🔑 Benötigte Secrets

### 1. GEMINI_API_KEY (Neu hinzugefügt)

**Beschreibung:** API-Key für Google Gemini AI

**Wo holen:**
- 🌐 https://aistudio.google.com/apikey
- Erstelle einen neuen Key
- Kopiere den Key

**Hinzufügen:**
```
1. Gehe zu: https://github.com/devshift-stack/Kids-AI-Train-Alanko/settings/secrets/actions
2. Klicke "New repository secret"
3. Name: GEMINI_API_KEY
4. Value: AIzaSy...dein_production_key
5. Klicke "Add secret"
```

---

### 2. FIREBASE_APP_ID (Bereits vorhanden)

**Beschreibung:** Firebase App ID für App Distribution

**Wo finden:**
```
Firebase Console → Project Settings → General
→ Your apps → Alanko Android → App ID
```

---

### 3. FIREBASE_SERVICE_ACCOUNT (Bereits vorhanden)

**Beschreibung:** Service Account für Firebase App Distribution

**Erstellen:**
```
1. Firebase Console → Project Settings → Service accounts
2. Generate new private key
3. Speichere JSON-Datei
4. Inhalt als Secret hinzufügen
```

---

## ✅ Secrets Checkliste

Nach dem Setup sollten folgende Secrets vorhanden sein:

- [ ] `GEMINI_API_KEY` - Für AI-Funktionen
- [ ] `FIREBASE_APP_ID` - Für App Distribution
- [ ] `FIREBASE_SERVICE_ACCOUNT` - Für Firebase Auth

**Prüfen:**
```
GitHub Repo → Settings → Secrets and variables → Actions
→ Sollte 3 Secrets zeigen
```

---

## 🧪 CI/CD Testen

### Trigger einen Build:

**Option 1: Push auf main**
```bash
git push origin main
```

**Option 2: Pull Request erstellen**
```bash
git checkout -b test/ci-setup
git commit --allow-empty -m "test: CI/CD Setup"
git push origin test/ci-setup
gh pr create --title "test: CI/CD" --body "Testing CI/CD"
```

**Option 3: Manueller Trigger**
```
GitHub → Actions → Flutter CI/CD → Run workflow
```

---

## 📊 Build Status prüfen

```
GitHub → Actions → Letzte Workflow Runs

✅ Build erfolgreich:
   → APK wurde gebaut
   → Mit GEMINI_API_KEY
   → Hochgeladen zu Firebase

❌ Build fehlgeschlagen:
   → Prüfe Logs
   → Secrets korrekt gesetzt?
```

---

## 🔒 Sicherheits-Best-Practices

### ✅ DO:
- ✅ Verschiedene Keys für CI/CD und Development
- ✅ Production Key nur für main branch
- ✅ Regelmäßig Keys rotieren
- ✅ Keys mit minimalen Permissions

### ❌ DON'T:
- ❌ Development Keys in GitHub Secrets
- ❌ Keys in Log-Ausgaben printen
- ❌ Keys mit allen Permissions

---

## 🚨 Troubleshooting

### Problem: "GEMINI_API_KEY not set"

**Lösung:**
```
1. Gehe zu GitHub Secrets
2. Prüfe ob GEMINI_API_KEY existiert
3. Key korrekt? Keine Leerzeichen?
4. Repository-Secret, nicht Organization-Secret?
```

---

### Problem: Build schlägt fehl mit "Invalid API Key"

**Mögliche Ursachen:**
1. Key im Secret hat Leerzeichen
2. Falscher Key-Typ (nicht für Gemini)
3. Key deaktiviert in Google Cloud

**Lösung:**
```bash
# Key testen:
curl "https://generativelanguage.googleapis.com/v1beta/models?key=YOUR_KEY"

# Sollte Liste von Models zurückgeben
```

---

### Problem: APK baut, aber AI funktioniert nicht

**Ursache:** Key wurde nicht übergeben

**Prüfen:**
```yaml
# .github/workflows/ci.yml sollte haben:
- name: Build APK
  env:
    GEMINI_API_KEY: ${{ secrets.GEMINI_API_KEY }}
  run: |
    flutter build apk \
      --dart-define=GEMINI_API_KEY=$GEMINI_API_KEY \
      --release
```

---

## 📝 Workflow Übersicht

```
┌─────────────────────────────────────────────────────┐
│  GitHub Push/PR                                     │
└──────────────────┬──────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────┐
│  1. Setup Flutter                                   │
│     - Install Flutter 3.24.0                       │
│     - Cache dependencies                            │
└──────────────────┬──────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────┐
│  2. Get Dependencies                                │
│     - flutter pub get                               │
└──────────────────┬──────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────┐
│  3. Analyze & Test                                  │
│     - flutter analyze                               │
│     - flutter test                                  │
└──────────────────┬──────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────┐
│  4. Build APK (mit GEMINI_API_KEY)                 │
│     - Lade Secret: GEMINI_API_KEY                  │
│     - flutter build apk --dart-define=...          │
└──────────────────┬──────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────┐
│  5. Upload APK                                      │
│     - GitHub Artifacts                              │
│     - Firebase App Distribution (nur main)         │
└─────────────────────────────────────────────────────┘
```

---

## 🔄 Key Rotation

### Wann Keys ändern?

- 🔴 **Sofort:** Key wurde öffentlich (committed, gezeigt)
- 🟡 **Regelmäßig:** Alle 90 Tage (Best Practice)
- 🟢 **Optional:** Bei Team-Wechsel

### Wie Keys ändern:

```bash
# 1. Neuen Key bei Google generieren
# 2. GitHub Secret aktualisieren
#    → Settings → Secrets → GEMINI_API_KEY → Update

# 3. Test-Build triggern
git commit --allow-empty -m "chore: Test new API key"
git push

# 4. Alten Key bei Google löschen
```

---

## 💬 Support

Bei Problemen:
1. Prüfe GitHub Actions Logs
2. Siehe README_API_SETUP.md
3. Erstelle Issue mit:
   - Build-Log (ohne Secrets!)
   - Error-Message
   - Was du bereits probiert hast

---

**✅ Setup komplett! CI/CD läuft automatisch bei jedem Push.**
