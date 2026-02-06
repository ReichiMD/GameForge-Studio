# GameForge Studio - Projekt-Information

## 📋 Projektübersicht

**Projekt:** GameForge Studio - Multi-Game Addon Creator App
**Typ:** Native Mobile App (React Native + Expo)
**Platform:** Android
**Status:** In Entwicklung
**Version:** 0.1.0-alpha
**Lizenz:** MIT

## 🎯 Projektziel

GameForge Studio ist eine **kinderfreundliche Mobile App**, die es einem 7-jährigen Kind (zusammen mit Papa) ermöglicht, **Game-Addons zu erstellen** - ohne Programmieren zu müssen!

**Erstes Spiel:** Minecraft Bedrock Addons (Waffen, Items, Blöcke)
**Später geplant:** Roblox, Terraria, Fortnite Creative etc.

## 👥 Zielgruppe

- **Kind (7 Jahre):** Intuitive Bedienung, große Buttons, Emojis, kinderfreundlich
- **Vater (kein Programmierer):** Einfache Einrichtung, keine technischen Kenntnisse nötig
- **Später:** Community von Hobby-Creators

## 🏗️ System-Architektur

### 3-Komponenten-System

```
┌─────────────────────┐
│  GameForge Studio   │  ← Diese App (React Native)
│   (Mobile App)      │     - UI für Item-Erstellung
│                     │     - Projekt-Management
└──────────┬──────────┘     - GitHub Push
           │
           │ project.json
           ↓
┌─────────────────────┐
│   Werkstatt-Repo    │  ← Backend (GitHub Actions)
│  (GitHub Actions)   │     - Empfängt project.json
│                     │     - Gemini AI Generation
└──────────┬──────────┘     - Erstellt .mcaddon
           │
           │ Item-Daten
           ↓
┌─────────────────────┐
│  fabrik-library     │  ← Daten-Repo
│  (Item-Bibliothek)  │     - Mojang Items
│                     │     - Texturen & Modelle
└─────────────────────┘     - JSON Definitionen
```

### Komponenten-Details

**1. GameForge Studio App (dieses Projekt)**
- React Native + Expo
- Screens: Home, Library, Workshop, Preview, Settings
- Services: GitHub API, Project Manager, Translations
- Lokale Speicherung: AsyncStorage

**2. Werkstatt-Repo** (externe Abhängigkeit)
- Repository: https://github.com/ReichiMD/Werkstatt-Minecraft-Addon
- GitHub Action triggert bei Push
- Gemini AI generiert Addon-Code
- Output: .mcaddon Datei

**3. fabrik-library** (Daten-Quelle)
- Repository: https://github.com/ReichiMD/fabrik-library
- Mojang Items mit Texturen
- JSON-Definitionen
- Wird von App geladen

**4. Fabrik-OS-Zentrale (PWA)** (Wiederverwendung)
- Existierende PWA mit ähnlichen Features
- Module können portiert werden
- UI-Komponenten als Vorlage

## 🎨 Design-Prinzipien

### UI/UX Guidelines

**Kinderfreundlich aber nicht kindisch:**
- ✅ Moderne, cleane Oberfläche
- ✅ Große, klare Buttons (min. 60x60px)
- ✅ Emojis statt viel Text
- ✅ Intuitive Icons
- ❌ Keine Comic-Grafiken
- ❌ Keine Baby-Sprache

**Farbschema (Minecraft-inspiriert):**
- **Primary:** Purple (`#8B5CF6`) - Hauptaktionen
- **Secondary:** Green (`#10B981`) - Erfolg, Speichern
- **Accent:** Blue (`#3B82F6`) - Info, Links
- **Background:** Dark Mode (`#1F2937`, `#111827`)

**Navigation:**
- Burger-Menü für Multi-Game Auswahl
- Bottom Navigation für Hauptbereiche
- Swipe-Gesten für Item-Galerie

**Button-Größen:**
- Touch-Target: Minimum 60x60px
- Icon-Größe: 32x32px
- Padding: 16px

## 📁 Projekt-Struktur

```
GameForge-Studio/
├── src/
│   ├── screens/           # Screen-Komponenten
│   │   ├── HomeScreen.jsx          # Projektliste
│   │   ├── LibraryScreen.jsx       # Item-Galerie
│   │   ├── WorkshopScreen.jsx      # Item-Editor
│   │   ├── PreviewScreen.jsx       # Item-Übersicht
│   │   └── SettingsScreen.jsx      # GitHub Token etc.
│   │
│   ├── components/        # Wiederverwendbare UI
│   │   ├── common/                 # Buttons, Cards etc.
│   │   ├── item/                   # Item-spezifisch
│   │   └── navigation/             # Navigation
│   │
│   ├── services/          # Business Logic
│   │   ├── ProjectService.js       # Projekt-Management
│   │   ├── GitHubService.js        # GitHub API
│   │   ├── LibraryService.js       # fabrik-library
│   │   └── TranslationService.js   # i18n (DE/EN)
│   │
│   ├── hooks/             # Custom React Hooks
│   ├── context/           # React Context (State)
│   ├── utils/             # Helper Functions
│   ├── constants/         # Konstanten, Configs
│   └── assets/            # Bilder, Icons, Fonts
│
├── docs/                  # Dokumentation
├── .expo/                 # Expo Cache
└── android/               # Native Code (falls nötig)
```

## 🎮 Features (Mini-Version)

### Phase 1: MVP (Minimum Viable Product)

#### 1️⃣ HomeScreen - Projektliste
- [ ] Liste aller Projekte
- [ ] Neues Projekt erstellen
- [ ] Projekt öffnen/löschen
- [ ] Projekt zu GitHub pushen
- [ ] Status: Draft / Published

#### 2️⃣ LibraryScreen - Item-Galerie
- [ ] Grid-View von Items (aus fabrik-library)
- [ ] Filter: Waffen, Tools, Blöcke
- [ ] Suche nach Namen
- [ ] Item-Details anzeigen
- [ ] Item zum Projekt hinzufügen

#### 3️⃣ WorkshopScreen - Item-Editor
- [ ] Item-Eigenschaften mit Schiebereglern
  - Damage (Schaden)
  - Durability (Haltbarkeit)
  - Speed (Geschwindigkeit)
- [ ] Texture-Auswahl
- [ ] Name & Beschreibung
- [ ] Speichern/Verwerfen

#### 4️⃣ PreviewScreen - Item-Übersicht
- [ ] Liste aller Items im Projekt
- [ ] Eigenschaften-Übersicht
- [ ] Item bearbeiten/löschen
- [ ] **Keine** 3D-Vorschau

#### 5️⃣ SettingsScreen - Einstellungen
- [ ] GitHub Token eingeben
- [ ] Repository-Auswahl (Werkstatt)
- [ ] Sprache: DE/EN
- [ ] Theme: Dark/Light
- [ ] Über/Info

### Phase 2: Erweiterungen (später)

- [ ] Mehr Item-Typen (Rüstungen, Lebensmittel)
- [ ] Roblox Integration
- [ ] Terraria Mods
- [ ] Community-Features (Teilen)
- [ ] Tutorial-System

## 🔗 PWA-Module zum Wiederverwenden

Diese Module aus der **Fabrik-OS-Zentrale PWA** können portiert werden:

| PWA-Modul | Ziel in App | Status |
|-----------|-------------|--------|
| `ui_library.js` | LibraryScreen | 🔄 Portieren |
| `ui_workshop.js` | WorkshopScreen | 🔄 Portieren |
| `project_manager.js` | ProjectService | 🔄 Portieren |
| `github_api.js` | GitHubService | 🔄 Portieren |
| `dictionary.js` | TranslationService | 🔄 Portieren |

**Nicht übernehmen:**
- ❌ Explorer (zu komplex für MVP)
- ❌ 3D-Preview (nicht in Mini-Version)
- ❌ Direkte KI-Integration (läuft im Backend)

## 🔧 Technologie-Stack

### Frontend (Mobile App)
- **Framework:** React Native 0.73+
- **Tooling:** Expo SDK 50+
- **Navigation:** React Navigation 6
- **State:** React Context + Hooks (später: Zustand)
- **Storage:** AsyncStorage
- **HTTP:** Axios
- **UI Library:** React Native Paper (Material Design)

### Backend (Werkstatt)
- **Platform:** GitHub Actions
- **AI:** Google Gemini API
- **Output:** .mcaddon Datei

### Daten (fabrik-library)
- **Format:** JSON
- **Assets:** PNG Texturen, .geo.json Modelle
- **Zugriff:** GitHub Raw Content API

### Development Tools
- **IDE:** VS Code + React Native Tools
- **Testing:** Jest + React Native Testing Library
- **Debugging:** Expo DevTools, React DevTools
- **Linting:** ESLint + Prettier
- **Git:** Conventional Commits

## 📊 Entwicklungs-Metriken

| Metrik | Ziel | Aktuell |
|--------|------|---------|
| Bundle Size | < 50 MB | 0 MB |
| Startup Time | < 3s | N/A |
| Test Coverage | 70% | 0% |
| Min. Android | API 24 (7.0) | N/A |
| Performance | 60 FPS | N/A |

## 🚀 Workflow

### App → Addon Pipeline

```
1. USER ERSTELLT ITEM
   ↓
   (App: WorkshopScreen)
   ↓
2. PROJEKT SPEICHERN
   ↓
   (App: ProjectService)
   ↓
3. PUSH TO GITHUB
   ↓
   (App: GitHubService → project.json)
   ↓
4. GITHUB ACTION TRIGGER
   ↓
   (Werkstatt: GitHub Actions)
   ↓
5. GEMINI AI GENERIERT CODE
   ↓
   (Werkstatt: Gemini API)
   ↓
6. .MCADDON ERSTELLEN
   ↓
   (Werkstatt: Build Script)
   ↓
7. DOWNLOAD LINK
   ↓
   (App: Benachrichtigung)
   ↓
8. INSTALLIEREN IN MINECRAFT
   ↓
   (User: Datei öffnen)
```

## 📅 Roadmap

### Sprint 1 (Woche 1-2): Setup & Basis
- [x] Projekt-Dokumentation korrigiert
- [x] React Native/Expo Setup
- [x] Navigation-Struktur (Bottom Tabs)
- [x] Theme & Design-System (colors, spacing, typography)
- [x] HomeScreen (Projektliste)
- [x] LibraryScreen (Item-Galerie)
- [x] WorkshopScreen (Item-Editor)
- [x] SettingsScreen (Einstellungen)
- [x] LoginScreen (Auth mit AsyncStorage)
- [x] Status Bar Fix (SafeAreaProvider)
- [x] CreateProjectScreen (Kategorie-Auswahl)
- [x] Stack Navigator für Home-Tab
- [x] Token-Optimierung (CLAUDE.md, MEMORY.md, Section-Kommentare)

### Sprint 2 (Woche 3-4): Library & Workshop
- [ ] LibraryScreen (fabrik-library Integration)
- [ ] WorkshopScreen (Item-Editor)
- [ ] Item-Eigenschaften (Schieberegler)
- [ ] Projekt-Speicherung (AsyncStorage)

### Sprint 3 (Woche 5-6): GitHub Integration
- [ ] GitHubService (API Client)
- [ ] GitHub Token Verwaltung
- [ ] project.json Export
- [ ] Push zu Werkstatt-Repo

### Sprint 4 (Woche 7-8): Polish & Testing
- [ ] PreviewScreen
- [ ] SettingsScreen
- [ ] Fehlerbehandlung
- [ ] Testing & Bug-Fixes
- [ ] Alpha Release

### Später (Q2 2026+)
- [ ] Roblox Support
- [ ] Terraria Mods
- [ ] Community Features
- [ ] Tutorial-System

## 🎓 Best Practices

### Code-Organisation
- **1 Screen = 1 File:** Keine riesigen Dateien
- **Services getrennt:** Keine Business Logic in Screens
- **Komponenten klein:** Max. 200 Zeilen
- **Custom Hooks:** Wiederverwendbare Logik

### Performance
- **Lazy Loading:** Screens on-demand laden
- **Image Optimization:** Komprimierte PNGs
- **List Virtualization:** FlatList für große Listen
- **Memo:** React.memo für teure Komponenten

### State Management
- **Local State:** useState für UI-State
- **Context:** Für App-weiten State (Projekte, Settings)
- **AsyncStorage:** Für Persistenz
- **Keine Redux:** Zu komplex für diesen Use-Case

## 🔒 Security & Privacy

- **GitHub Token:** Nur lokal in SecureStore gespeichert
- **Keine Cloud:** Alle Daten lokal oder in User's GitHub
- **Keine Analytics:** Privacy-First
- **Open Source:** Transparenter Code

## 🔐 Auth-System (Login)

**Implementiert in Session #4:**

- App zeigt beim Start einen Login-Screen
- User gibt **Benutzername** (z.B. "ReichiMD") und **GitHub Token** ein
- Login-Daten werden in **AsyncStorage** gespeichert (Key: `@gameforge_auth`)
- Persistente Anmeldung (kein erneutes Login bei jedem Start)
- Auth-Daten (`username` + `githubToken`) werden an AppNavigator durchgereicht
- Vorbereitet für GitHub API-Integration in allen Screens
- Logout-Funktion vorhanden (noch nicht in UI eingebaut → TODO: SettingsScreen)

## 🐛 Known Issues

- **TS-Fehler in HomeScreen:** `demoProjects` Array hat keine Type-Annotation → `status` wird als `string` inferiert statt `ProjectStatus` (kosmetisch, kein Runtime-Fehler)
- **Logout-Button fehlt:** `onLogout` wird an AppNavigator übergeben, aber noch nicht in SettingsScreen zugänglich
- **GitHub Token doppelt:** LoginScreen und SettingsScreen haben beide ein Token-Feld (sollte vereinheitlicht werden)

## 💡 Lessons Learned (aus PWA)

**Was gut funktioniert hat:**
- ✅ Schieberegler für Item-Eigenschaften
- ✅ Emoji-basierte Navigation
- ✅ Projekt-basierter Workflow
- ✅ GitHub als Backend

**Was verbessert werden soll:**
- 🔄 Performance (React Native ist schneller als PWA)
- 🔄 Native Feel (Touch-Gesten, Animationen)
- 🔄 Offline-First (PWA brauchte Internet)

## 📞 Kontakt & Support

- **GitHub Issues:** [Bug Reports & Feature Requests](https://github.com/ReichiMD/GameForge-Studio/issues)
- **Werkstatt-Repo:** https://github.com/ReichiMD/Werkstatt-Minecraft-Addon
- **fabrik-library:** https://github.com/ReichiMD/fabrik-library

---

**Letzte Aktualisierung:** 2026-02-06
**Dokument-Version:** 2.2 (CreateProjectScreen + Token-Optimierung)
