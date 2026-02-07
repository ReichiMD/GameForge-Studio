# CLAUDE.md - Session Quick Start

**Version:** 2.3 (Flutter)
**Letzte Aktualisierung:** 2026-02-07
**Status:** Phase 5 Workshop-Integration (✅ Fertig!)

---

## 🎯 Projekt auf einen Blick

**GameForge Studio** - Flutter Mobile App für Minecraft Addon-Erstellung
- **Zielgruppe:** 7-jähriges Kind + Vater (kinderfreundlich!)
- **Tech-Stack:** Flutter + Dart, Material 3 Design, SharedPreferences
- **Platform:** Android (APK via GitHub Actions)
- **Status:** Migration von React Native → Flutter bei 95%

---

## 📱 Was funktioniert bereits? (Phase 1-5)

✅ **Login/Logout** - Username + GitHub Token (SharedPreferences)
✅ **Bottom Navigation** - 4 Tabs (Home, Bibliothek, Workshop, Settings)
✅ **HomeScreen** - Echte Projekte mit Swipe-to-Delete, Empty State, Base-Item Anzeige, Tap-to-Edit
✅ **CreateProjectScreen** - 6 Kategorien, Item-Selection Modal, Projekt-Speicherung
✅ **Projekt-Speicherung** - ProjectService mit SharedPreferences (CRUD)
✅ **Project Model** - JSON-Serialization, Timestamps, Category-Icons, Base-Item Support
✅ **Item-Integration** - vanilla_stats.json Loader, VanillaItem Model, 39 Items
✅ **ItemSelectionModal** - Grid-View mit Rarity-Badges, Filtern nach Kategorie
✅ **WorkshopScreen** - Item-Editor mit 6 Stats (damage, durability, attack_speed, armor, armor_toughness, mining_speed)
✅ **WorkshopScreen** - Base-Item Daten als Ausgangswerte, Projekt-Speicherung, Edit-Mode
✅ **LibraryScreen** - Item-Galerie mit 39 Items, Category-Filter, Suche, Detail-Modal
✅ **SettingsScreen** - Redesign mit allen Sections (GitHub, Darstellung, Info, Gefahrenzone)
✅ **Theme-System** - Material 3, Purple Theme (#8B5CF6), kinderfreundliche Touch-Targets
✅ **APK Build** - GitHub Actions baut erfolgreich (21 MB APK)
✅ **Kompletter Workflow** - Projekt erstellen → bearbeiten → speichern

---

## ⏳ Was fehlt noch? (Phase 6 - TODOs)

### **Priorität 1: Polish & UX**
- [ ] App-Name ändern (von "gameforge_studio" zu "GameForge Studio")
- [ ] App-Icon + Splash-Screen
- [ ] Besseres Error-Handling, Toast-Nachrichten
- [ ] Loading-States verbessern (Skeleton Screens)

### **Priorität 2: Erweiterte Features**
- [ ] Item-Export (JSON für Minecraft Addon)
- [ ] Projekt-Duplikation
- [ ] Item-Vorschau mit Texture aus fabrik-library
- [ ] Mehr Effekte (Poison, Regeneration, etc.)

---

## 📁 Flutter-Projekt-Struktur (Quick-Ref)

```
app/lib/
├── main.dart                      ← Entry Point, MainNavigation, AuthWrapper
├── screens/
│   ├── login_screen.dart          ✅ Fertig (Form Validation, Token Input)
│   ├── home_screen.dart           ✅ Fertig (Projekte, Swipe-Delete, Tap-to-Edit)
│   ├── create_project_screen.dart ✅ Fertig (6 Kategorien, Projekt-Speicherung)
│   ├── workshop_screen.dart       ✅ Fertig (6 Stats, Base-Item Integration, Speichern)
│   ├── library_screen.dart        ✅ Fertig (Item-Galerie, Filter, Suche, Details)
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
AppColors.info          // #3B82F6 (Blue)
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

**Session #15 - 2026-02-07 - Phase 6 Settings Redesign**
- ✅ SettingsScreen: Komplettes Redesign mit neuer Struktur
- ✅ GitHub Verbindung Section: Token (masked), Repository, Status
- ✅ Darstellung Section: Dark Mode Toggle, Button Größe, Sprache
- ✅ Info Section: App Version, Hilfe Dialog, Feedback Dialog
- ✅ Gefahrenzone Section: Alle Projekte löschen mit Bestätigung
- ✅ Einstellungen persistent in SharedPreferences speichern
- ✅ GitHub Token Security: Komplett maskiert (●●●●●●) - nicht erkennbar
- ✅ UI Design: Konsistent mit App-Theme (Purple, Dark Mode, Emojis)
- ✅ Kinderfreundlich: Touch-Targets minimum 60px
- Branch: `claude/redesign-settings-page-GD85G`
- Commits: 007708a, f374f18

**Nächste Session:**
👉 **App Polish & Testing**
- App-Name ändern (von "gameforge_studio" zu "GameForge Studio")
- App-Icon + Splash-Screen
- End-to-End Testing auf echtem Device
- Item-Export Funktionalität (Phase 2)

---

## 🐛 Bekannte Issues

- App-Name ist technisch (gameforge_studio)
- Kategorien ohne vanilla items (Mobs, Blöcke, Werkzeuge) haben keine Item-Auswahl
- Kein App-Icon oder Splash-Screen
- Item-Export noch nicht implementiert

**Alle non-blocking** - App ist voll funktionsfähig!

---

## 🎯 Nächster Milestone

**Phase 6: App Polish & Release-Vorbereitung**
- App-Name und Branding verbessern
- App-Icon und Splash-Screen erstellen
- End-to-End Testing auf Android Device
- Item-Export Funktionalität
- Erste Beta-Version veröffentlichen

**Geschätzter Aufwand:** 1-2 Sessions

---

**🚀 Bereit für die nächste Session!**

**Quick Start:**
1. Lies diese Datei (du tust es gerade!)
2. Check Git: `git status && git log --oneline -3`
3. Sage: "Lass uns mit [Task] starten!"
