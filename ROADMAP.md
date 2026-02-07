# 🗺️ GameForge Studio - Roadmap

**Projekt:** Minecraft Add-on Creator für Kinder (7 Jahre+)
**Technologie:** Flutter + Dart (migriert von React Native)
**Status:** Phase 2 abgeschlossen (~85%)
**Letzte Aktualisierung:** 2026-02-07

---

## ⚠️ Migration: React Native → Flutter (Abgeschlossen)

**Grund:** Zuverlässigere APK-Builds, bessere Performance, einfacherer Build-Prozess
**Zeitraum:** 2026-02-06 bis 2026-02-07 (2 Tage)

**Was migriert wurde:**
- [x] Design-System → Material 3 (app_colors.dart, app_spacing.dart, app_theme.dart)
- [x] LoginScreen + Auth → SharedPreferences
- [x] HomeScreen → Demo-Projekte, Navigation
- [x] Bottom Navigation → 4 Tabs (IndexedStack)
- [x] CreateProjectScreen → 6 Kategorien
- [x] WorkshopScreen → MVP mit Slidern
- [x] SettingsScreen → Logout
- [x] GitHub Actions → Flutter APK Build

**Status:** ✅ Migration erfolgreich! APK baut (21 MB)

---

## ✅ Phase 1 - Core Setup (Abgeschlossen - 2026-02-07)

- [x] Flutter + Dart Setup (Flutter 3.27.1, Dart 3.6.0)
- [x] Material 3 Dark Theme (Purple #8B5CF6)
- [x] Kinderfreundliche Touch-Targets (60px)
- [x] LoginScreen mit Form Validation
- [x] SharedPreferences für Auth
- [x] HomeScreen mit Demo-Projekten
- [x] GitHub Actions Workflow (APK automatisch bauen)

**Ergebnis:** Solide Basis, zuverlässige Builds

---

## ✅ Phase 2 - Navigation & Screens (Abgeschlossen - 2026-02-07)

- [x] Bottom Navigation Bar (Home, Bibliothek, Workshop, Settings)
- [x] State Preservation (IndexedStack)
- [x] CreateProjectScreen (6 Kategorien: Waffen, Rüstung, Mobs, Nahrung, Blöcke, Werkzeuge)
- [x] Projekt-Name Validation
- [x] WorkshopScreen MVP:
  - [x] Item-Preview Card
  - [x] Editierbarer Item-Name
  - [x] Damage Slider (1-20)
  - [x] Durability Slider (100-3000)
  - [x] Effekt-Toggles (Feuer, Leuchten)
  - [x] Speichern-Button mit SnackBar
- [x] SettingsScreen (Logout-Button)
- [x] Navigation Flow (Home → CreateProject → Workshop)

**Ergebnis:** Alle Haupt-Screens vorhanden, Navigation funktioniert

---

## 🚧 Phase 3 - Daten-Integration (In Arbeit)

**Priorität:** HOCH (ohne Daten ist App nur Demo)

### Phase 3.1: Projekt-Speicherung
- [ ] **Project-Model** erstellen (`app/lib/models/project.dart`)
- [ ] **ProjectService** implementieren:
  - [ ] `loadProjects()` aus SharedPreferences
  - [ ] `saveProject(Project project)`
  - [ ] `deleteProject(String id)`
  - [ ] `addItemToProject(String projectId, String itemId)`
- [ ] **HomeScreen** mit echten Projekten (statt Demo-Daten)
- [ ] **CreateProjectScreen** speichert neues Projekt

**Geschätzter Aufwand:** 2-3h (1 Session)

### Phase 3.2: vanilla_stats.json Integration
- [ ] **Asset einbinden** (pubspec.yaml)
- [ ] **VanillaItem-Model** erstellen
- [ ] **Loader** implementieren (`app/lib/data/vanilla_items.dart`)
- [ ] **WorkshopScreen** mit echten Item-Daten:
  - [ ] Item-Daten aus vanilla_stats.json laden
  - [ ] Dynamische Slider (Damage, Durability, Attack Speed, Armor)
  - [ ] Stats je nach Item-Typ (Waffe vs. Rüstung vs. Nahrung)

**Geschätzter Aufwand:** 3-4h (1-2 Sessions)

### Phase 3.3: Item-Selection Modal
- [ ] **Modal** nach Kategorie-Auswahl
- [ ] Items aus vanilla_stats.json anzeigen
- [ ] Suche/Filter
- [ ] Item-Auswahl → WorkshopScreen

**Geschätzter Aufwand:** 2-3h (1 Session)

---

## 📅 Phase 4 - LibraryScreen & Features (Geplant)

### Phase 4.1: LibraryScreen
- [ ] Item-Galerie (Grid View)
- [ ] Filter nach Kategorie
- [ ] Suche nach Name
- [ ] Item-Details anzeigen
- [ ] Item zu Projekt hinzufügen

**Geschätzter Aufwand:** 4-6h (2 Sessions)

### Phase 4.2: WorkshopScreen Erweiterungen
- [ ] GitHub-Bilder laden (von fabrik-library)
- [ ] Snap-to-Default Slider (Vibration)
- [ ] Erweitert-Button (Item-ID, Knockback, etc.)
- [ ] Rarity-Auswahl (Common, Uncommon, Rare, Epic)

**Geschätzter Aufwand:** 3-4h (1-2 Sessions)

### Phase 4.3: UI Polish
- [ ] App-Name ändern (gameforge_studio → GameForge Studio)
- [ ] App-Icon hinzufügen
- [ ] Splash-Screen anpassen
- [ ] Error-Handling verbessern
- [ ] Loading-States hinzufügen

**Geschätzter Aufwand:** 2-3h (1 Session)

---

## 🔧 Phase 5 - GitHub Integration (Geplant)

### Phase 5.1: GitHubService
- [ ] API Client implementieren (http package)
- [ ] Token-Verwaltung (sicher in SharedPreferences)
- [ ] Repository-Zugriff testen

### Phase 5.2: Projekt-Export
- [ ] `project.json` generieren (Minecraft Addon Format)
- [ ] `manifest.json` erstellen
- [ ] Behavior Pack Struktur
- [ ] Resource Pack Struktur

### Phase 5.3: GitHub Push
- [ ] Projekt zu Werkstatt-Repo pushen
- [ ] GitHub Actions triggern (Gemini AI)
- [ ] .mcaddon Download

**Geschätzter Aufwand:** 6-8h (2-3 Sessions)

---

## 🌟 Phase 6 - Advanced Features (Zukunft)

### Erweiterte Kategorien
- [ ] Blöcke (Bau, Deko, Redstone)
- [ ] Tränke (Effekte, Dauer)
- [ ] Werkzeuge (Spitzhacke, Schaufel, Axt)

### Crafting-Rezepte
- [ ] Rezept-Editor (3x3 Grid)
- [ ] Shapeless Recipes
- [ ] Furnace/Brewing Rezepte

### Custom Items
- [ ] Foto aus Galerie für Custom Textur
- [ ] Einfacher Pixel-Editor (16x16)
- [ ] Custom Items exportieren/importieren

---

## 📱 UX/UI Verbesserungen (Laufend)

### Kinder-freundlich
- [x] Große Touch-Targets (60x60px)
- [x] Emoji-heavy UI
- [ ] Animationen (Fun Factor)
- [ ] Tutorials/Onboarding
- [ ] Achievements (Gamification)

### Performance
- [ ] Lazy Loading für Item-Listen
- [ ] Image Caching optimieren
- [ ] Scroll-Performance

---

## 🐛 Known Issues

- ❌ HomeScreen hat Demo-Daten (keine echte Speicherung)
- ❌ vanilla_stats.json noch nicht geladen
- ❌ LibraryScreen nur Placeholder
- ❌ App-Name ist technisch (gameforge_studio)

**Alle non-blocking!** App funktioniert grundsätzlich.

---

## 📊 Metriken

**Aktueller Stand:**
- ✅ Flutter Migration komplett
- ✅ 6 Screens implementiert (Login, Home, CreateProject, Library, Workshop, Settings)
- ✅ Bottom Navigation funktioniert
- ✅ WorkshopScreen MVP funktioniert
- ✅ APK baut erfolgreich (21 MB)
- ✅ 39 Vanilla Items mit Stats (library/vanilla_stats.json)

**Nächster Meilenstein:**
- 🎯 Phase 3: Daten-Integration (2-3 Sessions)
- 🎯 HomeScreen dynamisch (echte Projekte)
- 🎯 WorkshopScreen mit echten Stats

---

**Versionsnummer:** 0.2.0-beta
**Ziel MVP:** 0.5.0 (Ende Phase 4)
**Ziel Beta:** 1.0.0 (Ende Phase 6)

---

**Geschätzte Zeit bis MVP:** 6-8 Sessions (~20-30h)
**Geschätzte Zeit bis Beta:** 12-15 Sessions (~50-70h)
