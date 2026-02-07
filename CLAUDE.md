# CLAUDE.md - Session Quick Start

**Version:** 2.0 (Flutter)
**Letzte Aktualisierung:** 2026-02-07
**Status:** Phase 2 abgeschlossen (~85%)

---

## 🎯 Projekt auf einen Blick

**GameForge Studio** - Flutter Mobile App für Minecraft Addon-Erstellung
- **Zielgruppe:** 7-jähriges Kind + Vater (kinderfreundlich!)
- **Tech-Stack:** Flutter + Dart, Material 3 Design, SharedPreferences
- **Platform:** Android (APK via GitHub Actions)
- **Status:** Migration von React Native → Flutter bei 85%

---

## 📱 Was funktioniert bereits? (Phase 1 + 2)

✅ **Login/Logout** - Username + GitHub Token (SharedPreferences)
✅ **Bottom Navigation** - 4 Tabs (Home, Bibliothek, Workshop, Settings)
✅ **HomeScreen** - Demo-Projekte, "Neues Projekt" Button
✅ **CreateProjectScreen** - 6 Kategorien (Waffen, Rüstung, Mobs, Nahrung, Blöcke, Werkzeuge)
✅ **WorkshopScreen MVP** - Item-Editor mit Slidern (Damage, Durability), Effekt-Toggles
✅ **SettingsScreen** - Logout-Button
✅ **Theme-System** - Material 3, Purple Theme (#8B5CF6), kinderfreundliche Touch-Targets
✅ **APK Build** - GitHub Actions baut erfolgreich (21 MB APK)

---

## ⏳ Was fehlt noch? (Phase 3 - TODOs)

### **Priorität 1: Daten-Integration**
- [ ] **vanilla_stats.json laden** - Item-Daten aus `library/vanilla_stats.json` einbinden
- [ ] **Projekt-Speicherung** - ProjectService mit SharedPreferences
- [ ] **HomeScreen dynamisch** - Echte Projekte statt Demo-Daten

### **Priorität 2: Feature-Erweiterungen**
- [ ] **Item-Selection Modal** - Nach Kategorie-Auswahl Items anzeigen
- [ ] **WorkshopScreen erweitern** - Mehr Stats, echte Item-Daten
- [ ] **LibraryScreen** - Item-Galerie mit Filter/Suche

### **Priorität 3: Polish**
- [ ] App-Name ändern (von "gameforge_studio" zu "GameForge Studio")
- [ ] App-Icon + Splash-Screen
- [ ] Error-Handling, Loading-States

---

## 📁 Flutter-Projekt-Struktur (Quick-Ref)

```
app/lib/
├── main.dart                      ← Entry Point, MainNavigation, AuthWrapper
├── screens/
│   ├── login_screen.dart          ✅ Fertig (Form Validation, Token Input)
│   ├── home_screen.dart           ✅ Fertig (Demo-Projekte, Navigation)
│   ├── create_project_screen.dart ✅ Fertig (6 Kategorien, Name Input)
│   ├── workshop_screen.dart       ✅ MVP (Slider, Toggles, Speichern-Button)
│   ├── library_screen.dart        ⏳ Placeholder
│   └── settings_screen.dart       ✅ Fertig (Logout)
├── theme/
│   ├── app_colors.dart            ✅ Purple Theme, Success/Error/Accent
│   ├── app_spacing.dart           ✅ Spacing, Sizing, Typography
│   └── app_theme.dart             ✅ Material 3 Config
├── models/                        ⏳ TODO (Project, Item Models)
├── services/                      ⏳ TODO (ProjectService, LibraryService)
└── data/                          ⏳ TODO (vanilla_stats.json Loader)
```

---

## 🎨 Design-System Quick-Ref

**Farben:**
```dart
import 'package:gameforge_studio/theme/app_colors.dart';

AppColors.primary       // #8B5CF6 (Purple)
AppColors.success       // #10B981 (Green)
AppColors.error         // #EF4444 (Red)
AppColors.accent        // #3B82F6 (Blue)
AppColors.background    // #1F2937 (Dark Gray)
```

**Spacing:**
```dart
import 'package:gameforge_studio/theme/app_spacing.dart';

AppSpacing.md          // 16.0
AppSpacing.lg          // 24.0
AppSizing.touchTarget  // 60.0 (Minimum für Kinder)
```

**Touch-Targets:** Minimum 60x60, ideal 80x80 (kinderfreundlich!)

---

## 🚀 Session-Workflow (Token-Effizienz!)

### **Bei Session-START:**
**Lies NUR diese Datei (CLAUDE.md)** → ~2.000 Tokens ✅

**Bei Bedarf:**
- Details? → `FLUTTER_STATUS.md` (~5.000 Tokens)
- Setup? → `README.md` (~3.000 Tokens)

### **Bei Session-ENDE:**
**Aktualisiere 2 Dateien:**
1. `CLAUDE.md` - Abschnitte "Was funktioniert?" + "Was fehlt?" + "Letzte Session"
2. `SESSION_LOG.md` - Kurzer Eintrag (5 Zeilen)

**Bei großen Milestones:**
3. `FLUTTER_STATUS.md` - Technischer Fortschritt

---

## 💡 Token-Spar-Tipps

**Grundregel: Frag zuerst, lies dann!**

❌ **Verschwende keine Tokens:**
- Lies nicht automatisch alle Dateien
- Lies nicht `FLUTTER_STATUS.md` wenn nur eine kleine Änderung

✅ **Sei effizient:**
- Screen ändern? → Lies nur diesen Screen
- Bug fixen? → Lies nur die betroffene Datei
- Neue Funktion? → Frag: "Welche Dateien brauche ich?"

**Beispiel:**
```
User: "Ändere Button-Farbe im HomeScreen"
Du:   *liest nur app/lib/screens/home_screen.dart + theme/app_colors.dart*
      → 3.000 Tokens (statt 25.000!)
```

---

## 🔗 Wichtige Links

- **fabrik-library:** https://github.com/ReichiMD/fabrik-library (Item-Daten + Texturen)
- **Werkstatt-Repo:** https://github.com/ReichiMD/Werkstatt-Minecraft-Addon (Backend)
- **Item-Daten lokal:** `/library/vanilla_stats.json` (39 Items mit echten Stats)
- **React Native Referenz:** `/app-react-native/` (bis Flutter 100% fertig)

---

## 📝 Letzte Session (für Kontext)

**Session #10 - 2026-02-07 - Phase 2 Abschluss**
- ✅ Bottom Navigation mit 4 Tabs
- ✅ CreateProjectScreen mit 6 Kategorien
- ✅ WorkshopScreen MVP (Slider, Toggles)
- ✅ APK baut erfolgreich (21 MB)
- Branch: `claude/flutter-phase-2-info-BFJP1`
- Commits: 4bce70b, 2ffdfaf, b85ea6a

**Nächste Session:**
👉 **Projekt-Speicherung implementieren** (SharedPreferences)
- ProjectService erstellen
- Project-Model mit JSON-Serialization
- HomeScreen mit echten Projekten

---

## 🐛 Bekannte Issues

- HomeScreen hat Demo-Daten (keine echte Speicherung)
- vanilla_stats.json noch nicht geladen
- LibraryScreen nur Placeholder
- App-Name ist technisch (gameforge_studio)

**Alle non-blocking** - App funktioniert grundsätzlich!

---

## 🎯 Nächster Milestone

**Phase 3: Daten-Integration**
- Projekt-Speicherung (SharedPreferences)
- vanilla_stats.json laden
- HomeScreen dynamisch
- Item-Selection Modal

**Geschätzter Aufwand:** 2-3 Sessions

---

**🚀 Bereit für die nächste Session!**

**Quick Start:**
1. Lies diese Datei (du tust es gerade!)
2. Check Git: `git status && git log --oneline -3`
3. Sage: "Lass uns mit [Task] starten!"
