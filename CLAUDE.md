# CLAUDE.md - Session Quick Start

**Version:** 2.2 (Flutter)
**Letzte Aktualisierung:** 2026-02-07
**Status:** Phase 4 Item-Integration (~95%)

---

## 🎯 Projekt auf einen Blick

**GameForge Studio** - Flutter Mobile App für Minecraft Addon-Erstellung
- **Zielgruppe:** 7-jähriges Kind + Vater (kinderfreundlich!)
- **Tech-Stack:** Flutter + Dart, Material 3 Design, SharedPreferences
- **Platform:** Android (APK via GitHub Actions)
- **Status:** Migration von React Native → Flutter bei 95%

---

## 📱 Was funktioniert bereits? (Phase 1-4)

✅ **Login/Logout** - Username + GitHub Token (SharedPreferences)
✅ **Bottom Navigation** - 4 Tabs (Home, Bibliothek, Workshop, Settings)
✅ **HomeScreen** - Echte Projekte mit Swipe-to-Delete, Empty State, Base-Item Anzeige
✅ **CreateProjectScreen** - 6 Kategorien, Item-Selection Modal, Projekt-Speicherung
✅ **Projekt-Speicherung** - ProjectService mit SharedPreferences (CRUD)
✅ **Project Model** - JSON-Serialization, Timestamps, Category-Icons, Base-Item Support
✅ **Item-Integration** - vanilla_stats.json Loader, VanillaItem Model, 39 Items
✅ **ItemSelectionModal** - Grid-View mit Rarity-Badges, Filtern nach Kategorie
✅ **WorkshopScreen MVP** - Item-Editor mit Slidern (Damage, Durability), Effekt-Toggles
✅ **SettingsScreen** - Logout-Button
✅ **Theme-System** - Material 3, Purple Theme (#8B5CF6), kinderfreundliche Touch-Targets
✅ **APK Build** - GitHub Actions baut erfolgreich (21 MB APK)

---

## ⏳ Was fehlt noch? (Phase 5 - TODOs)

### **Priorität 1: Workshop-Integration**
- [ ] **WorkshopScreen erweitern** - Mehr Stats, echte Item-Daten
- [ ] **LibraryScreen** - Item-Galerie mit Filter/Suche
- [ ] **Projekt bearbeiten** - Projekte öffnen und im Workshop editieren

### **Priorität 3: Polish**
- [ ] App-Name ändern (von "gameforge_studio" zu "GameForge Studio")
- [ ] App-Icon + Splash-Screen
- [ ] Besseres Error-Handling, Toast-Nachrichten

---

## 📁 Flutter-Projekt-Struktur (Quick-Ref)

```
app/lib/
├── main.dart                      ← Entry Point, MainNavigation, AuthWrapper
├── screens/
│   ├── login_screen.dart          ✅ Fertig (Form Validation, Token Input)
│   ├── home_screen.dart           ✅ Fertig (Echte Projekte, Swipe-Delete, Empty State)
│   ├── create_project_screen.dart ✅ Fertig (6 Kategorien, Projekt-Speicherung)
│   ├── workshop_screen.dart       ✅ MVP (Slider, Toggles, Speichern-Button)
│   ├── library_screen.dart        ⏳ Placeholder
│   └── settings_screen.dart       ✅ Fertig (Logout)
├── theme/
│   ├── app_colors.dart            ✅ Purple Theme, Success/Error/Accent
│   ├── app_spacing.dart           ✅ Spacing, Sizing, Typography
│   └── app_theme.dart             ✅ Material 3 Config
├── models/
│   ├── project.dart               ✅ JSON-Serialization, Timestamps, Icons, Base-Item
│   └── vanilla_item.dart          ✅ VanillaItem + VanillaCategory Models
├── services/
│   ├── project_service.dart       ✅ CRUD Operations (SharedPreferences)
│   └── vanilla_data_service.dart  ✅ JSON Loader, Category Mapping
└── widgets/
    └── item_selection_modal.dart  ✅ Item Grid, Rarity-Badges, Category Filter
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

**Session #12 - 2026-02-07 - Phase 4 Item-Integration**
- ✅ VanillaItem + VanillaCategory Models erstellt
- ✅ VanillaDataService mit JSON-Loader (vanilla_stats.json, 39 Items)
- ✅ ItemSelectionModal mit Grid-View, Rarity-Badges, Stat-Anzeige
- ✅ CreateProjectScreen erweitert: Kategorie → Item-Selection → Speichern
- ✅ Project Model mit baseItem Getter und hasBaseItem Check
- ✅ HomeScreen zeigt Base-Item in Projekt-Cards
- ✅ Asset-Registrierung in pubspec.yaml
- Branch: `claude/implement-phase-4-k05od`
- Commit: 8721da6

**Nächste Session:**
👉 **Workshop-Integration mit Base-Item Daten**
- WorkshopScreen mit Base-Item Daten befüllen
- Stats vom Base-Item als Ausgangswerte verwenden
- Projekt bearbeiten (aus HomeScreen öffnen)

---

## 🐛 Bekannte Issues

- LibraryScreen nur Placeholder
- Projekte können nicht bearbeitet werden (nur erstellen/löschen)
- WorkshopScreen nutzt noch keine Base-Item Daten
- App-Name ist technisch (gameforge_studio)
- Kategorien ohne vanilla items (Mobs, Blöcke, Werkzeuge) haben keine Item-Auswahl

**Alle non-blocking** - App funktioniert grundsätzlich!

---

## 🎯 Nächster Milestone

**Phase 5: Workshop-Integration**
- Projekte aus HomeScreen im Workshop öffnen
- Base-Item Daten als Ausgangswerte verwenden
- Workshop-Screen erweitern (mehr Stats)
- LibraryScreen implementieren (Item-Galerie)

**Geschätzter Aufwand:** 2-3 Sessions

---

**🚀 Bereit für die nächste Session!**

**Quick Start:**
1. Lies diese Datei (du tust es gerade!)
2. Check Git: `git status && git log --oneline -3`
3. Sage: "Lass uns mit [Task] starten!"
