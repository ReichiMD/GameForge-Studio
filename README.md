# 🎮 GameForge Studio

> **Ein modernes, modulares Framework für die Spieleentwicklung**

GameForge Studio ist ein leistungsstarkes und flexibles Game Development Framework, das Entwicklern ermöglicht, schnell und effizient hochwertige Spiele zu erstellen. Mit einer intuitiven Editor-Oberfläche, einem robusten Entity-Component-System und einem erweiterbaren Plugin-System bietet GameForge Studio alles, was moderne Spieleentwickler benötigen.

---

## ✨ Features

### 🎯 Core Engine
- **High-Performance Game Loop** - Optimiert für 60+ FPS
- **Entity Component System (ECS)** - Flexibles und skalierbares Design-Pattern
- **Scene Management** - Hierarchische Szenen-Verwaltung mit Lifecycle-Hooks
- **Event System** - Reaktives Messaging-System für lose Kopplung

### 🎨 Visual Editor
- **Intuitive UI** - React-basierte moderne Benutzeroberfläche
- **Real-time Preview** - Sofortiges Feedback während der Entwicklung
- **Asset Browser** - Zentrales Asset-Management-System
- **Inspector Panel** - Detaillierte Eigenschaften-Bearbeitung
- **Hierarchy View** - Übersichtliche Szenen-Hierarchie

### 🚀 Runtime Features
- **Input System** - Unterstützung für Keyboard, Mouse, Touch & Gamepad
- **Audio Engine** - 3D-Audio mit räumlicher Positionierung
- **Physics Integration** - 2D/3D Physik-Engine Support
- **Animation System** - Keyframe & Skelett-Animationen
- **Particle System** - Hochperformante Partikel-Effekte

### 🔧 Developer Tools
- **TypeScript Support** - Vollständige Type-Safety
- **Hot Module Replacement** - Schnelle Entwicklungs-Iteration
- **Debug Console** - Integrierte Debugging-Tools
- **Performance Profiler** - Echtzeit-Performance-Analyse
- **Visual Script Editor** - Node-basierte Script-Erstellung (geplant)

### 🔌 Plugin System
- **Erweiterbar** - Einfache Plugin-Entwicklung
- **Community Plugins** - Wachsendes Ecosystem
- **Plugin Marketplace** - Zentrale Plugin-Verwaltung (geplant)

---

## 🚀 Quick Start

### Voraussetzungen

- **Node.js** >= 18.0.0
- **npm** >= 9.0.0 oder **pnpm** >= 8.0.0
- **Git** >= 2.30.0

### Installation

```bash
# Repository klonen
git clone https://github.com/ReichiMD/GameForge-Studio.git
cd GameForge-Studio

# Dependencies installieren
npm install
# oder
pnpm install

# Development Server starten
npm run dev

# Editor öffnet sich automatisch unter http://localhost:5173
```

### Dein erstes Spiel

```typescript
import { Engine, Scene, Entity } from '@gameforge/core';

// Engine initialisieren
const engine = new Engine({
  width: 800,
  height: 600,
  fps: 60
});

// Scene erstellen
const scene = new Scene('MainScene');

// Entity hinzufügen
const player = new Entity('Player');
player.addComponent('Transform', { x: 100, y: 100 });
player.addComponent('Sprite', { texture: 'player.png' });
player.addComponent('RigidBody', { mass: 1 });

scene.addEntity(player);

// Scene laden und starten
engine.loadScene(scene);
engine.start();
```

---

## 📚 Dokumentation

- **[Getting Started](docs/getting-started.md)** - Erste Schritte mit GameForge Studio
- **[API Reference](docs/api/README.md)** - Vollständige API-Dokumentation
- **[Tutorials](docs/tutorials/README.md)** - Schritt-für-Schritt Anleitungen
- **[Examples](examples/README.md)** - Beispiel-Projekte und Demos
- **[Plugin Development](docs/plugins/README.md)** - Eigene Plugins erstellen
- **[Architecture](docs/architecture/README.md)** - Technische Architektur-Details

### Wichtige Projekt-Dokumente

- **[PROJECT_INFO.md](PROJECT_INFO.md)** - Detaillierte Projektinformationen
- **[INDEX.md](INDEX.md)** - Modul-Verzeichnis und Übersicht
- **[SESSION_LOG.md](SESSION_LOG.md)** - Development Session Logs

---

## 🛠️ Development

### Project Structure

```
GameForge-Studio/
├── src/
│   ├── core/              # Core Engine (ECS, Scene, Events)
│   ├── editor/            # Editor Application (React)
│   ├── runtime/           # Game Runtime (Input, Audio, Physics)
│   └── utils/             # Shared Utilities
├── tests/                 # Unit & Integration Tests
├── examples/              # Example Games & Demos
├── docs/                  # Documentation
└── tools/                 # Build Tools & Scripts
```

### Build Commands

```bash
# Development Server (mit HMR)
npm run dev

# Production Build
npm run build

# Tests ausführen
npm test

# Test Coverage
npm run test:coverage

# Linting
npm run lint

# Type Checking
npm run type-check

# Build Documentation
npm run docs:build
```

### Testing

```bash
# Alle Tests
npm test

# Watch Mode
npm run test:watch

# Specific Test File
npm test -- src/core/engine/Engine.test.ts

# E2E Tests
npm run test:e2e
```

---

## 🤝 Contributing

Wir freuen uns über Beiträge zur GameForge Studio! Ob Bug-Fixes, neue Features oder Dokumentation - jede Hilfe ist willkommen.

### Contribution Guidelines

1. **Fork** das Repository
2. **Erstelle** einen Feature-Branch (`git checkout -b feature/AmazingFeature`)
3. **Committe** deine Änderungen (`git commit -m 'Add some AmazingFeature'`)
4. **Push** zum Branch (`git push origin feature/AmazingFeature`)
5. **Öffne** einen Pull Request

### Development Guidelines

- **Code Style:** ESLint + Prettier (automatisch beim Commit)
- **Commit Messages:** [Conventional Commits](https://www.conventionalcommits.org/)
- **Tests:** Minimum 80% Coverage für neue Features
- **Dokumentation:** Inline-Kommentare + API-Docs
- **Type Safety:** Strict TypeScript Mode

### Code Review Process

1. Automatische Checks (Linting, Tests, Build)
2. Review von mindestens einem Maintainer
3. Approval + Merge

---

## 🐛 Bug Reports & Feature Requests

Nutze die [GitHub Issues](https://github.com/ReichiMD/GameForge-Studio/issues) für:

- 🐛 Bug Reports
- 💡 Feature Requests
- 📝 Documentation Improvements
- ❓ Questions & Discussions

**Bug Report Template:**
```markdown
**Beschreibung:** Was ist das Problem?
**Schritte zur Reproduktion:** Wie kann man den Bug reproduzieren?
**Erwartetes Verhalten:** Was sollte passieren?
**Aktuelles Verhalten:** Was passiert stattdessen?
**Environment:** OS, Node-Version, Browser etc.
**Screenshots:** Falls relevant
```

---

## 🗺️ Roadmap

### Q1 2026 - Foundation
- [x] Projekt-Setup & Dokumentation
- [ ] Core Engine Implementation
- [ ] Basic Scene Management
- [ ] ECS Foundation

### Q2 2026 - Editor Development
- [ ] React Editor UI
- [ ] Asset Browser
- [ ] Scene Hierarchy
- [ ] Inspector Panel

### Q3 2026 - Runtime Features
- [ ] Input System
- [ ] Audio Engine
- [ ] Physics Integration
- [ ] Animation System

### Q4 2026 - Polish & Release
- [ ] Plugin System
- [ ] Performance Optimization
- [ ] Documentation Complete
- [ ] Beta Release

Siehe [PROJECT_INFO.md](PROJECT_INFO.md) für detaillierte Milestones.

---

## 📊 Project Status

| Component | Status | Coverage | Docs |
|-----------|--------|----------|------|
| Core Engine | 🔴 Planned | 0% | 📝 WIP |
| Scene Manager | 🔴 Planned | 0% | 📝 WIP |
| ECS | 🔴 Planned | 0% | 📝 WIP |
| Editor | 🔴 Planned | 0% | 📝 WIP |
| Runtime | 🔴 Planned | 0% | 📝 WIP |
| Plugins | 🔴 Planned | 0% | 📝 WIP |

**Legend:** 🟢 Done | 🟡 In Progress | 🟠 Next | 🔴 Planned

---

## 📄 License

Dieses Projekt ist unter der **MIT License** lizenziert - siehe [LICENSE](LICENSE) Datei für Details.

```
MIT License

Copyright (c) 2026 GameForge Studio Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

[... siehe LICENSE Datei für vollständigen Text]
```

---

## 🙏 Acknowledgments

- Inspiriert von **Unity**, **Godot** und **Unreal Engine**
- Nutzt **Three.js** für 3D-Rendering
- **React** für die Editor-UI
- **Vite** für schnelle Development-Builds
- Community-Beiträge und Feedback

---

## 📞 Support & Community

- **GitHub Issues:** [Bug Reports & Feature Requests](https://github.com/ReichiMD/GameForge-Studio/issues)
- **GitHub Discussions:** [Community Forum](https://github.com/ReichiMD/GameForge-Studio/discussions)
- **Discord:** Coming Soon
- **Twitter:** Coming Soon
- **Email:** TBD

---

## 🌟 Star History

Wenn dir GameForge Studio gefällt, gib uns einen ⭐ auf GitHub!

---

## 📈 Stats

![GitHub stars](https://img.shields.io/github/stars/ReichiMD/GameForge-Studio?style=social)
![GitHub forks](https://img.shields.io/github/forks/ReichiMD/GameForge-Studio?style=social)
![GitHub issues](https://img.shields.io/github/issues/ReichiMD/GameForge-Studio)
![GitHub pull requests](https://img.shields.io/github/issues-pr/ReichiMD/GameForge-Studio)
![License](https://img.shields.io/github/license/ReichiMD/GameForge-Studio)

---

<div align="center">

**Made with ❤️ by the GameForge Studio Team**

[Website](https://gameforge.studio) • [Documentation](docs/README.md) • [Examples](examples/README.md) • [Contributing](CONTRIBUTING.md)

</div>
