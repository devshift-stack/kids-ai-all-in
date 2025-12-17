# UI/UX Implementation Plan - v0-kids-ai-ui Design

**Datum:** 2025-12-17  
**Basis:** v0-kids-ai-ui Repository (devshift-stack)  
**Status:** Teilweise implementiert

---

## 📋 Übersicht

Dieses Dokument listet alle Features aus dem v0-kids-ai-ui Design auf, die noch in Flutter implementiert werden müssen.

**Fortschritt:** 3/13 Hauptkomponenten ✅ | 10/13 fehlen noch ❌

---

## 🔴 PHASE 1: Kritische Basis-Komponenten (HOCH)

### 1.1 Progress Widget ⚠️ FEHLT
**Status:** ❌ Nicht implementiert  
**Priorität:** 🔴 HOCH  
**Aufwand:** 2h

**Was fehlt:**
- Wiederverwendbares `ModernProgress` Widget
- Animation beim Laden
- Farbige Varianten (bg-blue-500, bg-green-500, etc.)
- Verschiedene Höhen (h-2, h-3)

**Referenz (v0):**
```tsx
<Progress value={68} className="h-3 mb-2" />
<Progress value={progress} className="h-2" indicatorClassName={color} />
```

**Zu implementieren:**
```dart
// packages/shared/lib/src/widgets/modern_progress.dart
class ModernProgress extends StatelessWidget {
  final double value; // 0.0 - 1.0
  final double height;
  final Color? color;
  final bool animated;
}
```

**Verwendung:**
- Child Dashboard: Progress Overview
- Activity Cards: Progress Bars
- Challenge Cards: Completion Progress
- Parent Dashboard: Learning Progress Section

---

### 1.2 Badge Widget ⚠️ FEHLT
**Status:** ❌ Nicht implementiert  
**Priorität:** 🔴 HOCH  
**Aufwand:** 1.5h

**Was fehlt:**
- Wiederverwendbares `ModernBadge` Widget
- Varianten (default, secondary, success, etc.)
- Für Achievements "Otključano" Status

**Referenz (v0):**
```tsx
<Badge className="mt-2 bg-green-500 hover:bg-green-600 text-white">
  Otključano
</Badge>
```

**Zu implementieren:**
```dart
// packages/shared/lib/src/widgets/modern_badge.dart
class ModernBadge extends StatelessWidget {
  final String text;
  final BadgeVariant variant;
  final Color? backgroundColor;
}
```

**Verwendung:**
- Child Progress Page: Achievement Badges
- Challenge Cards: Completion Status

---

### 1.3 ProgressItem Widget ⚠️ FEHLT
**Status:** ❌ Nicht implementiert  
**Priorität:** 🔴 HOCH  
**Aufwand:** 1h

**Was fehlt:**
- Widget für Learning Progress Items
- Label + Prozent rechts
- Colored Progress Bar

**Referenz (v0):**
```tsx
<ProgressItem label="Čitanje i pisanje" value={85} color="bg-blue-500" />
```

**Zu implementieren:**
```dart
// packages/shared/lib/src/widgets/progress_item.dart
class ProgressItem extends StatelessWidget {
  final String label;
  final double value; // 0-100
  final Color color;
}
```

**Verwendung:**
- Parent Dashboard: Learning Progress Section

---

### 1.4 ActivityItem Widget ⚠️ FEHLT
**Status:** ❌ Nicht implementiert  
**Priorität:** 🔴 HOCH  
**Aufwand:** 1h

**Was fehlt:**
- Widget für Recent Activity Items
- Activity Text + Time Text
- Points Badge rechts

**Referenz (v0):**
```tsx
<ActivityItem 
  time="Prije 2 sata" 
  activity="Lekcija 'Učenje slova' završena" 
  points={20} 
/>
```

**Zu implementieren:**
```dart
// packages/shared/lib/src/widgets/activity_item.dart
class ActivityItem extends StatelessWidget {
  final String activity;
  final String time;
  final int points;
}
```

**Verwendung:**
- Parent Dashboard: Recent Activity Section

---

## 🟡 PHASE 2: Screen-Komponenten (MITTEL)

### 2.1 Child Dashboard - Vollständige Implementierung ⚠️ FEHLT
**Status:** ❌ Nicht implementiert  
**Priorität:** 🟡 MITTEL  
**Aufwand:** 4h

**Was fehlt:**
- Progress Overview Card (mit Sternen-Anzeige)
- Learning Activities Grid (4 ActivityCards)
- Today's Challenges Section (2 ChallengeCards)

**Referenz (v0):** `app/child/page.tsx`

**Zu implementieren:**
```dart
// apps/alanko/lib/screens/dashboard/child_dashboard_screen.dart
// apps/lianko/lib/screens/dashboard/child_dashboard_screen.dart
```

**Komponenten:**
- Progress Overview Card
- Activity Cards Grid (4x)
- Challenge Cards (2x)

---

### 2.2 Parent Dashboard - Vollständige Implementierung ⚠️ FEHLT
**Status:** ⚠️ Teilweise (nur Navigation)  
**Priorität:** 🟡 MITTEL  
**Aufwand:** 5h

**Was fehlt:**
- Child Profile Card (mit Avatar)
- Stats Grid (4 StatCards)
- Learning Progress Section (mit ProgressItems)
- Recent Activity Section (mit ActivityItems)
- Weekly Overview (7-Tage-Grid)

**Referenz (v0):** `app/parent/page.tsx`

**Zu implementieren:**
```dart
// apps/parent/lib/screens/dashboard/dashboard_screen.dart
// Erweitern mit:
// - Child Profile Card
// - Stats Grid
// - Learning Progress Card
// - Recent Activity Card
// - Weekly Overview Card
```

---

### 2.3 Child Progress Page ⚠️ FEHLT
**Status:** ❌ Nicht implementiert  
**Priorität:** 🟡 MITTEL  
**Aufwand:** 3h

**Was fehlt:**
- Stats Overview (4 StatCards)
- Weekly Progress Card (7 Tage mit Progress Bars)
- Achievements Grid (BadgeCards mit Emojis)

**Referenz (v0):** `app/child/progress/page.tsx`

**Zu implementieren:**
```dart
// apps/alanko/lib/screens/progress/progress_screen.dart
// apps/lianko/lib/screens/progress/progress_screen.dart
```

**Komponenten:**
- StatCard (4x)
- Weekly Progress Card
- BadgeCard Grid (12x)

---

### 2.4 Parent Settings - Vollständige Implementierung ⚠️ FEHLT
**Status:** ⚠️ Teilweise  
**Priorität:** 🟡 MITTEL  
**Aufwand:** 4h

**Was fehlt:**
- Profile Section (mit Inputs)
- Time Limits Section (mit Switches)
- Notifications Section (mit Switches)
- Content Controls Section (mit Switches)
- Audio Settings Section (mit Switches)
- Security Section (mit PIN Input)

**Referenz (v0):** `app/parent/settings/page.tsx`

**Zu implementieren:**
```dart
// apps/parent/lib/screens/settings/settings_screen.dart
// Erweitern mit ModernCard Sections
```

---

### 2.5 BadgeCard Widget ⚠️ FEHLT
**Status:** ❌ Nicht implementiert  
**Priorität:** 🟡 MITTEL  
**Aufwand:** 1h

**Was fehlt:**
- Widget für Achievement Badges
- Emoji (groß, 4xl)
- Titel
- Status Badge (Otključano/Unlocked)
- Opacity für locked (50%)

**Referenz (v0):**
```tsx
<BadgeCard emoji="🌟" title="Prvi koraci" unlocked />
```

**Zu implementieren:**
```dart
// packages/shared/lib/src/widgets/badge_card.dart
class BadgeCard extends StatelessWidget {
  final String emoji;
  final String title;
  final bool unlocked;
}
```

**Verwendung:**
- Child Progress Page: Achievements Grid

---

### 2.6 Weekly Overview Widget ⚠️ FEHLT
**Status:** ❌ Nicht implementiert  
**Priorität:** 🟡 MITTEL  
**Aufwand:** 2h

**Was fehlt:**
- 7-Tage-Grid Widget
- Tagesnamen (Pon, Uto, Sri, etc.)
- Zeit-Anzeige pro Tag
- Visueller Unterschied für aktive/inaktive Tage

**Referenz (v0):**
```tsx
<div className="grid grid-cols-7 gap-2">
  {["Pon", "Uto", "Sri", "Čet", "Pet", "Sub", "Ned"].map(...)}
</div>
```

**Zu implementieren:**
```dart
// packages/shared/lib/src/widgets/weekly_overview.dart
class WeeklyOverview extends StatelessWidget {
  final Map<String, String> dayData; // {"Pon": "30m", ...}
}
```

**Verwendung:**
- Parent Dashboard: Weekly Overview Card

---

## 🟢 PHASE 3: Navigation & Verbesserungen (NIEDRIG)

### 3.1 Child Nav - Transparent Design ⚠️ FEHLT
**Status:** ⚠️ Teilweise (ModernNavBar existiert, aber nicht transparent)  
**Priorität:** 🟢 NIEDRIG  
**Aufwand:** 1h

**Was fehlt:**
- Transparente Navigation mit Backdrop Blur
- Weißer Text auf Gradient
- `bg-white/10 backdrop-blur-md`

**Referenz (v0):**
```tsx
<nav className="border-b border-white/20 bg-white/10 backdrop-blur-md">
```

**Zu implementieren:**
```dart
// ModernNavBar erweitern mit:
// - isTransparent Parameter
// - Backdrop Blur
// - Weißer Text
```

**Verwendung:**
- Child Dashboard
- Child Progress Page
- Alle Child Screens

---

### 3.2 Hover Animationen ⚠️ FEHLT
**Status:** ❌ Nicht implementiert  
**Priorität:** 🟢 NIEDRIG  
**Aufwand:** 1h

**Was fehlt:**
- Hover Scale Effect (1.05x)
- Shadow Transition
- Smooth Animations

**Referenz (v0):**
```tsx
hover:shadow-2xl transition-all hover:scale-105
```

**Zu implementieren:**
```dart
// ModernCard erweitern mit:
// - GestureDetector für Hover (Desktop)
// - Scale Animation
// - Shadow Transition
```

---

### 3.3 Progress Animation ⚠️ FEHLT
**Status:** ❌ Nicht implementiert  
**Priorität:** 🟢 NIEDRIG  
**Aufwand:** 1h

**Was fehlt:**
- Smooth Animation beim Laden
- TweenAnimationBuilder für Progress

**Zu implementieren:**
```dart
// ModernProgress mit Animation
TweenAnimationBuilder<double>(
  tween: Tween(begin: 0, end: value),
  duration: Duration(milliseconds: 500),
  ...
)
```

---

### 3.4 Responsive Grids ⚠️ FEHLT
**Status:** ❌ Nicht implementiert  
**Priorität:** 🟢 NIEDRIG  
**Aufwand:** 2h

**Was fehlt:**
- Responsive Grid Layouts
- `md:grid-cols-4` → 4 Spalten auf Desktop, 2 auf Tablet, 1 auf Mobile
- `sm:grid-cols-2 lg:grid-cols-4` für Activities

**Referenz (v0):**
```tsx
<div className="grid md:grid-cols-4 gap-4">
<div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-4">
```

**Zu implementieren:**
```dart
// Responsive Grid Helper
LayoutBuilder(
  builder: (context, constraints) {
    final crossAxisCount = constraints.maxWidth > 1024 
      ? 4 
      : constraints.maxWidth > 640 
        ? 2 
        : 1;
    ...
  }
)
```

---

## 📊 Implementierungs-Übersicht

### Phase 1: Basis-Komponenten (HOCH)
- [ ] ModernProgress Widget (2h)
- [ ] ModernBadge Widget (1.5h)
- [ ] ProgressItem Widget (1h)
- [ ] ActivityItem Widget (1h)
**Gesamt:** ~5.5 Stunden

### Phase 2: Screen-Komponenten (MITTEL)
- [ ] Child Dashboard vollständig (4h)
- [ ] Parent Dashboard vollständig (5h)
- [ ] Child Progress Page (3h)
- [ ] Parent Settings vollständig (4h)
- [ ] BadgeCard Widget (1h)
- [ ] Weekly Overview Widget (2h)
**Gesamt:** ~19 Stunden

### Phase 3: Navigation & Verbesserungen (NIEDRIG)
- [ ] Child Nav transparent (1h)
- [ ] Hover Animationen (1h)
- [ ] Progress Animation (1h)
- [ ] Responsive Grids (2h)
**Gesamt:** ~5 Stunden

---

## 🎯 Gesamtaufwand

**Geschätzte Gesamtzeit:** ~29.5 Stunden

**Empfohlene Reihenfolge:**
1. Phase 1 komplett (Basis-Komponenten)
2. Phase 2 (Screen-Komponenten)
3. Phase 3 (Verbesserungen)

---

## ✅ Bereits implementiert

- [x] ModernCard Widget
- [x] ActivityCard Widget
- [x] ChallengeCard Widget
- [x] StatCard Widget
- [x] ModernNavBar Widget (teilweise)
- [x] Farbpalette (OKLCH-basiert)
- [x] Gradient (mainBackground)
- [x] Parent Dashboard Navigation
- [x] Alanko & Lianko Home Screens (Gradient)

---

## 📝 Notizen

- Alle Komponenten sollten im `packages/shared` Package erstellt werden
- Konsistente Verwendung von `KidsColors`, `KidsSpacing`, `KidsGradients`
- Alle Widgets sollten responsive sein
- Animationen sollten optional sein (Performance)

---

**Letzte Aktualisierung:** 2025-12-17  
**Nächste Schritte:** Phase 1 - Basis-Komponenten implementieren

