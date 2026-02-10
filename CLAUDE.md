# CLAUDE.md - Session Quick Start

**Version:** 3.8 (Flutter - Template-System Planung)
**Letzte Aktualisierung:** 2026-02-10
**Status:** Phase 7 Komplett (✅ Fertig!) | Phase 8 in Planung (🔮 Template-System)

---

## ⚠️ WICHTIGE KOMMUNIKATIONSREGELN (IMMER BEACHTEN!)

**Diese Regeln haben HÖCHSTE Priorität und müssen IMMER eingehalten werden:**

1. **Verständliche Sprache:** Sprich in normaler, verständlicher Sprache - KEIN Programmierer-Fachchinesisch! Der Nutzer ist kein Programmierer.

2. **Erst informieren, dann handeln:** Informiere den Nutzer IMMER ZUERST, was du machen möchtest. Warte auf seine Bestätigung, bevor du Änderungen durchführst.

3. **Token sparen:**
   - Durchsuche NICHT einfach andere Repositories oder Webseiten
   - Wenn du etwas machen möchtest, das viele Tokens kostet (Repository durchsuchen, Webseiten lesen, etc.), musst du den Nutzer ERST fragen
   - Lies nur die Dateien, die wirklich notwendig sind

4. **Bild-System:**
   - Bilder werden NICHT lokal in der App gespeichert
   - Bilder werden jedes Mal von GitHub (fabrik-library) geladen
   - Bilder werden nur kurzzeitig im Cache gespeichert (während die App läuft)
   - Beim Schließen der App werden die Bilder aus dem Speicher gelöscht

**Diese Regeln gelten für ALLE zukünftigen Sessions!**

---

## 🎯 Projekt auf einen Blick

**GameForge Studio** - Flutter Mobile App für Minecraft Addon-Erstellung
- **Zielgruppe:** 7-jähriges Kind + Vater (kinderfreundlich!)
- **Tech-Stack:** Flutter + Dart, Material 3 Design, SharedPreferences
- **Platform:** Android (APK via GitHub Actions)
- **Status:** Flutter Migration bei 100% - **VOLL FUNKTIONSFÄHIG!** 🎉

---

## 📱 Was funktioniert bereits? (Phase 1-7)

✅ **Login/Logout** - Username + GitHub Token (SharedPreferences)
✅ **Bottom Navigation** - 3 Tabs (Home, Bibliothek, Settings)
✅ **HomeScreen** - Projekte mit Swipe-to-Delete, Item-Count, Instant Refresh
✅ **CreateProjectScreen** - Nur Name eingeben (super simpel!)
✅ **ProjectDetailScreen** - Zeigt alle Items im Projekt, Export-Button 📤
✅ **CategorySelectionScreen** - 6 Kategorien zur Auswahl
✅ **ItemListScreen** - Vanilla Items aus vanilla_stats.json auswählen
✅ **WorkshopScreen** - Item-Editor mit 6 Stats + Effekte
✅ **LibraryScreen** - Item-Galerie mit 39 Items, Filter, Suche
✅ **SettingsScreen** - GitHub, Darstellung, Info, Entwickler-Tools, Gefahrenzone
✅ **Multi-Item Projects** - Ein Projekt kann viele Items enthalten! 🚀
✅ **Debug-System** - Vollständiges Logging für Fehlersuche (Image-Loading) 🔧
✅ **APK Build** - GitHub Actions, Version 1.1.1+3
✅ **Bild-System** - Alle Bilder werden von GitHub (fabrik-library) geladen 🖼️
✅ **Gold-Rüstung** - Goldhelm, Goldbrustpanzer, Goldhose, Goldstiefel hinzugefügt ⭐
✅ **Werkzeuge-Kategorie** - 24 Werkzeuge (Spitzhacken, Schaufeln, Äxte, Hacken) ⛏️
✅ **71 Items gesamt** - 10 Waffen, 24 Rüstung, 24 Werkzeuge, 13 Nahrung 📦
✅ **.mcaddon Export** - Komplette Minecraft Bedrock Addons erstellen! 🎮
✅ **AddonBuilderService** - ZIP-Builder mit Auto-UUIDs, Manifest-Templates 📦
✅ **Downloads-Speicherung** - Addons direkt in /Download/ speichern (kein Share-Dialog) 💾
✅ **Custom Icon Picker** - Im Editor auf Bild tippen → Custom-Icons aus fabrik-library auswählen 🎨
✅ **Editor Bug-Fix** - Textfeld Item-Name funktioniert jetzt korrekt (Cursor + Schreibrichtung) 🔧
✅ **Resource Pack** - Vollständiges Resource Pack mit allen Item-Texturen! 🖼️
✅ **Minecraft 1.21.130+** - Kompatibel mit neuester Bedrock Version (1.21.131) 🎮
✅ **Attribute Modifiers** - Alle Stats funktionieren (Schaden, Rüstung, Mining Speed) ⚡
✅ **Production-Ready** - Alle Minecraft-Parsing-Fehler behoben! Items funktionieren perfekt! ✨

---

## 🆕 Neuer Workflow (Phase 7 - .mcaddon Export!)

**Kompletter Workflow:**
1. **Projekt erstellen** (nur Name) → HomeScreen ✅
2. **Projekt öffnen** → ProjectDetailScreen (Item-Liste)
3. **Item hinzufügen** ➕ → Kategorie wählen
4. **Kategorie wählen** → Item-Liste (vanilla items)
5. **Item auswählen** → WorkshopScreen (Editor)
6. **Stats bearbeiten** → Speichern → Zurück zur Item-Liste
7. **Item bearbeiten** → Tap auf Item → Editor → Update
8. **Addon exportieren** → 📤 Button → **Direkt in Downloads gespeichert!** 💾
9. **In Minecraft importieren** → Datei antippen → Fertig! 🎮

**Neu:** Echte .mcaddon Dateien (Bedrock 1.21.130+) direkt spielbar!

---

## 📁 Flutter-Projekt-Struktur (Updated!)

```
app/lib/
├── main.dart                      ← Entry Point, 3 Tabs Navigation
├── screens/
│   ├── login_screen.dart          ✅ Form Validation, Token Input
│   ├── home_screen.dart           ✅ Projekte, Swipe-Delete, Instant Refresh
│   ├── create_project_screen.dart ✅ Nur Name (super simpel!)
│   ├── project_detail_screen.dart ✅ Item-Liste, Export-Button
│   ├── category_selection_screen.dart ✅ 6 Kategorien Grid
│   ├── item_list_screen.dart      ✅ Vanilla Items Auswahl
│   ├── workshop_screen.dart       ✅ Item-Editor (6 Stats + Effekte)
│   ├── library_screen.dart        ✅ Item-Galerie, Filter, Suche
│   ├── settings_screen.dart       ✅ Alle Settings-Sections + Debug-Button
│   └── debug_screen.dart          ✅ Debug-Logs, Statistiken, Export (NEU!)
├── theme/
│   ├── app_colors.dart            ✅ Purple Theme (#8B5CF6)
│   ├── app_spacing.dart           ✅ Spacing, Touch-Targets
│   └── app_theme.dart             ✅ Material 3 Config
├── models/
│   ├── project.dart               ✅ List<ProjectItem>, addItem, removeItem
│   ├── project_item.dart          ✅ Item im Projekt
│   └── vanilla_item.dart          ✅ Vanilla Items aus JSON
├── services/
│   ├── project_service.dart       ✅ CRUD Operations
│   ├── vanilla_data_service.dart  ✅ JSON Loader
│   ├── minecraft_export_service.dart ✅ Minecraft Bedrock Export (Legacy)
│   ├── addon_builder_service.dart ✅ .mcaddon ZIP Builder
│   └── debug_log_service.dart     ✅ Debug-Logging Singleton
└── widgets/
    ├── item_selection_modal.dart  ✅ Item Grid (alt, nicht mehr verwendet)
    └── item_texture_widget.dart   ✅ Texture Loading + Debug-Logging
```

---

## 🎨 Design-System Quick-Ref

**Farben:**
```dart
AppColors.primary       // #8B5CF6 (Purple)
AppColors.success       // #10B981 (Green)
AppColors.error         // #EF4444 (Red)
AppColors.info          // #3B82F6 (Blue)
AppColors.background    // #1F2937 (Dark Gray)
```

**Touch-Targets:** Minimum 60x60, ideal 80x80 (kinderfreundlich!)

---

## ⏳ Was fehlt noch? (Phase 7 - TODOs)

### **Priorität 1: Polish**
- [ ] App-Icon erstellen (1024x1024 PNG) - siehe ICON_SETUP.md
- [ ] Splash-Screen
- [ ] Besseres Error-Handling

### **Priorität 2: Features**
- [ ] Mehr Effekte (Poison, Regeneration, etc.)
- [ ] Item-Vorschau mit Texture aus fabrik-library
- [ ] Projekt-Duplikation

---

## 🚀 Session-Workflow (Token-Effizienz!)

### **Bei Session-START:**
**Lies NUR diese Datei (CLAUDE.md)** → ~2.500 Tokens ✅

**Bei Bedarf:**
- Details? → `FLUTTER_STATUS.md` (~5.000 Tokens)
- Setup? → `README.md` (~3.000 Tokens)

### **Bei Session-ENDE:**
**Aktualisiere 2 Dateien:**
1. `CLAUDE.md` - Abschnitte "Was funktioniert?" + "Letzte Session"
2. `SESSION_LOG.md` - Kurzer Eintrag (5 Zeilen)

---

## 🔗 Wichtige Links

- **fabrik-library:** https://github.com/ReichiMD/fabrik-library (Item-Daten + Texturen)
- **Werkstatt-Repo:** https://github.com/ReichiMD/Werkstatt-Minecraft-Addon (Backend)
- **Item-Daten lokal:** `app/assets/library/vanilla_stats.json` (71 Items mit echten Stats)

---

## 📝 Letzte Session (für Kontext)

**Session #28 - 2026-02-10 - Template-System Planung**
- 💡 **Template-System Idee entwickelt**
  * User möchte modulares System für beliebige Addon-Typen (nicht nur Items!)
  * Idee: Templates mit Platzhaltern ({{PLATZHALTER}}) in /templates/ Ordner
  * template.json beschreibt Editor-Felder (Name, Typ, Min/Max, Default)
  * App liest Templates automatisch und generiert Editor dynamisch
- 📋 **Template-Regeln festgelegt**
  * Platzhalter-Format: `{{PLATZHALTER_NAME}}` (Doppel-Geschweifte-Klammern)
  * template.json ist PFLICHT
  * JSON-Syntax muss valide sein
  * Ordner-Struktur: behavior_pack/ + resource_pack/
- 🎯 **Nächste Schritte**
  * User erstellt Test-Template (z.B. Tower Defense)
  * Claude baut Template-Loader + Parser + Editor-Generator
  * Geschätzter Aufwand: 2-3 Sessions
- ✅ **CLAUDE.md aktualisiert**
  * Neue Section "Template-System (In Planung)"
  * Alle wichtigen Hinweise dokumentiert

**Status:** 🧪 Planung abgeschlossen - User testet Template-Struktur!

---

**Session #27 - 2026-02-10 - Editor auf Deutsch + minecraft:damage Fix**
- ✅ **Editor komplett auf Deutsch**
  * Alle Labels übersetzt: Schaden, Haltbarkeit, Rüstung, Rüstungshärte, etc.
  * Neue Eigenschaften: Verzauberbarkeit (1-15), Bewegungsgeschwindigkeit (-50% bis +50%)
  * "Erweitert" Button für zukünftige Features (Attack Speed, Mining Speed, etc.)
- ✅ **minecraft:damage Syntax korrigiert**
  * Fehler in Session #26: Object-Syntax `{ "value": X }` wurde verwendet
  * KORREKT: `"minecraft:damage": 10` (direkt eine Zahl!)
  * Bedrock nutzt `minecraft:damage` für Waffen, NICHT `attribute_modifiers`!
  * Quelle: Bedrock Wiki (GitHub) - offizielle Community-Dokumentation
- ✅ **minecraft:enchantable mit slot-Parameter**
  * Fehler: Slot-Parameter fehlte
  * Fix: `{ "slot": "sword", "value": 10 }` für Waffen
  * Mapping: Waffen→sword, Werkzeuge→pickaxe, Rüstung→armor_head/torso/legs/feet
- ✅ **Standard-Quelle festgelegt**
  * Bedrock Wiki (GitHub) als primäre Quelle
  * Microsoft Learn als Backup
  * CLAUDE.md aktualisiert mit Quellenhinweisen
- ✅ **3 Commits:** 41d1b57, 5cfef12, [current]
- Branch: `claude/review-item-properties-daxcV`

**Status:** ✅ Funktioniert - Waffen machen jetzt korrekten Schaden! 🎉

---

**Session #26 - 2026-02-10 - Minecraft 1.21.131 Bugfixes (Production-Ready!)**
- ✅ **minecraft:damage Object-Syntax entfernt**
  * Fehler: "Failed to parse field -> components -> minecraft:damage: invalid value"
  * Root Cause: `minecraft:damage` mit `{ value: X }` Object-Syntax funktioniert nicht
  * Fix: Auf `attribute_modifiers` gewechselt (ABER: War falsch! Siehe Session #27)
  * Betrifft: Waffen und Werkzeuge (alle Items mit Schaden)
- ✅ **menu_category group Namespace-Fix**
  * Fehler: "string must be prefixed with a namespace (eg. namespace:value)"
  * Root Cause: `group: 'itemGroup.name.sword'` fehlt `minecraft:` Namespace
  * Fix: Alle group Werte mit `minecraft:` Prefix versehen
  * Beispiel: `'minecraft:itemGroup.name.sword'` statt `'itemGroup.name.sword'`
- ✅ **Alle Item-Kategorien aktualisiert**
  * Waffen: `minecraft:itemGroup.name.sword`
  * Rüstung: `minecraft:itemGroup.name.chestplate`
  * Werkzeuge: `minecraft:itemGroup.name.pickaxe`
  * Nahrung: `minecraft:itemGroup.name.food`
- ✅ **Dokumentation aktualisiert**
  * item_reference.json mit korrekter Syntax
  * Beide Fehler durch Live-Testing in Minecraft 1.21.131 entdeckt
  * Web-Recherche auf bedrock.dev und Microsoft Learn
- ✅ **2 Commits:** 1005c7d (damage fix), 9d18253 (namespace fix)
- Branch: `claude/fix-minecraft-item-errors-c7Ejd`

**Status:** ✅ 100% Funktionsfähig - Items werden korrekt in Minecraft 1.21.131 importiert! 🎉

---

**Session #25 - 2026-02-10 - Complete Addon Export + Minecraft 1.21.130+ Update**
- ✅ **Resource Pack Implementation**
  * Vollständiges Resource Pack mit Behavior Pack
  * Beide Manifests (behavior + resource) mit Dependencies
  * Texturen werden von GitHub heruntergeladen (Custom oder Vanilla)
  * item_texture.json automatisch generiert
  * terrain_texture.json hinzugefügt (Pflicht-Datei)
  * Korrekte ZIP-Struktur: behavior_pack/ und resource_pack/
- ✅ **Minecraft 1.21.130+ Syntax Update**
  * Icon-Format geändert: `textures: { default: ... }` (statt `texture`)
  * Attribute Modifiers für alle Stats (attack_damage, armor, armor_toughness)
  * minecraft:armor deprecated → jetzt minecraft:wearable + attribute_modifiers
  * menu_category hinzugefügt (Creative Inventory Platzierung)
  * minecraft:hand_equipped für Waffen/Werkzeuge
  * Format Version auf 1.21.130 aktualisiert
- ✅ **Referenz-Dokumentation**
  * item_reference.json erstellt (Beispiele für alle Item-Typen)
  * Nur Dokumentation - wird NICHT von der App geladen
  * CLAUDE.md erweitert mit Minecraft 1.21.130+ Änderungen
- ✅ **Bug-Fixes**
  * textureUrl statt texturePath (VanillaItem Model)
  * manifest_resource.json zu pubspec.yaml Assets hinzugefügt
- ✅ **3 Commits:** a36096c, cd6aa22, a45f886
- Branch: `claude/fix-addon-creation-5j5S4`

**Status:** ✅ Fertig - Komplette .mcaddon Dateien mit Behavior Pack + Resource Pack! 🎉

---

## 🐛 Bekannte Issues

- Kein App-Icon (nur Default Flutter Icon)
- Kein Splash-Screen
- Custom Icons nur für Waffen verfügbar (6 Icons in fabrik-library)

**Alle non-blocking** - App ist voll funktionsfähig! 🎉

---

## 🔮 Template-System (In Planung - Phase 8)

**Vision:** Modulares Template-System für beliebige Addon-Typen (nicht nur Items!)

### **Wie es funktionieren soll:**

📂 **Template-Struktur:**
```
app/assets/templates/
├── items/              ← Aktuelles System (bleibt wie es ist)
└── tower_defense/      ← Neues Template-System
    ├── template.json   ← Beschreibt Editor-Felder
    ├── behavior_pack/
    │   ├── entities/
    │   │   └── tower.json (mit {{PLATZHALTERN}})
    │   └── scripts/
    └── resource_pack/
        └── textures/
```

### **Wichtige Regeln für Templates:**

1. ✅ **Platzhalter-Format:** `{{PLATZHALTER_NAME}}` (Doppel-Geschweifte-Klammern!)
2. ✅ **template.json ist PFLICHT** - Ohne die weiß die App nicht was zu tun ist
3. ✅ **JSON-Syntax muss korrekt sein** - Sonst Parse-Fehler
4. ✅ **Ordner-Struktur:** behavior_pack/ und resource_pack/ (Minecraft Standard)
5. ✅ **Klein starten** - Erst testen, dann erweitern

### **Was kommt als nächstes:**

1. **User erstellt Test-Template** (z.B. Tower Defense Struktur)
2. **Claude baut Template-Loader Service** (liest Templates aus /templates/)
3. **Claude baut Template-Parser** (ersetzt Platzhalter)
4. **Claude erweitert Editor** (dynamisch basierend auf template.json)
5. **Claude passt Builder an** (kopiert Template, ersetzt Platzhalter)

**Status:** 🧪 Experimentell - User testet Template-Struktur, dann Integration in App

**Geschätzter Aufwand:** 2-3 Sessions (aber danach sehr flexibel!)

---

## 📚 STANDARD-QUELLE FÜR BEDROCK KOMPONENTEN

**IMMER diese Quellen nutzen (in dieser Reihenfolge):**

1. **Bedrock Wiki (Web):** https://wiki.bedrock.dev/items/item-components
   - Community-gepflegt, immer aktuell
   - Übersichtliche Web-Interface
   - Zeigt funktionierende Syntax mit Beispielen
2. **Bedrock Wiki (GitHub):** https://github.com/Bedrock-OSS/bedrock-wiki/blob/wiki/docs/items/item-components.md
   - Gleiche Quelle wie oben, anderes Format
   - Gut für Code-Ansicht
3. **Microsoft Learn:** https://learn.microsoft.com/en-us/minecraft/creator/
   - Offizielle Dokumentation von Mojang/Microsoft
   - Manchmal langsamer aktualisiert

**WICHTIG:** Web-Recherchen außerhalb dieser Quellen sind oft irreführend (Java vs. Bedrock verwechselt)!

---

## 📖 Minecraft Bedrock 1.21.130+ - Wichtige Änderungen

**WICHTIG für Addon-Erstellung:** Minecraft Bedrock hat in Version 1.21.130+ die Item-JSON-Syntax geändert!

### **Was hat sich geändert?**

1. **Icon-Format (NEU):**
   ```json
   // ALT (funktioniert NICHT mehr):
   "minecraft:icon": { "texture": "item_name" }

   // NEU (1.21.130+):
   "minecraft:icon": { "textures": { "default": "item_name" } }
   ```

2. **Waffen-Schaden (WICHTIG!):**
   - **Bedrock nutzt `minecraft:damage` Component** (NICHT `attribute_modifiers`!)
   - Syntax: `"minecraft:damage": 10` (direkt eine Zahl, KEIN Objekt!)
   - Actual Damage = `value + 1` (Faust hat Base Damage 1)
   - Beispiel für 16 Damage:
     ```json
     "minecraft:damage": 15  // Ergibt 16 Damage (15 + 1)
     ```
   - ⚠️ **FALSCHE Syntax:** `"minecraft:damage": { "value": 10 }` (Object-Syntax funktioniert NICHT!)

3. **Attribute Modifiers (für Rüstung/Movement Speed):**
   - Komponente `minecraft:attribute_modifiers` existiert NUR für:
     * `minecraft:player.armor` (Rüstungsschutz)
     * `minecraft:player.armor_toughness` (Rüstungshärte)
     * `minecraft:player.movement_speed` (Bewegungsgeschwindigkeit)
   - ⚠️ **NICHT für Waffenschaden!** Dafür `minecraft:damage` nutzen (siehe oben)
   - Beispiel:
     ```json
     "minecraft:attribute_modifiers": {
       "modifiers": [
         {
           "attribute": "minecraft:player.armor",
           "amount": 8,
           "operation": "add_value",
           "slot": "slot.armor.chest"
         }
       ]
     }
     ```

3. **Rüstungs-Komponente (DEPRECATED):**
   - `minecraft:armor` funktioniert NICHT mehr!
   - Stattdessen: `minecraft:wearable` + `attribute_modifiers` mit `minecraft:player.armor`

4. **Menu Category (NEU):**
   - Definiert wo das Item im Kreativ-Inventar erscheint
   - Format: `menu_category: { category: "equipment", group: "minecraft:itemGroup.name.sword" }`
   - ⚠️ **WICHTIG:** `group` braucht `minecraft:` Namespace! Sonst Parse-Fehler!

5. **Format Version:**
   - Alte Version: `1.21.100`
   - Neue Version: `1.21.130` (kompatibel mit 1.21.131)

### **Verfügbare Attribute (für attribute_modifiers):**
- ⚠️ ~~`minecraft:player.attack_damage`~~ - **NICHT NUTZEN!** Bedrock nutzt `minecraft:damage` Component!
- `minecraft:player.armor` - Rüstungsschutz ✅
- `minecraft:player.armor_toughness` - Rüstungs-Härte ✅
- `minecraft:player.movement_speed` - Bewegungsgeschwindigkeit ✅

### **Rüstungs-Slots:**
- Helm: `slot.armor.head`
- Brustpanzer: `slot.armor.chest`
- Hose: `slot.armor.legs`
- Stiefel: `slot.armor.feet`

### **Wichtige Komponenten-Regeln:**

1. **minecraft:damage** - ✅ **RICHTIG VERWENDEN!**
   - ✅ **KORREKTE Syntax:** `"minecraft:damage": 10` (direkt eine Zahl!)
   - ❌ **FALSCHE Syntax:** `"minecraft:damage": { "value": 10 }` (Objekt-Syntax funktioniert NICHT!)
   - Wird für Waffen und Werkzeuge genutzt
   - Actual Damage = value + 1 (Base Hand Damage)

2. **menu_category group** - ⚠️ **Namespace erforderlich!**
   - ❌ FALSCH: `"group": "itemGroup.name.sword"`
   - ✅ RICHTIG: `"group": "minecraft:itemGroup.name.sword"`
   - Fehlt der Namespace: Parse-Fehler "must be prefixed with a namespace"

3. **minecraft:enchantable** - ⚠️ **Slot-Parameter erforderlich!**
   - ❌ FALSCH: `"minecraft:enchantable": { "value": 10 }`
   - ✅ RICHTIG: `"minecraft:enchantable": { "slot": "sword", "value": 10 }`
   - Verfügbare Slots: `sword`, `pickaxe`, `bow`, `armor_head`, `armor_torso`, `armor_legs`, `armor_feet`

### **Referenz-Datei:**
- **`app/assets/templates/item_reference.json`** - Vollständige Beispiele für alle Item-Typen
- Diese Datei wird NICHT von der App geladen - nur Dokumentation!
- Zeigt korrekte Syntax für: Waffen, Rüstung, Werkzeuge, Nahrung

**Implementierung:** Der `addon_builder_service.dart` nutzt die korrekte, getestete Syntax! 🎉

---

## 🎯 Nächster Milestone

**Phase 8: Template-System (Modulares Addon-System)**
- 🔮 **Template-Loader Service** - Liest alle Templates aus /templates/
- 🔧 **Template-Parser Service** - Ersetzt {{PLATZHALTER}} mit Werten
- 🎨 **Dynamischer Editor** - Generiert UI basierend auf template.json
- 📦 **Builder-Erweiterung** - Kopiert Template-Ordner, ersetzt Platzhalter
- 🧪 **Test-Template** - User erstellt Tower Defense Template als Proof-of-Concept

**Geschätzter Aufwand:** 2-3 Sessions

**Danach (Phase 9):**
- End-to-End Testing in Minecraft Bedrock
- Optional: App-Icon und Splash-Screen
- Erste Beta-Version veröffentlichen

---

**🚀 Bereit für die nächste Session!**

**Quick Start:**
1. Lies diese Datei (du tust es gerade!)
2. Check Git: `git status && git log --oneline -3`
3. Sage: "Lass uns mit [Task] starten!"
