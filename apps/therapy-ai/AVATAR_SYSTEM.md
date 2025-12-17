# 🎭 Avatar-System für Therapy AI

Detaillierte Spezifikation für das Avatar-System mit Bild-Upload und Animationen.

---

## 📸 Avatar-Erstellung Workflow

### Schritt 1: Bild-Upload (6-10 Bilder)

#### Bild-Anforderungen
- **Format:** JPG, PNG
- **Größe:** Minimum 512x512px, empfohlen 1024x1024px
- **Qualität:** Hochauflösend, gut beleuchtet
- **Hintergrund:** Einfarbig (weiß/grau) oder transparent

#### Benötigte Posen/Winkel
1. **Frontal** - Geradeaus schauen, neutral
2. **Frontal lächelnd** - Freundliches Gesicht
3. **Profil links** - Seitenansicht
4. **Profil rechts** - Seitenansicht
5. **3/4 Ansicht links** - Schräg von links
6. **3/4 Ansicht rechts** - Schräg von rechts
7. **Nach oben schauen** - Für Animationen
8. **Nach unten schauen** - Für Animationen
9. **Verschiedene Emotionen** (optional):
   - Freude
   - Ermutigung
   - Konzentration

#### Upload-Interface
```
┌─────────────────────────────────┐
│  Avatar erstellen               │
├─────────────────────────────────┤
│                                 │
│  📸 Lade 6-10 Bilder hoch      │
│                                 │
│  [Bild 1] [Bild 2] [Bild 3]    │
│  [Bild 4] [Bild 5] [Bild 6]    │
│  [+ Bild] [+ Bild]             │
│                                 │
│  ✅ Mindestens 6 Bilder        │
│                                 │
│  [Avatar generieren]            │
└─────────────────────────────────┘
```

---

## 🤖 Avatar-Generierung

### Option A: Ready Player Me API (Empfohlen)

**Vorteile:**
- ✅ Einfache Integration
- ✅ Gute Qualität
- ✅ Animierbar
- ✅ Free Tier verfügbar
- ✅ WebGL/Unity Support

**API Integration:**
```dart
// Upload Bilder
POST https://api.readyplayer.me/v1/avatars
{
  "images": [base64_encoded_images...],
  "quality": "high"
}

// Avatar generieren
POST https://api.readyplayer.me/v1/avatars/{id}/generate

// Avatar abrufen
GET https://api.readyplayer.me/v1/avatars/{id}
```

**Kosten:**
- Free: 10 Avatare/Monat
- Pro: $9/Monat (unbegrenzt)

### Option B: Custom AI Solution

**Backend-Setup:**
- Python Flask/FastAPI
- Stable Diffusion / Custom Model
- 3D-Modell-Generierung
- Texture-Mapping

**Vorteile:**
- ✅ Volle Kontrolle
- ✅ Eigene Branding
- ✅ Keine API-Limits

**Nachteile:**
- ❌ Höhere Entwicklungskosten
- ❌ Server-Infrastruktur nötig
- ❌ Wartungsaufwand

---

## 🎬 Animationen & Bewegungen

### Lip-Sync (Mund-Bewegungen)
- [ ] **Audio → Viseme Mapping**
  - Phoneme zu Viseme-Konvertierung
  - Real-time Synchronisation
  - Natürliche Mund-Bewegungen

### Gesichts-Animationen
- [ ] **Emotionen**
  - Freude (Lächeln)
  - Ermutigung (aufmunternd)
  - Konzentration (ernst)
  - Überraschung (bei Erfolg)

- [ ] **Blick-Richtung**
  - Folgt dem Kind (Eye-Tracking)
  - Blickkontakt während Übungen
  - Abwechslungsreiche Bewegungen

### Körper-Bewegungen
- [ ] **Gestik**
  - Zeigen (auf Übungen)
  - Klatschen (bei Erfolg)
  - Ermutigende Gesten

- [ ] **Haltung**
  - Aufmerksam (während Übung)
  - Entspannt (zwischen Übungen)
  - Aktiv (bei Interaktion)

---

## 💾 Daten-Modell

### Avatar Model
```dart
@freezed
class Avatar with _$Avatar {
  const factory Avatar({
    required String id,
    required String childProfileId,
    
    // Uploaded Images
    required List<String> uploadedImageUrls, // Firebase Storage URLs
    required int imageCount, // 6-10
    
    // Generated Avatar
    String? avatarModelUrl, // 3D Model URL
    String? avatarTextureUrl, // Texture URL
    String? avatarThumbnailUrl, // Preview
    
    // Configuration
    required AvatarConfig config,
    
    // Status
    @Default(AvatarStatus.uploading) AvatarStatus status,
    
    // Metadata
    required DateTime createdAt,
    DateTime? generatedAt,
  }) = _Avatar;
}

enum AvatarStatus {
  uploading,    // Bilder werden hochgeladen
  processing,   // Avatar wird generiert
  ready,        // Avatar fertig
  error,        // Fehler bei Generierung
}
```

### Avatar Config
```dart
@freezed
class AvatarConfig with _$AvatarConfig {
  const factory AvatarConfig({
    // Animation Settings
    @Default(true) bool lipSyncEnabled,
    @Default(true) bool bodyMovementsEnabled,
    @Default(true) bool eyeTrackingEnabled,
    
    // Emotion Settings
    @Default('friendly') String defaultEmotion,
    List<String> availableEmotions, // ['happy', 'encouraging', 'focused']
    
    // Appearance
    String? customClothing,
    String? customHair,
    
    // Behavior
    @Default(0.5) double animationIntensity, // 0.0 - 1.0
    @Default(true) bool reactiveAnimations, // Reagiert auf Kind
  }) = _AvatarConfig;
}
```

---

## 🎨 UI-Komponenten

### Avatar Upload Screen
```dart
class AvatarUploadScreen extends StatefulWidget {
  // Upload-Interface
  // Bild-Vorschau
  // Qualitäts-Prüfung
  // Progress-Anzeige
}
```

### Avatar Preview Widget
```dart
class AvatarPreviewWidget extends StatelessWidget {
  // 3D Avatar-Anzeige
  // Animationen
  // Interaktionen
}
```

### Avatar Animation Controller
```dart
class AvatarAnimationController {
  // Lip-Sync steuern
  // Emotionen ändern
  // Bewegungen auslösen
}
```

---

## 🔧 Integration in Therapy App

### In Exercise Screen
```dart
// Avatar zeigt Übung an
AvatarWidget(
  avatar: childProfile.avatar,
  animation: AvatarAnimation.speaking,
  text: exercise.targetWord,
)
```

### In Results Screen
```dart
// Avatar gibt Feedback
AvatarWidget(
  avatar: childProfile.avatar,
  animation: result.isSuccessful 
    ? AvatarAnimation.celebrating
    : AvatarAnimation.encouraging,
  emotion: 'happy',
)
```

---

## 📱 Web UI für Avatar-Management

### Avatar Upload Interface
- [ ] **Multi-File Upload**
  - Drag & Drop
  - Datei-Auswahl
  - Bild-Vorschau
  - Qualitäts-Check

- [ ] **Bild-Editor** (optional)
  - Zuschneiden
  - Helligkeit/Kontrast
  - Hintergrund entfernen

- [ ] **Avatar-Konfiguration**
  - Emotionen auswählen
  - Animationen aktivieren
  - Stil anpassen

### Avatar-Test Interface
- [ ] **Live-Vorschau**
  - Avatar testen
  - Animationen testen
  - Verschiedene Emotionen

---

## 🚀 Implementierungs-Plan

### Phase 1: Basis-Upload
- [ ] Bild-Upload-Interface
- [ ] Firebase Storage Integration
- [ ] Bild-Validierung

### Phase 2: Avatar-Generierung
- [ ] Ready Player Me Integration
- [ ] Avatar-Generierung
- [ ] Avatar-Speicherung

### Phase 3: Animationen
- [ ] Lip-Sync Integration
- [ ] Emotionen
- [ ] Körper-Bewegungen

### Phase 4: Integration
- [ ] Avatar in Therapy-App
- [ ] Reaktive Animationen
- [ ] Performance-Optimierung

---

## 💰 Kosten-Schätzung

### Ready Player Me
- **Free Tier:** 10 Avatare/Monat
- **Pro:** $9/Monat (unbegrenzt)
- **Enterprise:** Custom Pricing

### Custom Solution
- **Server:** ~$20-50/Monat
- **Storage:** ~$5-10/Monat
- **Entwicklung:** Einmalig ~40-80h

---

## 🔗 Ressourcen

- **Ready Player Me:** https://readyplayer.me
- **API Docs:** https://docs.readyplayer.me
- **Unity Integration:** https://github.com/readyplayerme/rpm-unity-sdk

---

**Status:** 📋 Geplant  
**Empfehlung:** Start mit Ready Player Me für schnelle Integration

