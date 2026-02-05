# GameForge Studio - Modul-Verzeichnis

## 📚 Übersicht

Dieses Dokument dient als zentrales Verzeichnis aller Module, Screens, Services und Komponenten der **GameForge Studio Mobile App** (React Native).

**Projekt-Typ:** Mobile App für Minecraft Addon-Erstellung
**Zielgruppe:** 7-jähriges Kind + Vater
**Platform:** Android (React Native + Expo)

---

## 🗂️ Hauptverzeichnisse

### `/src` - Source Code
Gesamter App-Code (Screens, Components, Services)

### `/src/screens` - Screen-Komponenten
Die 5 Haupt-Screens der App

### `/src/components` - UI-Komponenten
Wiederverwendbare React Native Komponenten

### `/src/services` - Business Logic
Services für GitHub, Projekte, Library etc.

### `/docs` - Dokumentation
Projekt-Dokumentation, Guides, API-Referenzen

### `/assets` - Assets
Icons, Bilder, Fonts (nicht unter src/)

---

## 📱 Screens (Haupt-Bildschirme)

| Screen | Datei | Beschreibung | Features | Status |
|--------|-------|--------------|----------|--------|
| **Home** | `screens/HomeScreen.jsx` | Projektliste, neues Projekt erstellen | Projektliste, Erstellen, Löschen, GitHub Push | 🔴 Geplant |
| **Library** | `screens/LibraryScreen.jsx` | Item-Galerie aus fabrik-library | Grid-View, Filter, Suche, Item-Details | 🔴 Geplant |
| **Workshop** | `screens/WorkshopScreen.jsx` | Item-Editor mit Schiebereglern | Eigenschaften-Editor, Texture-Auswahl | 🔴 Geplant |
| **Preview** | `screens/PreviewScreen.jsx` | Item-Übersicht im Projekt | Item-Liste, Eigenschaften, Bearbeiten | 🔴 Geplant |
| **Settings** | `screens/SettingsScreen.jsx` | App-Einstellungen | GitHub Token, Sprache, Theme | 🔴 Geplant |

---

## 🧩 Components (UI-Komponenten)

### Common Components
| Komponente | Pfad | Beschreibung | Status |
|------------|------|--------------|--------|
| Button | `components/common/Button.jsx` | Große Touch-Buttons (60x60px) | 🔴 Geplant |
| Card | `components/common/Card.jsx` | Projekt/Item-Karten | 🔴 Geplant |
| Input | `components/common/Input.jsx` | Text-Eingabefelder | 🔴 Geplant |
| Slider | `components/common/Slider.jsx` | Schieberegler für Eigenschaften | 🔴 Geplant |
| IconButton | `components/common/IconButton.jsx` | Icon-basierte Buttons | 🔴 Geplant |

### Item Components
| Komponente | Pfad | Beschreibung | Status |
|------------|------|--------------|--------|
| ItemCard | `components/item/ItemCard.jsx` | Item-Karte in Galerie | 🔴 Geplant |
| ItemPreview | `components/item/ItemPreview.jsx` | Item-Vorschau mit Texture | 🔴 Geplant |
| ItemProperty | `components/item/ItemProperty.jsx` | Einzelne Item-Eigenschaft | 🔴 Geplant |
| PropertySlider | `components/item/PropertySlider.jsx` | Schieberegler für Item-Werte | 🔴 Geplant |

### Navigation Components
| Komponente | Pfad | Beschreibung | Status |
|------------|------|--------------|--------|
| BottomNav | `components/navigation/BottomNav.jsx` | Bottom Tab Navigation | 🔴 Geplant |
| BurgerMenu | `components/navigation/BurgerMenu.jsx` | Seitenmenü (Multi-Game) | 🔴 Geplant |
| Header | `components/navigation/Header.jsx` | Screen-Header mit Back-Button | 🔴 Geplant |

### Project Components
| Komponente | Pfad | Beschreibung | Status |
|------------|------|--------------|--------|
| ProjectCard | `components/project/ProjectCard.jsx` | Projekt-Karte in Liste | 🔴 Geplant |
| ProjectHeader | `components/project/ProjectHeader.jsx` | Projekt-Info-Header | 🔴 Geplant |

---

## 🔧 Services (Business Logic)

### Core Services
| Service | Datei | Beschreibung | PWA-Modul | Status |
|---------|-------|--------------|-----------|--------|
| **ProjectService** | `services/ProjectService.js` | Projekt-CRUD, Speicherung | `project_manager.js` | 🔴 Geplant |
| **GitHubService** | `services/GitHubService.js` | GitHub API Integration | `github_api.js` | 🔴 Geplant |
| **LibraryService** | `services/LibraryService.js` | fabrik-library API | `ui_library.js` | 🔴 Geplant |
| **TranslationService** | `services/TranslationService.js` | i18n (DE/EN) | `dictionary.js` | 🔴 Geplant |

### Helper Services
| Service | Datei | Beschreibung | Status |
|---------|-------|--------------|--------|
| StorageService | `services/StorageService.js` | AsyncStorage Wrapper | 🔴 Geplant |
| ValidationService | `services/ValidationService.js` | Input-Validierung | 🔴 Geplant |
| NotificationService | `services/NotificationService.js` | Push-Benachrichtigungen | 🔴 Geplant |

---

## 🎣 Custom Hooks

| Hook | Datei | Beschreibung | Status |
|------|-------|--------------|--------|
| useProjects | `hooks/useProjects.js` | Projekt-State Management | 🔴 Geplant |
| useLibrary | `hooks/useLibrary.js` | Library-Items laden | 🔴 Geplant |
| useGitHub | `hooks/useGitHub.js` | GitHub API Calls | 🔴 Geplant |
| useTheme | `hooks/useTheme.js` | Theme (Dark/Light) | 🔴 Geplant |

---

## 🌐 Context (Global State)

| Context | Datei | Beschreibung | Status |
|---------|-------|--------------|--------|
| ProjectContext | `context/ProjectContext.js` | Aktuelle Projekte | 🔴 Geplant |
| SettingsContext | `context/SettingsContext.js` | App-Einstellungen | 🔴 Geplant |
| ThemeContext | `context/ThemeContext.js` | Dark/Light Mode | 🔴 Geplant |

---

## 🛠️ Utils (Hilfsfunktionen)

| Utility | Datei | Beschreibung | Status |
|---------|-------|--------------|--------|
| colors | `utils/colors.js` | Farb-Konstanten (Purple, Green, Blue) | 🔴 Geplant |
| formatters | `utils/formatters.js` | Text-Formatierung | 🔴 Geplant |
| validators | `utils/validators.js` | Input-Validierung | 🔴 Geplant |
| api | `utils/api.js` | Axios-Konfiguration | 🔴 Geplant |

---

## 📦 Constants (Konstanten)

| Konstante | Datei | Beschreibung | Status |
|-----------|-------|--------------|--------|
| screens | `constants/screens.js` | Screen-Namen | 🔴 Geplant |
| colors | `constants/colors.js` | Farbschema | 🔴 Geplant |
| config | `constants/config.js` | App-Konfiguration | 🔴 Geplant |
| api | `constants/api.js` | API-Endpoints | 🔴 Geplant |

---

## 🔗 Externe Repositories

### Werkstatt-Minecraft-Addon (Backend)
**URL:** https://github.com/ReichiMD/Werkstatt-Minecraft-Addon
**Funktion:** GitHub Actions + Gemini AI → .mcaddon generieren
**Integration:** App pusht project.json, triggert Action

### fabrik-library (Daten)
**URL:** https://github.com/ReichiMD/fabrik-library
**Funktion:** Mojang Items, Texturen, Modelle
**Integration:** App lädt Items via GitHub Raw Content API

### Fabrik-OS-Zentrale (PWA)
**Status:** Existierende PWA mit ähnlichen Features
**Wiederverwendung:** Module portieren (siehe Services-Tabelle)

---

## 📄 Wichtige Dateien

### Root-Level
- **README.md** - Projekt-Hauptdokumentation
- **PROJECT_INFO.md** - Detaillierte Projektinformationen
- **INDEX.md** - Dieses Modul-Verzeichnis
- **SESSION_LOG.md** - Development Session Logs
- **.claudeignore** - Token-Optimierung für Claude

### React Native Konfiguration
- **package.json** - Dependencies & Scripts
- **app.json** - Expo-Konfiguration
- **babel.config.js** - Babel-Setup
- **.eslintrc.js** - Code-Style
- **.prettierrc** - Formatting

### Entry Point
- **App.js** - Haupt-App-Komponente
- **app/_layout.jsx** - Expo Router Layout (falls Expo Router)
- **index.js** - App-Entry (falls Standard RN)

---

## 🔍 Schnellzugriff

### Häufig genutzte Dateien
1. **App Entry:** `App.js` oder `app/_layout.jsx`
2. **Home Screen:** `src/screens/HomeScreen.jsx`
3. **Workshop Screen:** `src/screens/WorkshopScreen.jsx`
4. **Project Service:** `src/services/ProjectService.js`
5. **GitHub Service:** `src/services/GitHubService.js`

### Wichtige Configs
1. **Expo Config:** `app.json`
2. **Package Config:** `package.json`
3. **Theme Config:** `src/constants/colors.js`
4. **API Config:** `src/constants/api.js`

---

## 📊 Status-Legende

- 🟢 Implementiert & Getestet
- 🟡 In Entwicklung
- 🟠 Geplant (nächster Sprint)
- 🔴 Geplant (Backlog)
- 🔄 Wird portiert aus PWA
- ⚪ Optional / Nice-to-have

---

## 🔄 PWA-Portierung Mapping

| PWA-Datei | App-Ziel | Änderungen nötig | Status |
|-----------|----------|------------------|--------|
| `ui_library.js` | `screens/LibraryScreen.jsx` | React Native Components | 🔄 Portieren |
| `ui_workshop.js` | `screens/WorkshopScreen.jsx` | React Native Sliders | 🔄 Portieren |
| `project_manager.js` | `services/ProjectService.js` | AsyncStorage statt localStorage | 🔄 Portieren |
| `github_api.js` | `services/GitHubService.js` | Axios statt fetch | 🔄 Portieren |
| `dictionary.js` | `services/TranslationService.js` | i18n-Integration | 🔄 Portieren |

---

## 🎮 Feature-Module Mapping

### HomeScreen Features
- Projektliste → ProjectService.getAll()
- Neues Projekt → ProjectService.create()
- GitHub Push → GitHubService.push()
- Projekt löschen → ProjectService.delete()

### LibraryScreen Features
- Item-Galerie → LibraryService.getItems()
- Filter → LibraryService.filter()
- Suche → LibraryService.search()
- Item hinzufügen → ProjectService.addItem()

### WorkshopScreen Features
- Item-Editor → ItemEditor Component
- Schieberegler → PropertySlider Component
- Speichern → ProjectService.updateItem()
- Texture-Auswahl → TexturePicker Component

### PreviewScreen Features
- Item-Liste → ProjectService.getItems()
- Bearbeiten → Navigation zu Workshop
- Löschen → ProjectService.deleteItem()

### SettingsScreen Features
- GitHub Token → StorageService.setToken()
- Sprache → TranslationService.setLanguage()
- Theme → ThemeContext.toggle()

---

## 🔄 Letzte Updates

| Datum | Bereich | Änderung |
|-------|---------|----------|
| 2026-02-05 | INDEX.md | Komplett neu strukturiert für React Native App |
| 2026-02-05 | Screens | 5 Haupt-Screens definiert |
| 2026-02-05 | Services | PWA-Mapping erstellt |

---

## 💡 Naming Conventions

### Screens
- **Format:** `<Name>Screen.jsx`
- **Beispiel:** `HomeScreen.jsx`, `LibraryScreen.jsx`

### Components
- **Format:** `<Name>.jsx` (PascalCase)
- **Beispiel:** `Button.jsx`, `ItemCard.jsx`

### Services
- **Format:** `<Name>Service.js`
- **Beispiel:** `ProjectService.js`, `GitHubService.js`

### Hooks
- **Format:** `use<Name>.js`
- **Beispiel:** `useProjects.js`, `useTheme.js`

### Constants
- **Format:** `<name>.js` (lowercase)
- **Beispiel:** `colors.js`, `screens.js`

---

**Hinweis:** Dieses Dokument wird kontinuierlich aktualisiert während der Entwicklung.

**Version:** 2.0 (Korrigiert für React Native Mobile App)
**Letzte Aktualisierung:** 2026-02-05
