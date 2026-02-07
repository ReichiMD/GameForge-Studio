# Flutter Migration Status

**Session:** #6 - Flutter Setup
**Datum:** 2026-02-07
**Branch:** `claude/flutter-setup-FTf1N`

---

## ✅ Was wurde erreicht (Phase 1: Core Setup)

### 1. Projekt-Umstrukturierung
- ✅ React Native App → `app-react-native/` (als Referenz behalten)
- ✅ Neues Flutter-Projekt erstellt in `app/`
- ✅ Package: `com.gameforge.gameforge_studio`

### 2. Design-System migriert
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

### 3. Screens implementiert

#### LoginScreen (`app/lib/screens/login_screen.dart`)
- Username + GitHub Token Input
- Show/Hide Token Toggle
- Form Validation mit Error-Handling
- Callback-basierte Architektur

#### HomeScreen (`app/lib/screens/home_screen.dart`)
- Header mit GameForge Logo + Minecraft Badge
- "Neues Projekt" Button (große Touch-Target)
- 3 Demo-Projekte:
  - ⚔️ Super Schwert Pack (3 Items, Fertig)
  - 🛡️ Coole Rüstungen (5 Items, Entwurf)
  - 🧪 Magische Tränke (2 Items, Entwurf)
- Status Badges (Fertig/Entwurf mit korrekten Farben)

### 4. App-Logik (`app/lib/main.dart`)
- `AuthWrapper` StatefulWidget für Login-Flow
- SharedPreferences für persistentes Login
- Loading State während Auth-Check
- Clean State Management

### 5. Dependencies
```yaml
dependencies:
  flutter: sdk
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.3.3

dev_dependencies:
  flutter_test: sdk
  flutter_lints: ^5.0.0
```

### 6. CI/CD angepasst
- ✅ GitHub Actions Workflow für Flutter umgeschrieben
- ✅ Setup Flutter 3.27.1 statt Node.js
- ✅ Dart SDK Version auf ^3.5.0 korrigiert
- ✅ flutter_lints auf ^5.0.0 downgraded (Kompatibilität)
- ✅ APK Build-Command: `flutter build apk --release`

---

## 📊 Migration-Fortschritt

| Feature | React Native | Flutter | Status |
|---------|--------------|---------|--------|
| **Design System** | ✅ | ✅ | **Komplett** |
| **LoginScreen** | ✅ | ✅ | **Komplett** |
| **HomeScreen** | ✅ | ✅ | **Basis komplett** |
| **Auth State** | AsyncStorage | SharedPreferences | **Komplett** |
| **Theme** | Custom | Material 3 | **Komplett** |
| **Navigation** | React Navigation | - | ⏳ **TODO** |
| **CreateProjectScreen** | ✅ | - | ⏳ **TODO** |
| **LibraryScreen** | ✅ | - | ⏳ **TODO** |
| **WorkshopScreen** | ✅ | - | ⏳ **TODO** |
| **SettingsScreen** | ✅ | - | ⏳ **TODO** |
| **Project Context** | React Context | - | ⏳ **TODO** |
| **Services** | Geplant | - | ⏳ **TODO** |

**Fortschritt:** ~30% (3/10 Major Features)

---

## 🚀 Nächste Schritte (Phase 2: Navigation & Screens)

### Priorität 1: Bottom Navigation
**Ziel:** Hauptnavigation wie in React Native Version

**Tasks:**
1. Bottom Navigation Bar implementieren
   - Home Tab (✅ bereits vorhanden)
   - Library Tab
   - Workshop Tab
   - Settings Tab
2. Tab-Icons und Labels
3. Navigation State Management
4. Tab-Wechsel mit State Preservation

**Files zu erstellen:**
- `app/lib/navigation/main_navigation.dart`
- Oder: Direkt in `main.dart` integrieren

**Referenz:**
- React Native: `app-react-native/src/navigation/AppNavigator.tsx` (Zeile 1-121)

---

### Priorität 2: CreateProjectScreen
**Ziel:** Kategorie-Auswahl für neues Projekt

**Features zu implementieren:**
- Grid Layout mit Kategorien:
  - ⚔️ Waffen (Weapons)
  - 🛡️ Rüstungen (Armor)
  - 🧪 Tränke (Potions)
  - 🍖 Essen (Food)
  - 🏠 Blöcke (Blocks)
  - ✨ Sonstiges (Misc)
- Navigation: HomeScreen → CreateProjectScreen
- Back-Button Navigation
- Kategorie-Auswahl führt zu ProjectDetail

**Files zu erstellen:**
- `app/lib/screens/create_project_screen.dart`

**Referenz:**
- React Native: `app-react-native/src/screens/CreateProjectScreen.tsx` (467 Zeilen)

---

### Priorität 3: Weitere Screens (nach Navigation)

#### LibraryScreen
- Item-Galerie aus fabrik-library
- Filter nach Kategorie
- Suche
- Item-Auswahl für Projekt

**Referenz:** `app-react-native/src/screens/LibraryScreen.tsx`

#### WorkshopScreen
- Item-Editor
- Attribute bearbeiten
- Preview
- Speichern

**Referenz:** `app-react-native/src/screens/WorkshopScreen.tsx` (373 Zeilen, komplex!)

#### SettingsScreen
- Logout-Button
- GitHub Token Management
- App-Infos

**Referenz:** `app-react-native/src/screens/SettingsScreen.tsx`

---

## 🔧 Technische Details

### Flutter-Struktur
```
app/
├── lib/
│   ├── main.dart              ← Entry Point + AuthWrapper
│   ├── screens/
│   │   ├── login_screen.dart  ← ✅ Fertig
│   │   ├── home_screen.dart   ← ✅ Fertig
│   │   ├── create_project_screen.dart  ← TODO
│   │   ├── library_screen.dart         ← TODO
│   │   ├── workshop_screen.dart        ← TODO
│   │   └── settings_screen.dart        ← TODO
│   ├── widgets/              ← TODO: Reusable Components
│   ├── theme/
│   │   ├── app_colors.dart   ← ✅ Fertig
│   │   ├── app_spacing.dart  ← ✅ Fertig
│   │   └── app_theme.dart    ← ✅ Fertig
│   ├── services/             ← TODO: GitHub API, Library Service
│   ├── models/               ← TODO: Project, Item Models
│   └── utils/                ← TODO: Helpers
├── pubspec.yaml              ← ✅ Dependencies konfiguriert
└── android/                  ← ✅ Flutter-generiert
```

### Dependencies für Phase 2
```yaml
# Wird benötigt:
- go_router: ^14.0.0          # Für Navigation (Alternative zu MaterialApp)
- provider: ^6.1.0            # Für State Management (Alternative: Riverpod)
- http: ^1.2.0                # Für GitHub API Calls
- path_provider: ^2.1.0       # Für lokale Datei-Speicherung
```

---

## ⚠️ Wichtige Erkenntnisse (Lessons Learned)

### Problem 1: Flutter SDK Version
**Fehler:** `pubspec.yaml` hatte `sdk: ^3.10.8` (existiert nicht)
**Lösung:** `sdk: ^3.5.0` (kompatibel mit Flutter 3.27.1 = Dart 3.6.0)

### Problem 2: flutter_lints Version
**Fehler:** `flutter_lints: ^6.0.0` nicht kompatibel mit Dart SDK
**Lösung:** `flutter_lints: ^5.0.0` (stabil)

### Problem 3: GitHub Actions
**Fehler:** Workflow versuchte React Native zu bauen (Node.js)
**Lösung:** Workflow komplett umgeschrieben für Flutter
- Setup Flutter statt Node.js
- `flutter build apk` statt `gradlew assembleRelease`
- Neuer APK-Pfad: `build/app/outputs/flutter-apk/`

---

## 📝 Code-Patterns für Flutter

### Navigation (für nächste Session)
```dart
// Einfache Navigation (aktuell)
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => CreateProjectScreen()),
);

// Bottom Navigation (TODO)
BottomNavigationBar(
  currentIndex: _selectedIndex,
  onTap: (index) => setState(() => _selectedIndex = index),
  items: [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Library'),
    // ...
  ],
);
```

### State Management Pattern
```dart
// Aktuell: StatefulWidget mit setState
// Nächste Phase: Provider oder Riverpod für globalen State
// Beispiel: ProjectContext → ProjectProvider
```

---

## 🎯 Definition of Done (Phase 2)

**Phase 2 ist fertig, wenn:**
- [ ] Bottom Navigation Bar funktioniert
- [ ] Alle 4 Tabs sind anklickbar
- [ ] CreateProjectScreen zeigt Kategorien
- [ ] Navigation Home → CreateProject funktioniert
- [ ] Back-Button funktioniert
- [ ] State bleibt erhalten beim Tab-Wechsel
- [ ] APK baut erfolgreich durch GitHub Actions

**Geschätzte Zeit:** 2-3 Sessions

---

## 🔗 Wichtige Links

- **React Native Referenz:** `/home/user/GameForge-Studio/app-react-native/`
- **Flutter App:** `/home/user/GameForge-Studio/app/`
- **Dokumentation:** `/home/user/GameForge-Studio/CLAUDE.md`
- **Branch:** `claude/flutter-setup-FTf1N`
- **GitHub Actions:** https://github.com/ReichiMD/GameForge-Studio/actions

---

## 💡 Quick Start für nächste Session

```bash
# Check Branch
git status

# Check Flutter Version
cd app && flutter --version

# Run App (wenn gewünscht)
flutter run

# Install Dependencies (falls nötig)
flutter pub get

# Build APK lokal testen
flutter build apk --release
```

---

**Erstellt:** Session #6 - Flutter Setup
**Nächste Session:** Phase 2 - Navigation & Screens
**Status:** ✅ Phase 1 komplett, bereit für Phase 2
