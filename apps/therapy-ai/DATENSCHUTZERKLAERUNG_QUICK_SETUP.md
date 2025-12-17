# 🚀 Schnell-Setup: Datenschutzerklärung für Li KI Training

## ⚠️ Problem
Google Play Console benötigt eine Datenschutzerklärung für die Berechtigung `RECORD_AUDIO` (Mikrofon).

## ✅ Lösung in 3 Schritten

### Schritt 1: Datenschutzerklärung erstellen

**Option A: Google Sites (Kostenlos, 2 Minuten)**
1. Gehe zu: https://sites.google.com
2. Klicke auf "Leer" (Blank)
3. Füge den Text aus `DATENSCHUTZERKLAERUNG_VORLAGE.txt` ein
4. Klicke auf "Veröffentlichen"
5. Kopiere die URL (z.B. `https://sites.google.com/view/li-ki-training-datenschutz`)

**Option B: GitHub Pages (Kostenlos, 5 Minuten)**
1. Erstelle ein neues GitHub Repository: `li-ki-training-datenschutz`
2. Erstelle eine Datei `index.html` mit dem Datenschutztext
3. Aktiviere GitHub Pages in den Repository-Einstellungen
4. Kopiere die URL (z.B. `https://dein-username.github.io/li-ki-training-datenschutz`)

**Option C: Eigene Webseite**
- Lade die Datenschutzerklärung auf deine bestehende Webseite hoch
- Stelle sicher, dass die URL HTTPS verwendet

### Schritt 2: Datenschutzerklärung in Google Play Console hinzufügen

1. Gehe zu: **Google Play Console** → **Li KI Training App**
2. Klicke auf: **Richtlinie** (im linken Menü)
3. Klicke auf: **App-Inhalt**
4. Scrolle zu: **Datenschutz**
5. Klicke auf: **Datenschutzerklärung**
6. Füge die URL ein (z.B. `https://sites.google.com/view/li-ki-training-datenschutz`)
7. Klicke auf: **Speichern**

### Schritt 3: AAB-Datei erneut hochladen

Nachdem die Datenschutzerklärung hinzugefügt wurde:
1. Gehe zurück zu: **Release** → **Production** (oder **Internal Testing**)
2. Lade die AAB-Datei erneut hoch: `lik-training-release.aab`
3. Die Fehlermeldung sollte jetzt verschwunden sein

---

## 📝 Vorlage für Datenschutzerklärung

Siehe `DATENSCHUTZERKLAERUNG_VORLAGE.txt` im Desktop-Ordner.

---

## ✅ Checkliste

- [ ] Datenschutzerklärung erstellt (Google Sites, GitHub Pages, oder eigene Webseite)
- [ ] URL ist HTTPS (nicht HTTP)
- [ ] Datenschutzerklärung in Google Play Console hinzugefügt
- [ ] AAB-Datei erneut hochgeladen
- [ ] Fehlermeldung verschwunden

---

## 🆘 Hilfe

**Falls die Datenschutzerklärung nicht akzeptiert wird:**
- Stelle sicher, dass die URL **öffentlich zugänglich** ist
- Stelle sicher, dass die URL **HTTPS** verwendet (nicht HTTP)
- Stelle sicher, dass die Seite **auf Deutsch** ist (oder in der Sprache deiner Zielgruppe)
- Warte ein paar Minuten, bis Google die Seite indiziert hat

