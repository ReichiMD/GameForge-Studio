# 🎮 GameForge Studio

> **Mobile App für kinderfreundliche Minecraft Addon-Erstellung**

GameForge Studio ist eine **React Native Mobile App**, die es einem 7-jährigen Kind (zusammen mit Papa) ermöglicht, **Minecraft Bedrock Addons** zu erstellen - ganz **ohne Programmieren**! Mit großen Buttons, Emojis und Schiebereglern können custom Waffen, Items und Blöcke erstellt werden.

**Platform:** Android (React Native + Expo)
**Zielgruppe:** Kinder & Hobby-Creators
**Backend:** GitHub Actions + Gemini AI

---

## ✨ Features

### 🏠 HomeScreen - Projektliste
- Alle Projekte auf einen Blick
- Neues Projekt mit einem Tap erstellen
- Direkt zu GitHub pushen
- Projekt-Status: Draft oder Published

### 📚 LibraryScreen - Item-Galerie
- Items aus **fabrik-library** durchstöbern
- Filter: Waffen, Tools, Blöcke
- Suche nach Namen
- Items zum Projekt hinzufügen

### 🔨 WorkshopScreen - Item-Editor
- **Schieberegler** für Item-Eigenschaften:
  - ⚔️ Damage (Schaden)
  - 🛡️ Durability (Haltbarkeit)
  - ⚡ Speed (Geschwindigkeit)
- Texture auswählen
- Name & Beschreibung eingeben
- Kinderfreundliche Bedienung

### 👁️ PreviewScreen - Item-Übersicht
- Alle Items im Projekt sehen
- Eigenschaften auf einen Blick
- Items bearbeiten oder löschen

### ⚙️ SettingsScreen - Einstellungen
- GitHub Token eingeben
- Sprache wählen (🇩🇪 DE / 🇬🇧 EN)
- Dark/Light Mode
- Repository-Verwaltung

---

## 🏗️ Architektur

```
┌─────────────────────┐
│  GameForge Studio   │  ← Diese App
│   (Mobile App)      │     React Native + Expo
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
- **PWA (Vorlage):** Fabrik-OS-Zentrale

---

## 🚀 Quick Start

### Voraussetzungen

- **Node.js** >= 18.0.0
- **npm** oder **pnpm**
- **Expo CLI:** `npm install -g expo-cli`
- **Android Studio** (für Emulator) oder physisches Android-Gerät

### Installation

```bash
# Repository klonen
git clone https://github.com/ReichiMD/GameForge-Studio.git
cd GameForge-Studio

# Dependencies installieren
npm install

# Expo Development Server starten
npm start

# Auf Android-Gerät/Emulator
# - Expo Go App auf Gerät installieren
# - QR-Code scannen
# ODER
npm run android
```

### Entwicklung

```bash
# Development Server
npm start

# Android Emulator
npm run android

# Tests
npm test

# Linting
npm run lint
```

---

## 🎨 Design-Prinzipien

### Kinderfreundlich aber nicht kindisch
- ✅ Moderne, cleane UI
- ✅ Große Buttons (60x60px)
- ✅ Emojis statt viel Text
- ✅ Intuitive Icons
- ❌ Keine Comic-Grafiken
- ❌ Keine Baby-Sprache

### Farbschema (Minecraft)
- **Purple:** `#8B5CF6` (Hauptaktionen)
- **Green:** `#10B981` (Erfolg)
- **Blue:** `#3B82F6` (Info)
- **Dark Mode:** `#1F2937` / `#111827`

---

## 📁 Projekt-Struktur

```
GameForge-Studio/
├── src/
│   ├── screens/           # 5 Haupt-Screens
│   ├── components/        # UI-Komponenten
│   ├── services/          # Business Logic
│   ├── hooks/             # Custom Hooks
│   ├── context/           # Global State
│   ├── utils/             # Hilfsfunktionen
│   ├── constants/         # Konstanten
│   └── assets/            # Icons, Bilder
├── docs/                  # Dokumentation
├── App.js                 # Entry Point
├── app.json               # Expo Config
└── package.json           # Dependencies
```

---

## 📚 Dokumentation

- **[PROJECT_INFO.md](PROJECT_INFO.md)** - Detaillierte Projektinformationen
- **[INDEX.md](INDEX.md)** - Modul-Verzeichnis
- **[SESSION_LOG.md](SESSION_LOG.md)** - Development Logs

---

## 🔧 Technologie-Stack

### Frontend
- **React Native** 0.73+
- **Expo** SDK 50+
- **React Navigation** 6
- **React Native Paper** (UI)
- **AsyncStorage** (Persistenz)
- **Axios** (HTTP)

### Backend (extern)
- **GitHub Actions**
- **Google Gemini AI**

### Daten
- **fabrik-library** (GitHub)
- **JSON** Format

---

## 🗺️ Roadmap

### Sprint 1 (Woche 1-2) - Setup
- [x] Projekt-Dokumentation
- [ ] Expo/React Native Setup
- [ ] Navigation-Struktur
- [ ] Theme & Design-System
- [ ] HomeScreen

### Sprint 2 (Woche 3-4) - Library & Workshop
- [ ] LibraryScreen (fabrik-library)
- [ ] WorkshopScreen (Editor)
- [ ] Item-Eigenschaften (Schieberegler)
- [ ] AsyncStorage Integration

### Sprint 3 (Woche 5-6) - GitHub Integration
- [ ] GitHubService (API)
- [ ] GitHub Token Verwaltung
- [ ] project.json Export
- [ ] Push zu Werkstatt

### Sprint 4 (Woche 7-8) - Polish
- [ ] PreviewScreen
- [ ] SettingsScreen
- [ ] Testing & Bug-Fixes
- [ ] Alpha Release

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
- **PWA-Vorlage:** Fabrik-OS-Zentrale
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

[Dokumentation](PROJECT_INFO.md) • [Module](INDEX.md) • [Logs](SESSION_LOG.md)

</div>
