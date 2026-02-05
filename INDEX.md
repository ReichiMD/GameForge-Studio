# GameForge Studio - Modul-Verzeichnis

## 📚 Übersicht

Dieses Dokument dient als zentrales Verzeichnis aller Module, Komponenten und wichtigen Dateien im GameForge Studio Projekt.

---

## 🗂️ Hauptverzeichnisse

### `/src` - Source Code
Enthält den gesamten Quellcode des Projekts.

### `/docs` - Dokumentation
Alle projektbezogene Dokumentation, Guides und API-Referenzen.

### `/tests` - Tests
Unit-, Integration- und E2E-Tests.

### `/examples` - Beispiele
Demo-Projekte und Code-Beispiele.

### `/tools` - Tools
Build-Tools, Scripts und Entwickler-Utilities.

---

## 🎮 Core Module

### Engine Core
| Modul | Pfad | Beschreibung | Status |
|-------|------|--------------|--------|
| Engine | `src/core/engine/` | Haupt-Engine-Klasse | 🔴 Geplant |
| Game Loop | `src/core/loop/` | Game Loop Implementation | 🔴 Geplant |
| Time Manager | `src/core/time/` | Zeit- und Frame-Management | 🔴 Geplant |
| Event System | `src/core/events/` | Event-Bus und Messaging | 🔴 Geplant |

### Scene Management
| Modul | Pfad | Beschreibung | Status |
|-------|------|--------------|--------|
| Scene Manager | `src/core/scenes/` | Scene-Verwaltung und Lifecycle | 🔴 Geplant |
| Scene Graph | `src/core/scenegraph/` | Hierarchische Szenen-Struktur | 🔴 Geplant |
| Camera | `src/core/camera/` | Kamera-System | 🔴 Geplant |

### Entity Component System (ECS)
| Modul | Pfad | Beschreibung | Status |
|-------|------|--------------|--------|
| Entity Manager | `src/core/ecs/entities/` | Entity-Verwaltung | 🔴 Geplant |
| Component System | `src/core/ecs/components/` | Component-Architektur | 🔴 Geplant |
| System Manager | `src/core/ecs/systems/` | System-Processing | 🔴 Geplant |

---

## 🎨 Editor Module

### Editor Core
| Modul | Pfad | Beschreibung | Status |
|-------|------|--------------|--------|
| Editor App | `src/editor/app/` | Haupt-Editor-Anwendung | 🔴 Geplant |
| Viewport | `src/editor/viewport/` | 3D/2D Vorschau-Bereich | 🔴 Geplant |
| Inspector | `src/editor/inspector/` | Eigenschaften-Editor | 🔴 Geplant |
| Hierarchy | `src/editor/hierarchy/` | Szenen-Hierarchie-View | 🔴 Geplant |

### Editor Tools
| Modul | Pfad | Beschreibung | Status |
|-------|------|--------------|--------|
| Asset Browser | `src/editor/assets/` | Asset-Management-UI | 🔴 Geplant |
| Script Editor | `src/editor/scripting/` | Code-Editor Integration | 🔴 Geplant |
| Console | `src/editor/console/` | Debug-Konsole | 🔴 Geplant |
| Profiler | `src/editor/profiler/` | Performance-Profiling | 🔴 Geplant |

---

## 🎯 Runtime Module

### Game Systems
| Modul | Pfad | Beschreibung | Status |
|-------|------|--------------|--------|
| Input System | `src/runtime/input/` | Keyboard, Mouse, Gamepad | 🔴 Geplant |
| Audio System | `src/runtime/audio/` | Sound & Musik-Management | 🔴 Geplant |
| Physics | `src/runtime/physics/` | Physik-Engine Integration | 🔴 Geplant |
| Animation | `src/runtime/animation/` | Animation-System | 🔴 Geplant |

### Rendering
| Modul | Pfad | Beschreibung | Status |
|-------|------|--------------|--------|
| Renderer | `src/runtime/renderer/` | Rendering-Pipeline | 🔴 Geplant |
| Material System | `src/runtime/materials/` | Material & Shader | 🔴 Geplant |
| Lighting | `src/runtime/lighting/` | Beleuchtungs-System | 🔴 Geplant |
| Post-Processing | `src/runtime/postfx/` | Post-Processing-Effekte | 🔴 Geplant |

---

## 🔧 Utility Module

### Core Utils
| Modul | Pfad | Beschreibung | Status |
|-------|------|--------------|--------|
| Math Utils | `src/utils/math/` | Mathematische Hilfsfunktionen | 🔴 Geplant |
| File System | `src/utils/fs/` | Datei-Operationen | 🔴 Geplant |
| Logger | `src/utils/logger/` | Logging-System | 🔴 Geplant |
| Config | `src/utils/config/` | Konfigurations-Management | 🔴 Geplant |

### Asset Pipeline
| Modul | Pfad | Beschreibung | Status |
|-------|------|--------------|--------|
| Asset Loader | `src/utils/assets/loader/` | Asset-Loading-System | 🔴 Geplant |
| Asset Cache | `src/utils/assets/cache/` | Asset-Caching | 🔴 Geplant |
| Image Processor | `src/utils/assets/images/` | Bild-Verarbeitung | 🔴 Geplant |
| Model Importer | `src/utils/assets/models/` | 3D-Model-Import | 🔴 Geplant |

---

## 🔌 Plugin System

| Modul | Pfad | Beschreibung | Status |
|-------|------|--------------|--------|
| Plugin Manager | `src/plugins/manager/` | Plugin-Verwaltung | 🔴 Geplant |
| Plugin API | `src/plugins/api/` | Plugin-Entwickler-API | 🔴 Geplant |
| Core Plugins | `src/plugins/core/` | Standard-Plugins | 🔴 Geplant |

---

## 📦 Package Structure

### Main Packages
- **@gameforge/core** - Core Engine
- **@gameforge/editor** - Editor Application
- **@gameforge/runtime** - Game Runtime
- **@gameforge/utils** - Shared Utilities
- **@gameforge/plugins** - Plugin System

---

## 📄 Wichtige Dateien

### Dokumentation
- `README.md` - Projekt-Hauptdokumentation
- `PROJECT_INFO.md` - Detaillierte Projektinformationen
- `INDEX.md` - Dieses Modul-Verzeichnis
- `SESSION_LOG.md` - Entwicklungs-Session-Logs

### Konfiguration
- `package.json` - NPM Dependencies & Scripts
- `tsconfig.json` - TypeScript Konfiguration
- `vite.config.js` - Vite Build-Konfiguration
- `.eslintrc.js` - ESLint Code-Style
- `.prettierrc` - Prettier Formatting

### CI/CD
- `.github/workflows/` - GitHub Actions
- `.gitlab-ci.yml` - GitLab CI (falls verwendet)

---

## 🔍 Schnellzugriff

### Häufig genutzte Module
1. **Engine Init:** `src/core/engine/Engine.ts`
2. **Editor Entry:** `src/editor/app/App.tsx`
3. **Main Config:** `src/config/main.ts`
4. **Utils Index:** `src/utils/index.ts`

### Wichtige Interfaces
1. **IEngine:** `src/core/engine/IEngine.ts`
2. **IComponent:** `src/core/ecs/IComponent.ts`
3. **ISystem:** `src/core/ecs/ISystem.ts`
4. **IPlugin:** `src/plugins/IPlugin.ts`

---

## 📊 Status-Legende

- 🟢 Implementiert & Getestet
- 🟡 In Entwicklung
- 🟠 Geplant (nächster Sprint)
- 🔴 Geplant (Backlog)
- ⚪ Optional / Nice-to-have

---

## 🔄 Letzte Updates

| Datum | Modul | Änderung |
|-------|-------|----------|
| 2026-02-05 | INDEX.md | Initiale Erstellung |

---

**Hinweis:** Dieses Dokument wird kontinuierlich aktualisiert, wenn neue Module hinzugefügt oder bestehende Module geändert werden.

**Version:** 1.0
**Letzte Aktualisierung:** 2026-02-05
