# 📋 Template Creation Guide für GameForge Studio

**Version:** 1.0
**Zielgruppe:** KI-Assistenten (Claude, ChatGPT, etc.)
**Minecraft Bedrock Version:** 1.21.130+

---

## ⚠️ WICHTIGE HINWEISE VOR DER ERSTELLUNG

### 1. Minecraft Bedrock Dokumentation

**KRITISCH:** Die meisten Informationen im Internet zu Minecraft sind veraltet oder beziehen sich auf Java Edition!

✅ **EINZIGE vertrauenswürdige Quelle:** https://wiki.bedrock.dev/
- Community-gepflegt und immer aktuell
- Zeigt funktionierende Syntax mit Beispielen
- Speziell für Bedrock Edition

❌ **NICHT verwenden:**
- Zufällige Blog-Posts oder Tutorials (meist veraltet)
- Stack Overflow Antworten (oft Java statt Bedrock)
- YouTube Tutorials (Syntax ändert sich häufig)
- Minecraft Wiki (oft Java-fokussiert)

### 2. Minecraft Bedrock Version

**Ziel-Version:** 1.21.130+
**Format Version:** Nutze `"format_version": 2` in Manifests
**Min Engine Version:** `"min_engine_version": [1, 21, 131]`

---

## 📁 Template-Struktur

Jedes Template MUSS folgende Struktur haben:

```
app/assets/templates/
└── dein_template_name/
    ├── template.json                    ← PFLICHT! Beschreibt Editor-Felder
    ├── behavior_pack/
    │   ├── manifest.json               ← PFLICHT! Mit Platzhaltern
    │   ├── entities/                   ← Optional: Entities (Mobs, NPCs)
    │   ├── items/                      ← Optional: Custom Items
    │   ├── blocks/                     ← Optional: Custom Blocks
    │   ├── scripts/                    ← Optional: GameTest Scripts
    │   ├── loot_tables/                ← Optional: Loot Tables
    │   ├── recipes/                    ← Optional: Crafting Recipes
    │   └── animation_controllers/      ← Optional: Animation Controller
    └── resource_pack/
        ├── manifest.json               ← PFLICHT! Mit Platzhaltern
        ├── entity/                     ← Optional: Entity Client-Definitionen
        ├── textures/                   ← Optional: Texturen
        ├── models/                     ← Optional: 3D-Modelle
        ├── sounds/                     ← Optional: Sounds
        └── texts/                      ← Optional: Übersetzungen (en_US.lang)
```

---

## 📝 template.json - PFLICHT!

**Datei:** `dein_template_name/template.json`

Diese Datei beschreibt die Felder im Editor und wird von der App gelesen!

### Beispiel:

```json
{
  "name": "Dein Template Name",
  "description": "Kurze Beschreibung was das Template macht",
  "category": "gameplay",
  "editor_fields": [
    {
      "placeholder": "{{DEIN_PLATZHALTER}}",
      "label": "Name für den User (z.B. 'Basis-Schaden')",
      "type": "number",
      "default": 10,
      "min": 1,
      "max": 100
    },
    {
      "placeholder": "{{ANDERER_PLATZHALTER}}",
      "label": "Text-Feld Beispiel",
      "type": "text",
      "default": "Standard-Wert"
    }
  ]
}
```

### Verfügbare Feld-Typen:

- **"number"** - Zahlen-Feld mit Plus/Minus Buttons (benötigt min/max)
- **"text"** - Einzeiliges Text-Feld

### Kategorien:

- `"gameplay"` - Gameplay-Mechaniken (Tower Defense, Survival, etc.)
- `"building"` - Bau-bezogene Templates
- `"adventure"` - Abenteuer/Quest Templates
- `"custom"` - Andere

---

## 🔑 Platzhalter-System

### Automatische System-Platzhalter (IMMER verfügbar):

Diese werden von der App automatisch ersetzt - NICHT in template.json definieren!

| Platzhalter | Beschreibung | Beispiel |
|-------------|--------------|----------|
| `{{PROJECT_NAME}}` | Projekt-Name (sanitized, lowercase, `_` statt Leerzeichen) | `mein_projekt` |
| `{{DESCRIPTION}}` | Projekt-Beschreibung (vom User eingegeben) | `Ein cooler Wolf` |
| `{{HEADER_UUID}}` | Behavior Pack Header UUID (automatisch generiert) | `4f3b2a1d-7e6f-...` |
| `{{MODULE_UUID}}` | Behavior Pack Module UUID (automatisch generiert) | `5e4d3c2b-1a0f-...` |
| `{{RESOURCE_PACK_UUID}}` | Resource Pack Header UUID (automatisch generiert) | `6f5e4d3c-2b1a-...` |
| `{{RESOURCE_MODULE_UUID}}` | Resource Pack Module UUID (automatisch generiert) | `7a8b9c0d-1e2f-...` |

### Custom Platzhalter (in template.json definieren):

Du kannst beliebige Custom-Platzhalter erstellen:

```json
{
  "placeholder": "{{WOLF_BASE_DAMAGE}}",
  "label": "Basis-Schaden",
  "type": "number",
  "default": 4,
  "min": 1,
  "max": 20
}
```

**Naming Convention:**
- Nur Großbuchstaben: `{{MEIN_PLATZHALTER}}`
- Unterstriche statt Leerzeichen: `{{WOLF_BASE_DAMAGE}}`
- Beschreibend und eindeutig: ✅ `{{TURRET_DAMAGE}}` ❌ `{{DAMAGE}}`

---

## 📦 Manifest-Dateien

### Behavior Pack Manifest

**Datei:** `behavior_pack/manifest.json`

```json
{
  "format_version": 2,
  "header": {
    "description": "{{DESCRIPTION}}",
    "name": "{{PROJECT_NAME}} Behavior",
    "uuid": "{{HEADER_UUID}}",
    "version": [1, 0, 0],
    "min_engine_version": [1, 21, 131]
  },
  "modules": [
    {
      "description": "Behavior Module",
      "type": "data",
      "uuid": "{{MODULE_UUID}}",
      "version": [1, 0, 0]
    }
  ],
  "dependencies": [
    {
      "uuid": "{{RESOURCE_PACK_UUID}}",
      "version": [1, 0, 0]
    }
  ]
}
```

**WICHTIG:**
- ✅ `"uuid": "{{HEADER_UUID}}"` - Platzhalter verwenden!
- ❌ `"uuid": "4f3b2a1d-7e6f-4c5b-8a9d-0e1f2a3b4c5d"` - KEINE festen UUIDs!
- Die `dependencies` Section verweist auf das Resource Pack

### Resource Pack Manifest

**Datei:** `resource_pack/manifest.json`

```json
{
  "format_version": 2,
  "header": {
    "description": "{{DESCRIPTION}}",
    "name": "{{PROJECT_NAME}} Resources",
    "uuid": "{{RESOURCE_PACK_UUID}}",
    "version": [1, 0, 0],
    "min_engine_version": [1, 21, 131]
  },
  "modules": [
    {
      "description": "Resource Module",
      "type": "resources",
      "uuid": "{{RESOURCE_MODULE_UUID}}",
      "version": [1, 0, 0]
    }
  ]
}
```

**WICHTIG:**
- Resource Pack hat KEINE dependencies Section
- Header UUID muss `{{RESOURCE_PACK_UUID}}` sein (damit Behavior Pack es referenzieren kann)

---

## 🎮 Entity-Dateien (Behavior Pack)

**Pfad:** `behavior_pack/entities/deine_entity.json`

### Beispiel-Struktur:

```json
{
  "format_version": "1.21.130",
  "minecraft:entity": {
    "description": {
      "identifier": "{{PROJECT_NAME}}:deine_entity",
      "is_spawnable": true,
      "is_summonable": true,
      "is_experimental": false
    },
    "component_groups": {
      "meine_gruppe": {
        "minecraft:scale": {
          "value": {{DEIN_SCALE_PLATZHALTER}}
        }
      }
    },
    "components": {
      "minecraft:health": {
        "value": {{HEALTH_PLATZHALTER}},
        "max": {{HEALTH_PLATZHALTER}}
      },
      "minecraft:attack": {
        "damage": {{DAMAGE_PLATZHALTER}}
      }
    },
    "events": {
      "mein_event": {
        "add": {
          "component_groups": ["meine_gruppe"]
        }
      }
    }
  }
}
```

**Wichtige Entity Components (1.21.130+):**

Siehe: https://wiki.bedrock.dev/entities/entity-intro-bp.html

Häufig genutzt:
- `minecraft:health` - Lebenspunkte
- `minecraft:attack` - Nahkampfschaden
- `minecraft:scale` - Größe (0.5 = halb, 2.0 = doppelt)
- `minecraft:loot` - Loot Table
- `minecraft:behavior.* ` - Behavior Components (z.B. `minecraft:behavior.melee_attack`)

---

## 🎨 Client Entity (Resource Pack)

**Pfad:** `resource_pack/entity/deine_entity.entity.json`

### Beispiel (Vanilla-Texturen verwenden):

```json
{
  "format_version": "1.21.130",
  "minecraft:client_entity": {
    "description": {
      "identifier": "{{PROJECT_NAME}}:deine_entity",
      "materials": {
        "default": "wolf"
      },
      "textures": {
        "default": "textures/entity/wolf/wolf"
      },
      "geometry": {
        "default": "geometry.wolf"
      },
      "animations": {
        "walk": "animation.wolf.walk"
      },
      "scripts": {
        "animate": ["walk"]
      },
      "render_controllers": ["controller.render.wolf"]
    }
  }
}
```

**Tipp:** Vanilla-Assets nutzen spart Arbeit! Siehe: https://wiki.bedrock.dev/visuals/entity-visuals-intro.html

---

## 🔍 Wichtige Bedrock-Syntax Änderungen (1.21.130+)

### ⚠️ VERALTETE Syntax (NICHT nutzen):

```json
// ❌ ALT - Funktioniert NICHT mehr:
"minecraft:icon": {
  "texture": "item_name"
}

// ❌ ALT - Deprecated:
"minecraft:armor": {
  "protection": 8
}
```

### ✅ NEUE Syntax (1.21.130+):

```json
// ✅ NEU - Icons:
"minecraft:icon": {
  "textures": {
    "default": "item_name"
  }
}

// ✅ NEU - Armor:
"minecraft:wearable": {
  "slot": "slot.armor.chest"
}
// + attribute_modifiers für Rüstungswerte
```

**Quelle:** https://wiki.bedrock.dev/items/item-components.html

---

## 📋 pubspec.yaml - Asset Registration

**WICHTIG:** Nachdem du das Template erstellt hast, musst du dem User sagen, dass er alle Template-Dateien in `app/pubspec.yaml` registrieren muss!

### Beispiel:

```yaml
assets:
  # Dein Template
  - assets/templates/dein_template_name/template.json
  - assets/templates/dein_template_name/behavior_pack/manifest.json
  - assets/templates/dein_template_name/behavior_pack/entities/deine_entity.json
  - assets/templates/dein_template_name/resource_pack/manifest.json
  - assets/templates/dein_template_name/resource_pack/entity/deine_entity.entity.json
```

**Achtung:** Jede einzelne Datei muss explizit aufgelistet werden! Flutter kann nicht automatisch ganze Ordner einbinden.

---

## 🧪 Template-Service Integration

Der User muss auch `app/lib/services/template_loader_service.dart` und `app/lib/services/template_builder_service.dart` aktualisieren!

### 1. template_loader_service.dart

```dart
static const List<String> _availableTemplates = [
  'leveling_wolf',
  'dein_template_name',  // Hinzufügen!
];
```

### 2. template_builder_service.dart

```dart
List<String> _getTemplateFilePaths(String templateId) {
  switch (templateId) {
    case 'dein_template_name':
      return [
        // Liste ALLER Dateien (gleich wie in pubspec.yaml)
        'behavior_pack/manifest.json',
        'behavior_pack/entities/deine_entity.json',
        'resource_pack/manifest.json',
        'resource_pack/entity/deine_entity.entity.json',
      ];
    // ... andere templates
  }
}
```

---

## ✅ Checkliste für Template-Erstellung

Bevor du das Template als "fertig" markierst, prüfe:

- [ ] `template.json` existiert mit allen Feldern
- [ ] Behavior Pack `manifest.json` mit Platzhaltern (UUIDs!)
- [ ] Resource Pack `manifest.json` mit Platzhaltern (UUIDs!)
- [ ] Alle JSON-Dateien sind **valide** (keine Syntax-Fehler!)
- [ ] Identifier nutzen `{{PROJECT_NAME}}:entity_name` Format
- [ ] Platzhalter sind konsistent benannt (Großbuchstaben, Unterstriche)
- [ ] Nur Syntax von wiki.bedrock.dev verwendet (Version 1.21.130+)
- [ ] Alle Custom-Platzhalter sind in `template.json` definiert
- [ ] User wurde informiert über:
  - [ ] `pubspec.yaml` Assets hinzufügen
  - [ ] `template_loader_service.dart` aktualisieren
  - [ ] `template_builder_service.dart` aktualisieren

---

## 💡 Beispiel-Prompt für KI-Assistenten

**User möchte ein "Exploding Creeper" Template:**

```
Erstelle ein Minecraft Bedrock Template (Version 1.21.130+) für GameForge Studio:

Template Name: "Exploding Creeper"
Beschreibung: Ein Creeper mit konfigurierbarer Explosionskraft und Timer

Editor-Felder:
- Explosions-Radius (1-10, Standard: 3)
- Explosions-Schaden (1-50, Standard: 20)
- Fuse-Zeit in Sekunden (1-10, Standard: 3)

WICHTIG:
- Nutze NUR Informationen von https://wiki.bedrock.dev/
- Format Version: 1.21.130+
- Alle UUIDs müssen Platzhalter sein ({{HEADER_UUID}}, etc.)
- Erstelle template.json mit den 3 Feldern
- Behavior Pack mit Creeper-Entity
- Resource Pack mit Vanilla-Creeper Texturen

Dokumentation: Siehe TEMPLATE_CREATION_GUIDE.md
```

---

## 📚 Nützliche Links

- **Bedrock Wiki:** https://wiki.bedrock.dev/
- **Entity Components:** https://wiki.bedrock.dev/entities/entity-intro-bp.html
- **Item Components:** https://wiki.bedrock.dev/items/item-components.html
- **Blocks:** https://wiki.bedrock.dev/blocks/blocks-intro.html
- **MoLang:** https://wiki.bedrock.dev/concepts/molang.html

---

**Viel Erfolg beim Template-Erstellen! 🚀**
