# CLAUDE.md - Session Quick Start

**Version:** 3.0 (Flutter - Major Workflow Redesign!)
**Letzte Aktualisierung:** 2026-02-08
**Status:** Phase 6 Workflow Redesign (✅ Fertig!)

---

## 🎯 Projekt auf einen Blick

**GameForge Studio** - Flutter Mobile App für Minecraft Addon-Erstellung
- **Zielgruppe:** 7-jähriges Kind + Vater (kinderfreundlich!)
- **Tech-Stack:** Flutter + Dart, Material 3 Design, SharedPreferences
- **Platform:** Android (APK via GitHub Actions)
- **Status:** Flutter Migration bei 100% - **VOLL FUNKTIONSFÄHIG!** 🎉

---

## 📱 Was funktioniert bereits? (Phase 1-6)

✅ **Login/Logout** - Username + GitHub Token (SharedPreferences)
✅ **Bottom Navigation** - 3 Tabs (Home, Bibliothek, Settings)
✅ **HomeScreen** - Projekte mit Swipe-to-Delete, Item-Count, Instant Refresh
✅ **CreateProjectScreen** - Nur Name eingeben (super simpel!)
✅ **ProjectDetailScreen** - Zeigt alle Items im Projekt, Export-Button 📤
✅ **CategorySelectionScreen** - 6 Kategorien zur Auswahl
✅ **ItemListScreen** - Vanilla Items aus vanilla_stats.json auswählen
✅ **WorkshopScreen** - Item-Editor mit 6 Stats + Effekte
✅ **LibraryScreen** - Item-Galerie mit 39 Items, Filter, Suche
✅ **SettingsScreen** - GitHub, Darstellung, Info, Gefahrenzone
✅ **Item-Export** - Minecraft Bedrock JSON Export per Share
✅ **Project Export** - Alle Items eines Projekts exportieren
✅ **Multi-Item Projects** - Ein Projekt kann viele Items enthalten! 🚀
✅ **APK Build** - GitHub Actions, Version 1.1.1+3
🔄 **Item Texturen** - Integration vorbereitet (fabrik-library), debugging pending

---

## 🆕 Neuer Workflow (Phase 6 - MEGA UPDATE!)

**Kompletter Workflow:**
1. **Projekt erstellen** (nur Name) → HomeScreen ✅
2. **Projekt öffnen** → ProjectDetailScreen (Item-Liste)
3. **Item hinzufügen** ➕ → Kategorie wählen
4. **Kategorie wählen** → Item-Liste (vanilla items)
5. **Item auswählen** → WorkshopScreen (Editor)
6. **Stats bearbeiten** → Speichern → Zurück zur Item-Liste
7. **Item bearbeiten** → Tap auf Item → Editor → Update
8. **Projekt exportieren** → 📤 Button → Share als Minecraft Addon

**Vorher:** 1 Projekt = 1 Item
**Jetzt:** 1 Projekt = VIELE Items! 🎉

---

## 📁 Flutter-Projekt-Struktur (Updated!)

```
app/lib/
├── main.dart                      ← Entry Point, 3 Tabs Navigation
├── screens/
│   ├── login_screen.dart          ✅ Form Validation, Token Input
│   ├── home_screen.dart           ✅ Projekte, Swipe-Delete, Instant Refresh
│   ├── create_project_screen.dart ✅ Nur Name (super simpel!)
│   ├── project_detail_screen.dart ✅ Item-Liste, Export-Button
│   ├── category_selection_screen.dart ✅ 6 Kategorien Grid
│   ├── item_list_screen.dart      ✅ Vanilla Items Auswahl
│   ├── workshop_screen.dart       ✅ Item-Editor (6 Stats + Effekte)
│   ├── library_screen.dart        ✅ Item-Galerie, Filter, Suche
│   └── settings_screen.dart       ✅ Alle Settings-Sections
├── theme/
│   ├── app_colors.dart            ✅ Purple Theme (#8B5CF6)
│   ├── app_spacing.dart           ✅ Spacing, Touch-Targets
│   └── app_theme.dart             ✅ Material 3 Config
├── models/
│   ├── project.dart               ✅ List<ProjectItem>, addItem, removeItem
│   ├── project_item.dart          ✅ Item im Projekt (NEU!)
│   └── vanilla_item.dart          ✅ Vanilla Items aus JSON
├── services/
│   ├── project_service.dart       ✅ CRUD Operations
│   ├── vanilla_data_service.dart  ✅ JSON Loader
│   └── minecraft_export_service.dart ✅ Minecraft Bedrock Export
└── widgets/
    └── item_selection_modal.dart  ✅ Item Grid (alt, nicht mehr verwendet)
```

---

## 🎨 Design-System Quick-Ref

**Farben:**
```dart
AppColors.primary       // #8B5CF6 (Purple)
AppColors.success       // #10B981 (Green)
AppColors.error         // #EF4444 (Red)
AppColors.info          // #3B82F6 (Blue)
AppColors.background    // #1F2937 (Dark Gray)
```

**Touch-Targets:** Minimum 60x60, ideal 80x80 (kinderfreundlich!)

---

## ⏳ Was fehlt noch? (Phase 7 - TODOs)

### **Priorität 1: Polish**
- [ ] App-Icon erstellen (1024x1024 PNG) - siehe ICON_SETUP.md
- [ ] Splash-Screen
- [ ] Besseres Error-Handling

### **Priorität 2: Features**
- [ ] Mehr Effekte (Poison, Regeneration, etc.)
- [ ] Item-Vorschau mit Texture aus fabrik-library
- [ ] Projekt-Duplikation

---

## 🚀 Session-Workflow (Token-Effizienz!)

### **Bei Session-START:**
**Lies NUR diese Datei (CLAUDE.md)** → ~2.500 Tokens ✅

**Bei Bedarf:**
- Details? → `FLUTTER_STATUS.md` (~5.000 Tokens)
- Setup? → `README.md` (~3.000 Tokens)

### **Bei Session-ENDE:**
**Aktualisiere 2 Dateien:**
1. `CLAUDE.md` - Abschnitte "Was funktioniert?" + "Letzte Session"
2. `SESSION_LOG.md` - Kurzer Eintrag (5 Zeilen)

---

## 🔗 Wichtige Links

- **fabrik-library:** https://github.com/ReichiMD/fabrik-library (Item-Daten + Texturen)
- **Werkstatt-Repo:** https://github.com/ReichiMD/Werkstatt-Minecraft-Addon (Backend)
- **Item-Daten lokal:** `/library/vanilla_stats.json` (39 Items mit echten Stats)

---

## 📝 Letzte Session (für Kontext)

**Session #17 - 2026-02-08 - Minecraft Item Texturen (Partial)**
- 🔄 **Item-Texturen Integration:** cached_network_image Paket hinzugefügt
- ✅ **VanillaItem Model erweitert:** textureUrl Getter, hasTexture Property
- ✅ **ItemTextureWidget:** Widget mit CachedNetworkImage + Emoji-Fallback
- ✅ **4 Screens aktualisiert:** ItemListScreen, WorkshopScreen, ProjectDetailScreen, LibraryScreen
- ✅ **Version:** 1.1.1+3 (APK Rebuild für Package-Installation)
- ❌ **Problem:** Bilder werden nicht angezeigt (Ursache unklar)
- Branch: `claude/minecraft-item-images-r1uWF`
- Commit: 768c487 (Version Bump), 4a35cfd (Texture Integration)

**Status:** Merge zu Main geplant, Code ist sauber implementiert

**Nächste Session:**
👉 **Debug-Modus für Item-Texturen**
- Debug-Logs hinzufügen (Netzwerk, Fehler, Cache)
- Error-Handling verbessern
- Ursache für fehlende Bilder finden

---

## 🐛 Bekannte Issues

- Kein App-Icon (nur Default Flutter Icon)
- Kategorien ohne vanilla items (Mobs, Blöcke, Werkzeuge) erstellen leeres Item
- Kein Splash-Screen
- **Item Texturen werden nicht angezeigt** - cached_network_image integriert, aber Bilder laden nicht (Debug-Modus in nächster Session)

**Alle non-blocking** - App ist voll funktionsfähig! 🎉

---

## 🎯 Nächster Milestone

**Phase 7: App Polish & Beta Release**
- App-Icon und Splash-Screen
- End-to-End Testing
- Erste Beta-Version veröffentlichen

**Geschätzter Aufwand:** 1 Session

---

**🚀 Bereit für die nächste Session!**

**Quick Start:**
1. Lies diese Datei (du tust es gerade!)
2. Check Git: `git status && git log --oneline -3`
3. Sage: "Lass uns mit [Task] starten!"
