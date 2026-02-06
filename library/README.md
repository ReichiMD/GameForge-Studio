# 📚 GameForge Studio - Item Library

Dieses Verzeichnis enthält die Item-Datenbank für GameForge Studio.

## 📁 Struktur

```
library/
├── vanilla_stats.json    # Vanilla Minecraft Item-Stats (Waffen, Rüstung, Nahrung)
└── README.md            # Diese Datei
```

## 📋 vanilla_stats.json

### Inhalt
- **39 Vanilla Items** mit vollständigen Stats
- **Kategorien:** Waffen (9), Rüstung (16), Nahrung (14)
- **Datenquellen:** Minecraft Wiki (für Bildungszwecke)

### Struktur
```json
{
  "meta": {
    "version": "1.0.0",
    "last_update": "2026-02-06",
    "source": "Minecraft Wiki"
  },
  "items": {
    "diamond_sword": {
      "id": "minecraft:diamond_sword",
      "name": "Diamantschwert",
      "category": "weapons",
      "type": "sword",
      "emoji": "⚔️",
      "rarity": "rare",
      "stats": {
        "damage": 7,
        "attack_speed": 1.6,
        "durability": 1561,
        "enchantable": true,
        "stackable": false
      },
      "texture": "assets/vanilla/textures/items/diamond_sword.png"
    }
  },
  "categories": {
    "weapons": { "name": "Waffen", "emoji": "⚔️" },
    "armor": { "name": "Rüstung", "emoji": "🛡️" },
    "food": { "name": "Nahrung", "emoji": "🍖" }
  }
}
```

## 🎯 Verwendung in der App

```tsx
import vanillaStats from '../../../library/vanilla_stats.json';

// Alle Items einer Kategorie
const weapons = Object.entries(vanillaStats.items)
  .filter(([_, item]) => item.category === 'weapons')
  .map(([key, item]) => item);

// Einzelnes Item
const diamondSword = vanillaStats.items.diamond_sword;
console.log(diamondSword.stats.damage); // 7
```

## 📝 Item-Properties

### Pflichtfelder
- `id`: Minecraft Item-ID (z.B. "minecraft:diamond_sword")
- `name`: Deutscher Name
- `name_en`: Englischer Name
- `category`: Kategorie (weapons, armor, food)
- `type`: Untertyp (sword, helmet, food, etc.)
- `emoji`: Emoji für UI
- `rarity`: Seltenheit (common, uncommon, rare, epic)
- `stats`: Objekt mit Item-spezifischen Stats
- `texture`: Pfad zur Textur

### Stats (je nach Item-Typ)

**Waffen:**
- `damage`: Schadenswert
- `attack_speed`: Angriffsgeschwindigkeit
- `durability`: Haltbarkeit
- `enchantable`: Verzauberbar (true/false)
- `stackable`: Stapelbar (true/false)

**Rüstung:**
- `armor`: Rüstungswert
- `armor_toughness`: Rüstungshärte (optional)
- `knockback_resistance`: Rückstoßresistenz (optional)
- `durability`: Haltbarkeit
- `enchantable`: Verzauberbar (true/false)
- `dyeable`: Färbbar (optional)

**Nahrung:**
- `nutrition`: Nahrungswert
- `saturation`: Sättigungswert
- `stackable`: Stapelbar (true/false)
- `stack_size`: Stapelgröße (falls stapelbar)
- `effects`: Array mit Effekten (optional)

## 🗺️ Roadmap

### ✅ Phase 1 (Aktuell)
- [x] Vanilla Stats für Waffen, Rüstung, Nahrung
- [x] Grundlegende Item-Struktur
- [ ] Integration in App (Item Editor)

### 📋 Phase 2 (Geplant)
- [ ] Erweiterte Kategorien (Werkzeuge, Blöcke, Tränke)
- [ ] Custom Items Support
- [ ] Migration zu `fabrik-library` Repository
- [ ] Automatische Sync mit Mojang Updates

### 🚀 Phase 3 (Zukunft)
- [ ] Community-beigetragene Stats
- [ ] Item-Varianten (Verzauberungen)
- [ ] Crafting-Rezepte

## 📜 Lizenz & Copyright

- **Minecraft Assets**: © Mojang AB
- **Stats-Daten**: Gesammelt vom Minecraft Wiki für Bildungszwecke
- **Verwendung**: Nur für Minecraft Add-on Entwicklung

## 🔗 Quellen

- [Minecraft Wiki](https://minecraft.wiki)
- [Mojang Bedrock Samples](https://github.com/Mojang/bedrock-samples)
