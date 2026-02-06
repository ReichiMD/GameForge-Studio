# 🗺️ GameForge Studio - Roadmap

**Projekt:** Minecraft Add-on Creator für Kinder (7 Jahre+)
**Status:** MVP Phase
**Letzte Aktualisierung:** 2026-02-06

---

## ✅ Sprint 1 - Grundstruktur (Abgeschlossen)

- [x] React Native + Expo Setup
- [x] Bottom Tab Navigation (Home, Library, Workshop, Settings)
- [x] Theme System (Dark Mode optimiert)
- [x] 6 Haupt-Screens implementiert
- [x] AsyncStorage Integration
- [x] Login-Screen mit GitHub Token
- [x] Projekt-Kontext (CRUD)

---

## ✅ Sprint 2 - Bug Fixes (Abgeschlossen - 2026-02-06)

- [x] "Projekt erstellen" Button entfernt (überflüssig)
- [x] Scroll-Position im WorkshopScreen zurücksetzen
- [x] Speichern-Button im WorkshopScreen funktionalisiert
- [x] 2-stufige Kategorie/Item-Auswahl im ProjectDetailScreen
- [x] Lösch-Buttons für Projekte und Items hinzugefügt
- [x] `deleteProject` und `removeItemFromProject` in ProjectContext

---

## 🚧 Sprint 3 - Item Library & Stats (In Planung)

### Phase 3.1: Library Integration
- [ ] `vanilla_stats.json` in App einbinden
- [ ] Item-Datenmodell erweitern (Stats, Texturen)
- [ ] LibraryScreen mit echten Daten befüllen
- [ ] Item-Filter nach Kategorie
- [ ] Item-Suche implementieren

### Phase 3.2: Item Editor - Echte Stats
- [ ] **Priorität A**: WorkshopScreen mit echten Stats
  - [ ] Schaden-Slider (dynamisch je nach Item-Typ)
  - [ ] Geschwindigkeit-Slider
  - [ ] Haltbarkeit-Slider
  - [ ] Rarity-Auswahl (Common, Uncommon, Rare, Epic)
  - [ ] "Erweitert"-Button für zusätzliche Optionen
- [ ] Stats aus `vanilla_stats.json` laden
- [ ] Standard-Werte vs. Custom-Werte

### Phase 3.3: Erweiterte Editor-Features
- [ ] **Erweitert-Modus** im Item Editor:
  - [ ] Item-ID Eingabe
  - [ ] Kritischer Treffer %
  - [ ] Knockback
  - [ ] Reichweite
  - [ ] Verzauberungen-Auswahl
  - [ ] Max Stack Size
  - [ ] Reparierbar (Ja/Nein)

---

## 📦 Sprint 4 - Custom Items (Geplant)

### Phase 4.1: Custom Item Erstellung
- [ ] Item bearbeiten → Automatisch als Custom markieren
- [ ] Custom Items in `assets/custom/items/` speichern
- [ ] Lokaler Cache + Repository-Sync
- [ ] Custom Items in separatem Tab anzeigen

### Phase 4.2: Bild-Upload
- [ ] Foto aus Galerie auswählen
- [ ] Bild-Editor für kleine Texturen (16x16, 32x32)
  - [ ] Pixel-Grid
  - [ ] Farbpalette
  - [ ] Einfache Werkzeuge (Stift, Radierer, Füllen)
- [ ] Custom Texturen in `assets/custom/textures/` speichern
- [ ] Vorschau im Item Editor

### Phase 4.3: Item-Management
- [ ] Custom Items umbenennen
- [ ] Custom Items duplizieren
- [ ] Custom Items exportieren (JSON + PNG)
- [ ] Custom Items importieren

---

## 🔧 Sprint 5 - GitHub Integration (Geplant)

### Phase 5.1: GitHubService
- [ ] API Client implementieren
- [ ] Token-Verwaltung (sicher!)
- [ ] Repository-Zugriff testen

### Phase 5.2: Projekt-Export
- [ ] `project.json` generieren (Minecraft Addon Format)
- [ ] `manifest.json` erstellen
- [ ] Behavior Pack Struktur aufbauen
- [ ] Resource Pack Struktur aufbauen

### Phase 5.3: GitHub Push
- [ ] Projekt zu GitHub pushen
- [ ] Commit-Historie anzeigen
- [ ] Pull/Sync von GitHub

---

## 🏗️ Sprint 6 - Advanced Features (Zukunft)

### Phase 6.1: Erweiterte Kategorien
- [ ] Werkzeuge (Spitzhacke, Schaufel, Axt, Hacke)
- [ ] Blöcke (Bau, Deko, Redstone)
- [ ] Tränke (Effekte, Dauer)
- [ ] Mobs (Entities - fortgeschritten)

### Phase 6.2: Crafting-Rezepte
- [ ] Rezept-Editor
- [ ] 3x3 Grid
- [ ] Shapeless Recipes
- [ ] Furnace/Brewing Rezepte

### Phase 6.3: Testing & Preview
- [ ] In-App Preview (3D Item-Vorschau?)
- [ ] Addon-Validator
- [ ] Export zu Minecraft (direkter Import?)

---

## 🌐 Sprint 7 - Library Migration (Wichtig!)

### Phase 7.1: Repository-Struktur
- [ ] **Library-Daten** von `GameForge-Studio` nach `fabrik-library` verschieben
  - [ ] `vanilla_stats.json`
  - [ ] `library_index.json`
  - [ ] `assets/vanilla/`
  - [ ] `assets/custom/` (Template-Struktur)
- [ ] `sync_assets.yml` Workflow erweitern
- [ ] `indexer.py` für Stats-Integration

### Phase 7.2: App-Integration
- [ ] App holt Library-Daten von `fabrik-library`
- [ ] Lokaler Cache-Mechanismus
- [ ] Background-Sync (einmal pro Tag?)

### Phase 7.3: Custom Items Cloud-Sync
- [ ] Custom Items in `fabrik-library` pushen
- [ ] Geräte-übergreifender Zugriff
- [ ] Versionierung (Git)

---

## 📱 Sprint 8 - UX/UI Verbesserungen (Laufend)

### Kinder-freundlich (7 Jahre+)
- [ ] Große Touch-Targets (min. 60x60px)
- [ ] Emoji-heavy UI
- [ ] Animationen (Fun Factor!)
- [ ] Tutorials/Onboarding
- [ ] Achievements (Gamification)

### Performance
- [ ] Lazy Loading für Item-Listen
- [ ] Image Caching optimieren
- [ ] Scroll-Performance verbessern

### Settings-Screen
- [ ] Copyright-Hinweis: "Minecraft Assets © Mojang AB"
- [ ] App-Version anzeigen
- [ ] Logout-Button
- [ ] Theme-Toggle (Light/Dark)

---

## 🐛 Known Issues (Backlog)

- [ ] TypeScript-Fehler in `HomeScreen.tsx` (demoProjects Array - kosmetisch)
- [ ] Logout-Button fehlt im UI (onLogout wird übergeben, aber nicht genutzt)
- [ ] Services (alle) noch nicht implementiert

---

## 💡 Ideen für später

### Community-Features
- [ ] Item-Sharing (QR-Code?)
- [ ] Community-Library (öffentliche Items)
- [ ] Bewertungen/Likes

### Erweiterte Tools
- [ ] Animations-Editor (einfache Animationen)
- [ ] Sound-Editor (Item-Sounds)
- [ ] Model-Editor (vereinfacht)

### Plattformen
- [ ] Web-Version (Progressive Web App?)
- [ ] Desktop-Version (Electron?)

---

## 📊 Metriken

**Aktueller Stand:**
- ✅ 6 Screens implementiert
- ✅ 39 Vanilla Items mit Stats
- ✅ Projekt-CRUD funktional
- ✅ Custom Items Infrastruktur (geplant)

**Nächster Meilenstein:**
- 🎯 Item Editor mit echten Stats (Sprint 3)
- 🎯 Custom Items erstellen (Sprint 4)

---

**Versionsnummer:** 0.3.0-alpha
**Ziel MVP:** 0.5.0 (Ende Sprint 4)
**Ziel Beta:** 1.0.0 (Ende Sprint 6)
