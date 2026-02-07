# 🎮 GameForge Studio

> **Mobile App für kinderfreundliche Minecraft Addon-Erstellung**

GameForge Studio ist eine **Flutter Mobile App**, die es einem 7-jährigen Kind (zusammen mit Papa) ermöglicht, **Minecraft Bedrock Addons** zu erstellen - ganz **ohne Programmieren**! Mit großen Buttons, Emojis und Schiebereglern können custom Waffen, Items und Blöcke erstellt werden.

**Platform:** Android (Flutter + Dart)
**Zielgruppe:** Kinder & Hobby-Creators
**Backend:** GitHub Actions + Gemini AI
**Status:** Phase 2 abgeschlossen (~85%)

---

## ✨ Features

### 🏠 HomeScreen - Projektliste
- Alle Projekte auf einen Blick
- Neues Projekt mit einem Tap erstellen
- Projekt-Status: Draft oder Published

### 📚 LibraryScreen - Item-Galerie
- Items aus **fabrik-library** durchstöbern
- Filter: Waffen, Rüstung, Nahrung, Blöcke
- Suche nach Namen
- Items zum Projekt hinzufügen

### 🔨 WorkshopScreen - Item-Editor
- **Schieberegler** für Item-Eigenschaften:
  - ⚔️ Damage (Schaden)
  - 🛡️ Durability (Haltbarkeit)
  - ⚡ Speed (Geschwindigkeit)
- **Effekt-Toggles** (Feuer, Leuchten)
- Kinderfreundliche Bedienung

### ⚙️ SettingsScreen - Einstellungen
- GitHub Token eingeben
- Logout-Funktion
- Repository-Verwaltung

---

## 🏗️ Architektur

```
┌─────────────────────┐
│  GameForge Studio   │  ← Diese App
│   (Mobile App)      │     Flutter + Dart
└──────────┬──────────┘
           │ project.json
           ↓
┌─────────────────────┐
│   Werkstatt-Repo    │  ← Backend
│  (GitHub Actions)   │     Gemini AI
└──────────┬──────────┘
           │ .mcaddon
           ↓
┌─────────────────────┐
│    Minecraft        │  ← Spieler installiert
│     Bedrock         │
└─────────────────────┘
```

### Externe Repositories

- **Werkstatt:** https://github.com/ReichiMD/Werkstatt-Minecraft-Addon
- **fabrik-library:** https://github.com/ReichiMD/fabrik-library

---

## 🚀 Quick Start

### Voraussetzungen

- **Flutter** >= 3.24.0
- **Dart** >= 3.5.0
- **Android Studio** (für Emulator) oder physisches Android-Gerät

### Installation

```bash
# Repository klonen
git clone https://github.com/ReichiMD/GameForge-Studio.git
cd GameForge-Studio/app

# Dependencies installieren
flutter pub get

# App starten (Debug)
flutter run

# APK bauen (Release)
flutter build apk --release
```

### APK Download

APKs werden automatisch via GitHub Actions gebaut:
- **Branch:** `claude/review-flutter-docs-TbN9s` (oder aktueller Branch)
- **GitHub Actions:** https://github.com/ReichiMD/GameForge-Studio/actions
- **Download:** Unter "Artifacts" → "GameForge-APK"

---

## 🎨 Design-Prinzipien

### Kinderfreundlich aber nicht kindisch
- ✅ Moderne, cleane UI (Material 3)
- ✅ Große Buttons (60x60px Touch-Targets)
- ✅ Emojis statt viel Text
- ✅ Intuitive Icons
- ❌ Keine Comic-Grafiken
- ❌ Keine Baby-Sprache

### Farbschema (Minecraft-inspiriert)
- **Purple:** `#8B5CF6` (Hauptaktionen)
- **Green:** `#10B981` (Erfolg)
- **Blue:** `#3B82F6` (Info)
- **Red:** `#EF4444` (Fehler)
- **Dark Mode:** `#1F2937` / `#111827` (Background)

---

## 📁 Projekt-Struktur

```
GameForge-Studio/
├── app/                       # Flutter App
│   ├── lib/
│   │   ├── main.dart         # Entry Point + Navigation
│   │   ├── screens/          # 6 Screens (Login, Home, Create, Workshop, Library, Settings)
│   │   ├── theme/            # app_colors.dart, app_spacing.dart, app_theme.dart
│   │   ├── models/           # TODO: Project, Item Models
│   │   ├── services/         # TODO: ProjectService, LibraryService
│   │   └── data/             # TODO: vanilla_stats.json Loader
│   ├── pubspec.yaml          # Dependencies
│   └── android/              # Android-spezifische Dateien
├── library/                   # Item-Daten
│   ├── vanilla_stats.json    # 39 Minecraft Items mit Stats
│   └── README.md             # Erklärt vanilla_stats.json
├── .github/workflows/        # CI/CD (GitHub Actions)
├── CLAUDE.md                 # Session Quick Start (lies zuerst!)
├── FLUTTER_STATUS.md         # Technischer Status
├── SESSION_LOG.md            # Development Historie
├── PROJECT_INFO.md           # Projekt-Architektur
├── ROADMAP.md                # Feature-Planung
└── README.md                 # Diese Datei
```

---

## 📚 Dokumentation

Für AI-Assistenten (Claude):
- **[CLAUDE.md](CLAUDE.md)** - **START HIER!** Session Quick Start (2.000 Tokens)
- **[FLUTTER_STATUS.md](FLUTTER_STATUS.md)** - Technischer Status (bei Bedarf, 5.000 Tokens)
- **[SESSION_LOG.md](SESSION_LOG.md)** - Entwicklungs-Historie

Für Menschen:
- **[PROJECT_INFO.md](PROJECT_INFO.md)** - Detaillierte Projektinformationen
- **[ROADMAP.md](ROADMAP.md)** - Feature-Planung & Roadmap

---

## 🔧 Technologie-Stack

### Frontend
- **Flutter** 3.27.1
- **Dart** 3.6.0
- **Material 3** Design
- **SharedPreferences** (Persistenz)
- **HTTP** Package (geplant für GitHub API)

### Backend (extern)
- **GitHub Actions**
- **Google Gemini AI**

### Daten
- **fabrik-library** (GitHub)
- **vanilla_stats.json** (lokal + remote)

---

## 🗺️ Roadmap

### ✅ Phase 1: Core Setup (Komplett)
- ✅ Flutter-Projekt Setup
- ✅ Design-System (Material 3, Theme)
- ✅ LoginScreen + Auth (SharedPreferences)
- ✅ HomeScreen (Basis)
- ✅ GitHub Actions (APK Build)

### ✅ Phase 2: Navigation & Screens (Komplett)
- ✅ Bottom Navigation (4 Tabs)
- ✅ CreateProjectScreen (6 Kategorien)
- ✅ WorkshopScreen MVP (Slider, Toggles)
- ✅ SettingsScreen (Logout)

### ⏳ Phase 3: Daten-Integration (In Arbeit)
- [ ] Projekt-Speicherung (SharedPreferences)
- [ ] vanilla_stats.json laden
- [ ] WorkshopScreen mit echten Item-Daten
- [ ] Item-Selection Modal

### 📅 Phase 4: Features & Polish (Geplant)
- [ ] LibraryScreen (Item-Galerie)
- [ ] GitHub Integration (API)
- [ ] project.json Export
- [ ] App-Icon + Splash-Screen

---

## 🤝 Contributing

Contributions willkommen! Bitte:

1. Fork das Repository
2. Feature-Branch erstellen (`git checkout -b feature/AmazingFeature`)
3. Änderungen committen (`git commit -m 'Add AmazingFeature'`)
4. Branch pushen (`git push origin feature/AmazingFeature`)
5. Pull Request öffnen

---

## 📄 License

MIT License - siehe [LICENSE](LICENSE) Datei

---

## 🙏 Credits

- **Inspiriert von:** Minecraft Bedrock Edition
- **Backend:** Werkstatt-Minecraft-Addon
- **Daten:** fabrik-library

---

## 📞 Support

- **GitHub Issues:** [Bug Reports](https://github.com/ReichiMD/GameForge-Studio/issues)
- **Werkstatt:** https://github.com/ReichiMD/Werkstatt-Minecraft-Addon
- **Library:** https://github.com/ReichiMD/fabrik-library

---

<div align="center">

**Made with ❤️ for young creators**

[Dokumentation](CLAUDE.md) • [Status](FLUTTER_STATUS.md) • [Logs](SESSION_LOG.md)

</div>
