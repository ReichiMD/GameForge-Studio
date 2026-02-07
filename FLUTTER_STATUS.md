# 🦋 Flutter Migration - Technischer Status

**Letzte Aktualisierung:** 2026-02-07
**Branch:** `claude/flutter-phase-2-info-BFJP1`
**Fortschritt:** ~85% (Phase 1 + 2 komplett)

---

## 📊 Migration-Fortschritt

| Feature | React Native | Flutter | Status |
|---------|--------------|---------|--------|
| **Design System** | ✅ | ✅ | **Komplett** |
| **LoginScreen** | ✅ | ✅ | **Komplett** |
| **HomeScreen** | ✅ | ✅ | **Basis komplett** |
| **Auth State** | AsyncStorage | SharedPreferences | **Komplett** |
| **Theme** | Custom | Material 3 | **Komplett** |
| **Bottom Navigation** | React Navigation | IndexedStack | **Komplett** |
| **CreateProjectScreen** | ✅ | ✅ | **Komplett** |
| **WorkshopScreen** | ✅ (373 Zeilen) | ✅ MVP (475 Zeilen) | **MVP komplett** |
| **SettingsScreen** | ✅ | ✅ | **Mit Logout** |
| **LibraryScreen** | ✅ | ⏳ | **Placeholder** |
| **Project Context** | React Context | - | ⏳ **TODO** |
| **Services** | Geplant | - | ⏳ **TODO** |

**Fortschritt:** ~85% (8/11 Major Features)

---

## ✅ Phase 1: Core Setup (Komplett)

### **1. Projekt-Umstrukturierung**
- ✅ React Native App → `app-react-native/` (als Referenz behalten)
- ✅ Neues Flutter-Projekt erstellt in `app/`
- ✅ Package: `com.gameforge.gameforge_studio`

### **2. Design-System migriert**
```
app/lib/theme/
├── app_colors.dart     ← Alle Farben (Primary: #8B5CF6, Success: #10B981, etc.)
├── app_spacing.dart    ← Spacing, Sizing, Typography
└── app_theme.dart      ← Material Theme Config (Dark Theme)
```

**Features:**
- Material 3 Design
- Kinderfreundliche Touch-Targets (60px)
- Minecraft-inspirierte dunkle Farben
- Vollständig typisiert

### **3. Auth-System**
- ✅ LoginScreen mit Username + GitHub Token Input
- ✅ Show/Hide Token Toggle
- ✅ Form Validation mit Error-Handling
- ✅ SharedPreferences für persistentes Login
- ✅ AuthWrapper mit Loading State

### **4. HomeScreen**
- ✅ Header mit GameForge Logo + Minecraft Badge
- ✅ "Neues Projekt" Button (große Touch-Target)
- ✅ 3 Demo-Projekte:
  - ⚔️ Super Schwert Pack (3 Items, Fertig)
  - 🛡️ Coole Rüstungen (5 Items, Entwurf)
  - 🧪 Magische Tränke (2 Items, Entwurf)
- ✅ Status Badges (Fertig/Entwurf)

### **5. Dependencies**
```yaml
dependencies:
  flutter: sdk
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.3.3

dev_dependencies:
  flutter_test: sdk
  flutter_lints: ^5.0.0
```

### **6. CI/CD**
- ✅ GitHub Actions Workflow für Flutter umgeschrieben
- ✅ Setup Flutter 3.27.1 statt Node.js
- ✅ Dart SDK Version auf ^3.5.0 korrigiert
- ✅ APK Build-Command: `flutter build apk --release`
- ✅ APK erfolgreich gebaut (21 MB)

---

## ✅ Phase 2: Navigation & Screens (Komplett)

### **1. Bottom Navigation Bar** (Commit: `4bce70b`)
- ✅ 4 Tabs: Home, Bibliothek, Workshop, Settings
- ✅ Custom Emoji-Icons mit aktivem Zustand (purple highlight)
- ✅ State Preservation mit `IndexedStack`
- ✅ Placeholder-Screens erstellt

**Datei:** `app/lib/main.dart` - `MainNavigation` Widget

### **2. CreateProjectScreen** (Commit: `2ffdfaf`)
- ✅ Projekt-Name Input mit Validation (Error bei leerem Name)
- ✅ 6 Kategorien in 2-Spalten Grid:
  - ⚔️ Waffen
  - 🛡️ Rüstung
  - 👾 Mobs
  - 🍖 Nahrung
  - 🧱 Blöcke
  - 🔨 Werkzeuge
- ✅ Navigation von HomeScreen → CreateProjectScreen
- ✅ Back-Button funktioniert
- ✅ Visual Feedback (purple border bei Auswahl)
- ⏳ Placeholder für Item-Modal (zeigt SnackBar)

**Datei:** `app/lib/screens/create_project_screen.dart` (348 Zeilen)

### **3. WorkshopScreen MVP** (Commit: `b85ea6a`)
- ✅ Demo-Item: "Mein Super Schwert" (Diamond Sword)
- ✅ Item-Preview Card mit Emoji-Icon (⚔️, 120x120)
- ✅ Editierbarer Item-Name (live updates)
- ✅ **2 Stat-Slider:**
  - Damage: 1-20 (Default: 7)
  - Durability: 100-3000 (Default: 1561)
  - Purple Theme, Wert-Badge, Min/Max Labels
- ✅ **2 Effekt-Toggles:**
  - 🔥 Feuer-Effekt (Standard: AN)
  - ✨ Leuchten (Standard: AUS)
  - Animierte Toggle-Switches
- ✅ **Speichern-Button:**
  - Großer grüner Button mit Schatten
  - SnackBar zeigt: Name, Damage, Durability
  - 3 Sekunden Anzeigezeit

**Datei:** `app/lib/screens/workshop_screen.dart` (475 Zeilen)

### **4. SettingsScreen**
- ✅ Logout-Button mit Bestätigung
- ✅ Navigation zurück zu LoginScreen

---

## ⏳ Phase 3: Daten-Integration (TODO)

### **Priorität 1: Projekt-Speicherung**

**Ziel:** HomeScreen mit echten Projekten (statt Demo-Daten)

**Tasks:**
- [ ] **Project-Model erstellen** (`app/lib/models/project.dart`)
  ```dart
  class Project {
    final String id;
    final String name;
    final String emoji;
    final String category;
    final List<String> items; // Item IDs
    final DateTime createdAt;

    // toJson() / fromJson() für Persistenz
  }
  ```

- [ ] **ProjectService erstellen** (`app/lib/services/project_service.dart`)
  - `loadProjects()` - aus SharedPreferences
  - `saveProject(Project project)`
  - `deleteProject(String id)`
  - `addItemToProject(String projectId, String itemId)`

- [ ] **HomeScreen updaten**
  - Demo-Projekte entfernen
  - Echte Projekte aus Service laden
  - `setState` wenn neue Projekte erstellt

**Geschätzte Zeit:** 2-3h (1 Session)

---

### **Priorität 2: vanilla_stats.json Integration**

**Ziel:** WorkshopScreen mit echten Item-Daten

**Tasks:**
- [ ] **Asset einbinden** (`pubspec.yaml`)
  ```yaml
  flutter:
    assets:
      - library/vanilla_stats.json
  ```

- [ ] **Loader erstellen** (`app/lib/data/vanilla_items.dart`)
  ```dart
  Future<Map<String, dynamic>> loadVanillaStats() async {
    final jsonString = await rootBundle.loadString('library/vanilla_stats.json');
    return jsonDecode(jsonString);
  }
  ```

- [ ] **WorkshopScreen erweitern**
  - Item-Daten aus vanilla_stats.json laden
  - Dynamische Slider je nach Item-Typ (Waffe/Rüstung/Nahrung)
  - Snap-to-Default Slider (wie React Native)
  - GitHub-Bilder laden

**Geschätzte Zeit:** 3-4h (1-2 Sessions)

---

### **Priorität 3: LibraryScreen Implementation**

**Ziel:** Item-Galerie mit Filter/Suche

**Tasks:**
- [ ] Item-Grid mit vanilla_stats.json Items
- [ ] Filter nach Kategorie
- [ ] Suche nach Item-Name
- [ ] Item-Details anzeigen
- [ ] Item zu Projekt hinzufügen

**Geschätzte Zeit:** 4-6h (2 Sessions)

---

## 🔧 Flutter-Projekt-Struktur

```
app/
├── lib/
│   ├── main.dart                      ← MainNavigation + AuthWrapper
│   ├── screens/
│   │   ├── login_screen.dart         ✅ Phase 1
│   │   ├── home_screen.dart          ✅ Phase 1
│   │   ├── library_screen.dart       ⏳ Placeholder
│   │   ├── workshop_screen.dart      ✅ MVP (Phase 2)
│   │   ├── settings_screen.dart      ✅ Phase 2
│   │   └── create_project_screen.dart ✅ Phase 2
│   ├── theme/
│   │   ├── app_colors.dart           ✅ Phase 1
│   │   ├── app_spacing.dart          ✅ Phase 1
│   │   └── app_theme.dart            ✅ Phase 1
│   ├── models/                       ⏳ TODO (Project, Item)
│   ├── services/                     ⏳ TODO (ProjectService, LibraryService)
│   └── data/                         ⏳ TODO (vanilla_stats Loader)
├── pubspec.yaml                      ✅ Dependencies
└── android/                          ✅ Flutter-generiert
```

---

## 💡 Code-Patterns (für Konsistenz)

### **Navigation:**
```dart
// Push Navigation
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const CreateProjectScreen(),
  ),
);

// Pop Navigation
Navigator.of(context).pop();
```

### **SnackBar Feedback:**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Nachricht hier'),
    backgroundColor: AppColors.success,
    duration: const Duration(seconds: 3),
  ),
);
```

### **JSON-Daten laden:**
```dart
import 'dart:convert';
import 'package:flutter/services.dart';

Future<Map<String, dynamic>> loadJson() async {
  final jsonString = await rootBundle.loadString('path/to/file.json');
  return jsonDecode(jsonString);
}
```

### **SharedPreferences Pattern:**
```dart
// Speichern
final prefs = await SharedPreferences.getInstance();
await prefs.setStringList('projects', projectsJson);

// Laden
final prefs = await SharedPreferences.getInstance();
final projectsJson = prefs.getStringList('projects') ?? [];
```

---

## 📚 Referenz-Dateien (React Native → Flutter)

| Feature | React Native Datei | Flutter Datei | Status |
|---------|-------------------|---------------|--------|
| **Navigation** | `app-react-native/src/navigation/AppNavigator.tsx` | `app/lib/main.dart` | ✅ Portiert |
| **CreateProject** | `app-react-native/src/screens/CreateProjectScreen.tsx` | `app/lib/screens/create_project_screen.dart` | ✅ Portiert |
| **Workshop** | `app-react-native/src/screens/WorkshopScreen.tsx` | `app/lib/screens/workshop_screen.dart` | ✅ MVP |
| **Library** | `app-react-native/src/screens/LibraryScreen.tsx` | - | ⏳ TODO |
| **vanilla_stats.json** | `library/vanilla_stats.json` | - | ⏳ TODO |

---

## 🐛 Bekannte Issues

- ❌ **Keine echten Daten** - alles Demo/Placeholder
- ❌ **Item-Modal fehlt** in CreateProjectScreen
- ❌ **vanilla_stats.json** noch nicht integriert
- ❌ **LibraryScreen** nur Placeholder
- ❌ **App-Name** ist technisch (gameforge_studio statt GameForge Studio)

**Alle non-blocking!** App funktioniert grundsätzlich.

---

## 🔗 Wichtige Links

- **Repo:** https://github.com/ReichiMD/GameForge-Studio
- **GitHub Actions:** https://github.com/ReichiMD/GameForge-Studio/actions
- **React Native (Referenz):** `/app-react-native/`
- **Flutter App:** `/app/`

---

## 🎯 Definition of Done (Phase 3)

**Phase 3 ist fertig, wenn:**
- [ ] Projekt-Speicherung funktioniert (SharedPreferences)
- [ ] HomeScreen zeigt echte Projekte
- [ ] vanilla_stats.json wird geladen
- [ ] WorkshopScreen nutzt echte Item-Daten
- [ ] Item-Selection Modal funktioniert
- [ ] APK baut erfolgreich

**Geschätzte Zeit:** 3-4 Sessions

---

**Erstellt:** 2026-02-07 (konsolidiert aus FLUTTER_MIGRATION_STATUS.md + PHASE_2_HANDOVER.md)
**Nächste Aktualisierung:** Nach Phase 3 Abschluss
