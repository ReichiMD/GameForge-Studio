# CLAUDE.md - Quick Start für Claude Code

## 🎯 Projekt auf einen Blick
**GameForge Studio** - React Native Mobile App für Minecraft Addon-Erstellung
**Zielgruppe:** 7-jähriges Kind + Vater
**Tech-Stack:** React Native + Expo, React Navigation, AsyncStorage
**Status:** In Entwicklung (MVP Phase)

---

## ⚡ Token-Optimierung: Welche Dateien lesen?

### 🚨 **GRUNDREGEL: Frag zuerst, lies dann!**
**Bevor du Dateien liest, frag:**
- "Welcher Screen/Service ist betroffen?"
- "Welche spezifische Funktion soll geändert werden?"
- "Soll ich nur diesen Screen lesen oder die ganze Architektur verstehen?"

---

## 📁 Dokumentations-Hierarchie (lies nur was du brauchst!)

| Datei | Zeilen | Wann lesen? | Token-Kosten |
|-------|--------|-------------|--------------|
| **CLAUDE.md** ← DU BIST HIER | 80 | **IMMER zuerst** | ~1.000 |
| **INDEX.md** | 297 | Nur bei: "Wo finde ich X?" oder "Vollständige Architektur?" | ~6.000 |
| **PROJECT_INFO.md** | 388 | Nur bei: "Wie funktioniert die Architektur?" oder "Design-Prinzipien?" | ~8.000 |
| **SESSION_LOG.md** | variabel | Nur bei: "Was wurde zuletzt gemacht?" | ~5.000 |
| **README.md** | variabel | Nur bei: "Setup-Anleitung?" oder "Projekt-Übersicht?" | ~3.000 |

---

## 🎯 Task-basiertes Lesen (Token-Effizienz!)

### ✅ UI-Änderung an einem Screen
**Beispiel:** "Ändere Button-Farbe im HomeScreen"

**Lies:**
- ✅ Nur den betroffenen Screen (z.B. `app/src/screens/HomeScreen.tsx`)
- ✅ Evtl. Theme-Dateien (`app/src/theme/colors.ts`)

**Lies NICHT:**
- ❌ INDEX.md
- ❌ PROJECT_INFO.md
- ❌ Andere Screens

**Token-Kosten:** ~3.000-5.000 (statt ~25.000)

---

### ✅ Neue Navigation / Neuer Screen
**Beispiel:** "Füge einen neuen Screen hinzu"

**Lies:**
- ✅ `app/src/navigation/AppNavigator.tsx` (105 Zeilen)
- ✅ `app/src/screens/index.ts` (für Export)
- ✅ Ähnlichen Screen als Vorlage (optional)

**Lies NICHT:**
- ❌ INDEX.md (nur wenn unklar, wo Screens liegen)
- ❌ PROJECT_INFO.md
- ❌ Alle anderen Screens

**Token-Kosten:** ~2.000-5.000 (statt ~25.000)

---

### ✅ Service-Implementierung
**Beispiel:** "Implementiere GitHubService"

**Lies:**
- ✅ INDEX.md Zeile 82-98 (nur Services-Section)
- ✅ PROJECT_INFO.md Zeile 189-204 (nur PWA-Portierung-Section)

**Lies NICHT:**
- ❌ Vollständige INDEX.md
- ❌ Screens (außer wenn Service in Screen genutzt wird)

**Token-Kosten:** ~3.000-5.000 (statt ~25.000)

---

### ✅ Bug-Fix
**Beispiel:** "Login-Button reagiert nicht"

**Lies:**
- ✅ Nur die betroffene Datei (z.B. `LoginScreen.tsx`)
- ✅ Evtl. zugehörige Service (z.B. `AuthService.js`)

**Lies NICHT:**
- ❌ Jegliche Dokumentation
- ❌ Andere Screens
- ❌ Navigation (außer wenn Bug navigation-bezogen ist)

**Token-Kosten:** ~2.000-4.000 (statt ~25.000)

---

### ✅ Architektur-Frage / "Wie funktioniert X?"
**Beispiel:** "Wie funktioniert die GitHub-Integration?"

**Lies:**
- ✅ PROJECT_INFO.md Zeile 25-51 (Architektur-Diagramm)
- ✅ PROJECT_INFO.md Zeile 246-279 (Workflow)
- ✅ Evtl. relevante Service-Datei

**Lies NICHT:**
- ❌ Vollständige PROJECT_INFO.md
- ❌ INDEX.md
- ❌ Screens

**Token-Kosten:** ~3.000-6.000 (statt ~25.000)

---

## 📦 Projekt-Struktur (Quick Reference)

### Screens (5 Haupt-Screens)
```
app/src/screens/
├── HomeScreen.tsx          (255 Zeilen) - Projektliste
├── LibraryScreen.tsx       (285 Zeilen) - Item-Galerie
├── WorkshopScreen.tsx      (373 Zeilen) - Item-Editor
├── SettingsScreen.tsx      (249 Zeilen) - Einstellungen
├── LoginScreen.tsx         (239 Zeilen) - Auth
└── CreateProjectScreen.tsx (240 Zeilen) - Kategorie-Auswahl
```

### Navigation
```
app/src/navigation/
└── AppNavigator.tsx        (105 Zeilen) - Bottom Tabs + Stacks
```

### Theme
```
app/src/theme/
├── colors.ts               (62 Zeilen)
├── spacing.ts              (57 Zeilen)
└── index.ts                (2 Zeilen)
```

### Services (noch nicht implementiert)
```
app/src/services/
└── [Alle Services sind geplant, aber noch nicht implementiert]
```

---

## 🎨 Design-System Quick-Ref

**Farben:**
- Primary: Purple `#8B5CF6`
- Success: Green `#10B981`
- Accent: Blue `#3B82F6`

**Touch-Targets:**
- Minimum: 60x60px
- Ideal: 80x80px

**Import:**
```tsx
import { colors, spacing, sizing, typography } from '../theme';
```

---

## 🚨 HÄUFIGE TOKEN-FALLEN (Vermeide diese!)

### ❌ FALSCH:
```
User: "Ändere Button-Farbe im HomeScreen"
Claude: *liest automatisch INDEX.md + PROJECT_INFO.md + HomeScreen + colors.ts*
→ 25.000 Token
```

### ✅ RICHTIG:
```
User: "Ändere Button-Farbe im HomeScreen"
Claude: "Welcher Button genau? (Ich lese dann nur HomeScreen.tsx)"
User: "Der 'Neues Projekt' Button"
Claude: *liest nur HomeScreen.tsx + colors.ts*
→ 3.000 Token
```

**Token-Ersparnis: 22.000 (88%)** 🎉

---

## 📊 Token-Budget Management

**Session-Budget:** 200.000 Token

**Typische Kosten:**
- Vollständige Doku lesen: ~25.000 Token (12,5% Budget)
- Screen lesen: ~3.000-6.000 Token (2-3%)
- Service implementieren: ~5.000-10.000 Token (3-5%)
- Git-Operationen: ~3.000 Token (1,5%)

**Ziel pro Task:** Max. 30.000 Token (15% Budget)
→ Ermöglicht ~6-7 Tasks pro Session

---

## 🔍 Schnellzugriff: Wichtigste Dateien

### Entry Points
- **App.tsx:** `app/App.tsx` (64 Zeilen) - Haupt-Entry mit Auth-Logic

### Navigation
- **AppNavigator:** `app/src/navigation/AppNavigator.tsx` (105 Zeilen)

### Screens (nach Häufigkeit)
1. **HomeScreen** (am häufigsten geändert)
2. **CreateProjectScreen** (neu, evtl. Erweiterungen)
3. **WorkshopScreen** (komplex, 373 Zeilen)
4. **LibraryScreen** (285 Zeilen)
5. **SettingsScreen** (249 Zeilen)
6. **LoginScreen** (selten geändert)

---

## 💾 State Management

**Aktuell:** React Context + AsyncStorage
**Später:** Evtl. Zustand (wenn State zu komplex wird)

**AsyncStorage Keys:**
- `@gameforge_auth` - Login-Daten (username, githubToken)
- `@gameforge_projects` - Projekt-Liste (geplant)

---

## 🔗 Externe Repos (für Kontext)

1. **Werkstatt-Minecraft-Addon** (Backend)
   https://github.com/ReichiMD/Werkstatt-Minecraft-Addon

2. **fabrik-library** (Item-Daten)
   https://github.com/ReichiMD/fabrik-library

---

## 🎓 Lessons Learned (aus Sessions)

### Session #5 (Token-Optimierung):
- **Problem:** INDEX.md + PROJECT_INFO.md automatisch lesen = 18.000 Token verschwendet
- **Lösung:** CLAUDE.md + Frag-basierter Workflow
- **Ersparnis:** 40-50% Token pro Task

### Session #4 (Login-Screen):
- Auth-System mit AsyncStorage implementiert
- Status Bar Fix mit SafeAreaProvider

---

## 📝 Commit-Nachrichten Style

**Format:**
```
<Verb> <Was> (<Details>)

- Detaillierte Änderung 1
- Detaillierte Änderung 2

Implements/Fixes: <Was wurde erreicht>

https://claude.ai/code/session_<ID>
```

**Beispiel:**
```
Add CreateProjectScreen with category selection

- Create new screen with category grid
- Add Stack Navigator to Home tab
- Update HomeScreen with navigation

Implements navigation flow: HomeScreen → CreateProjectScreen

https://claude.ai/code/session_01TPc9eFar6BdzS7EoPPkomd
```

---

## ⚠️ Known Issues

- **HomeScreen TS-Fehler:** `demoProjects` Array hat keine Type-Annotation (kosmetisch)
- **Logout-Button fehlt:** `onLogout` wird übergeben, aber nicht in UI eingebaut
- **Services noch nicht implementiert:** Alle Services sind geplant, aber noch nicht da

---

## 🚀 Nächste Schritte (Roadmap)

**Sprint 2 (aktuell):**
- [ ] LibraryService (fabrik-library Integration)
- [ ] WorkshopScreen (Item-Editor Logic)
- [ ] Projekt-Speicherung (AsyncStorage)

**Sprint 3:**
- [ ] GitHubService (API Client)
- [ ] GitHub Token Verwaltung
- [ ] project.json Export

---

**Version:** 1.0
**Erstellt:** 2026-02-06 (Session #5 - Token-Optimierung)
**Letzte Aktualisierung:** 2026-02-06
