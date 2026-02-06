# 🚀 Nächste Session - Item Editor mit echten Stats

**Datum:** 2026-02-06
**Branch:** `claude/fix-project-item-bugs-rcO0e`
**Status:** Vorbereitung für Sprint 3 abgeschlossen

---

## ✅ Was in dieser Session gemacht wurde

### 1. **Bug Fixes (5 Bugs behoben)**
- [x] "Projekt erstellen" Button entfernt (CreateProjectScreen)
- [x] Scroll-Position im WorkshopScreen zurücksetzen
- [x] Speichern-Button im WorkshopScreen funktionalisiert
- [x] 2-stufige Kategorie/Item-Auswahl im ProjectDetailScreen
- [x] Lösch-Buttons für Projekte und Items hinzugefügt

### 2. **Vanilla Stats Library erstellt**
- [x] `library/vanilla_stats.json` mit 39 Minecraft Items:
  - 9 Waffen (Schwerter, Bogen, Armbrust, Dreizack)
  - 16 Rüstungsteile (Leder, Eisen, Diamant, Netherit - komplett)
  - 14 Nahrungsmittel (Äpfel, Fleisch, Fisch, Brot, etc.)
- [x] Stats: Schaden, Geschwindigkeit, Haltbarkeit, Armor, Nutrition, etc.
- [x] Deutsche + Englische Namen
- [x] Emojis für UI
- [x] Rarity (Common, Uncommon, Rare, Epic)
- [x] Texture-Pfade (relativ zu fabrik-library)

### 3. **Dokumentation**
- [x] `library/README.md` - Erklärt die Struktur und Nutzung
- [x] `ROADMAP.md` - Komplette Projekt-Planung
- [x] Copyright-Hinweise (Minecraft Assets © Mojang AB)

### 4. **Discovery: fabrik-library Assets**
- [x] Bestätigt: **Über 1.000+ Item-Texturen** vorhanden in fabrik-library
- [x] Pfad: `assets/vanilla/textures/items/`
- [x] Können via URL geladen werden: `https://raw.githubusercontent.com/ReichiMD/fabrik-library/main/assets/vanilla/textures/items/{filename}.png`

---

## 🎯 Nächste Session: Item Editor mit echten Stats (Priorität A)

### **Ziel:** WorkshopScreen mit vanilla_stats.json verbinden

### **Was gebaut werden soll:**

#### **1. Item-Daten laden**
```tsx
// Neue Datei: app/src/data/vanillaItems.ts
import vanillaStats from '../../../library/vanilla_stats.json';

export const getItemById = (id: string) => {
  return vanillaStats.items[id];
};

export const getItemsByCategory = (category: string) => {
  return Object.values(vanillaStats.items)
    .filter(item => item.category === category);
};
```

#### **2. WorkshopScreen erweitern**

**Aktueller Zustand:**
- Statische Werte (Schaden: 35, Geschwindigkeit: 1.2, etc.)
- Keine Verbindung zu echten Item-Daten

**Neuer Zustand:**
```tsx
// WorkshopScreen.tsx
import { getItemById } from '../data/vanillaItems';

// Wenn Item ausgewählt:
const itemStats = getItemById('diamond_sword');
// → { damage: 7, attack_speed: 1.6, durability: 1561, ... }

// Slider mit echten Werten:
<StatSlider
  label="Schaden"
  emoji="💥"
  value={currentDamage}
  defaultValue={itemStats.damage}  // ← NEU!
  maxValue={itemStats.damage * 2}  // ← NEU!
  onValueChange={setCurrentDamage}
/>
```

#### **3. Slider-Komponente mit Snap-Feature**

**Features:**
- **Standardwert-Markierung:** Kleiner Strich auf dem Slider
- **Snap-to-Default:** Rastet ein, wenn in der Nähe (±0.5)
- **Vibration:** Haptic Feedback beim Einrasten
- **Bewegbar:** Kann trotzdem weiterbewegt werden

**Implementierung:**
```tsx
// components/SnapSlider.tsx (NEU)
import { Slider } from '@react-native-community/slider';
import * as Haptics from 'expo-haptics';

interface SnapSliderProps {
  value: number;
  defaultValue: number;  // ← Standardwert für Snap
  minValue: number;
  maxValue: number;
  onValueChange: (value: number) => void;
}

const SnapSlider = ({ value, defaultValue, minValue, maxValue, onValueChange }: SnapSliderProps) => {
  const [lastSnapped, setLastSnapped] = useState(false);

  const handleValueChange = (newValue: number) => {
    // Snap-Logic
    const snapThreshold = 0.5;
    const distanceFromDefault = Math.abs(newValue - defaultValue);

    if (distanceFromDefault < snapThreshold) {
      // Snap to default
      if (!lastSnapped) {
        Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
        setLastSnapped(true);
      }
      onValueChange(defaultValue);
    } else {
      setLastSnapped(false);
      onValueChange(newValue);
    }
  };

  return (
    <View style={styles.sliderContainer}>
      {/* Track mit Standardwert-Markierung */}
      <View style={styles.sliderTrack}>
        <View style={[styles.defaultMarker, {
          left: `${((defaultValue - minValue) / (maxValue - minValue)) * 100}%`
        }]} />
      </View>

      <Slider
        value={value}
        minimumValue={minValue}
        maximumValue={maxValue}
        onValueChange={handleValueChange}
      />
    </View>
  );
};
```

#### **4. Bilder laden (von fabrik-library)**

**Option A: Direkt via URL (einfach)**
```tsx
<Image
  source={{ uri: `https://raw.githubusercontent.com/ReichiMD/fabrik-library/main/assets/vanilla/textures/items/${itemStats.texture}` }}
  style={styles.itemImage}
/>
```

**Option B: Mit Cache (besser)**
```tsx
// Expo Image mit Caching
import { Image } from 'expo-image';

<Image
  source={{ uri: `...` }}
  cachePolicy="memory-disk"
  style={styles.itemImage}
/>
```

#### **5. Dynamische Slider (je nach Item-Typ)**

**Problem:** Nicht jedes Item hat die gleichen Stats
- Waffen: Schaden, Geschwindigkeit, Haltbarkeit
- Rüstung: Armor, Durability, (Toughness)
- Nahrung: Nutrition, Saturation

**Lösung:**
```tsx
const renderStats = () => {
  const item = getItemById(selectedItemId);

  switch (item.category) {
    case 'weapons':
      return (
        <>
          <SnapSlider label="Schaden" value={damage} defaultValue={item.stats.damage} ... />
          <SnapSlider label="Geschwindigkeit" value={speed} defaultValue={item.stats.attack_speed} ... />
          <SnapSlider label="Haltbarkeit" value={durability} defaultValue={item.stats.durability} ... />
        </>
      );

    case 'armor':
      return (
        <>
          <SnapSlider label="Rüstung" value={armor} defaultValue={item.stats.armor} ... />
          <SnapSlider label="Haltbarkeit" value={durability} defaultValue={item.stats.durability} ... />
        </>
      );

    case 'food':
      return (
        <>
          <SnapSlider label="Nahrung" value={nutrition} defaultValue={item.stats.nutrition} ... />
          <SnapSlider label="Sättigung" value={saturation} defaultValue={item.stats.saturation} ... />
        </>
      );
  }
};
```

---

## 📋 Task-Liste für nächste Session

### **Phase 1: Daten-Integration (1-2 Stunden)**
- [ ] `app/src/data/vanillaItems.ts` erstellen
- [ ] Helper-Funktionen: `getItemById`, `getItemsByCategory`
- [ ] WorkshopScreen: Item-Daten aus `vanilla_stats.json` laden
- [ ] Testen: Console.log die geladenen Daten

### **Phase 2: Slider-Komponente (2-3 Stunden)**
- [ ] `app/src/components/SnapSlider.tsx` erstellen
- [ ] Snap-to-Default Logic implementieren
- [ ] Haptic Feedback (Vibration) hinzufügen
- [ ] Standardwert-Markierung (kleiner Strich) stylen
- [ ] Testen: Slider mit verschiedenen Werten

### **Phase 3: WorkshopScreen Update (2-3 Stunden)**
- [ ] StatSlider durch SnapSlider ersetzen
- [ ] Dynamische Stats je nach Item-Typ (Waffe/Rüstung/Nahrung)
- [ ] Aktuelle Werte vs. Standard-Werte verwalten
- [ ] UI: Standard-Wert im Label anzeigen (z.B. "Schaden: 8 / 7")
- [ ] Custom-Item-Flag setzen, wenn Werte geändert werden

### **Phase 4: Bilder (1-2 Stunden)**
- [ ] Expo Image installieren (`npx expo install expo-image`)
- [ ] Item-Bild im WorkshopScreen anzeigen (via fabrik-library URL)
- [ ] Fallback: Emoji, wenn Bild nicht lädt
- [ ] Cache-Strategy testen

### **Phase 5: Testing & Polish (1 Stunde)**
- [ ] Alle Items durchgehen (Waffen, Rüstung, Nahrung)
- [ ] Edge Cases: Was wenn Item keine Stats hat?
- [ ] Performance: Sind Bilder schnell genug?
- [ ] UX: Ist das Snap-Feature angenehm?

---

## 🔧 Technische Details

### **Dependencies (evtl. installieren):**
```bash
npx expo install expo-image         # Für Bild-Caching
npx expo install expo-haptics       # Für Vibration (schon installiert?)
npx expo install @react-native-community/slider  # Slider-Komponente
```

### **Dateien, die geändert werden:**
```
app/
├── src/
│   ├── components/
│   │   └── SnapSlider.tsx          (NEU)
│   ├── data/
│   │   └── vanillaItems.ts         (NEU)
│   └── screens/
│       └── WorkshopScreen.tsx      (UPDATE)
```

### **Wichtige Pfade:**
- **Vanilla Stats:** `/home/user/GameForge-Studio/library/vanilla_stats.json`
- **Bilder (fabrik-library):** `https://raw.githubusercontent.com/ReichiMD/fabrik-library/main/assets/vanilla/textures/items/`

---

## 📝 Offene Fragen für nächste Session

1. **Erweitert-Button:**
   - Welche zusätzlichen Optionen sollen rein?
   - Verzauberungen? Effekte? Item-ID?

2. **Custom Items:**
   - Wie speichern wir Custom-Werte?
   - Neues Feld in ProjectContext: `customStats`?

3. **Bilder:**
   - Option A (URL) oder Option B (lokale Kopie)?
   - Offline-Modus wichtig?

4. **Slider-Bereich:**
   - Min = 0, Max = 2x Standard?
   - Oder flexibel je nach Item?

---

## 🎨 UI-Mockup (Referenz)

```
╔══════════════════════════════════╗
║  ←   🔧 Item Editor        💾   ║
╠══════════════════════════════════╣
║                                   ║
║        ⚔️  (Bild hier)           ║
║     Diamantschwert                ║
║                                   ║
╠══════════════════════════════════╣
║  📊 EIGENSCHAFTEN                 ║
║                                   ║
║  💥 Schaden: 8 / 7 (Standard)    ║
║  [-------|•--------]              ║
║           ↑                       ║
║        Standard                   ║
║                                   ║
║  ⚡ Geschwindigkeit: 1.6 / 1.6   ║
║  [--------•--------]              ║
║                                   ║
║  🛡️ Haltbarkeit: 1561 / 1561     ║
║  [------------------•]            ║
║                                   ║
║  🎨 FARBE: [Blau] [Rot] [Grün]   ║
║                                   ║
║  ✨ EFFEKTE:                      ║
║  🔥 Feuer [AN]  💫 Leuchten [AUS] ║
║                                   ║
║  [ Erweitert ▼ ]                  ║
║                                   ║
║  [   Item hinzufügen   ]          ║
║                                   ║
╚══════════════════════════════════╝
```

---

## 🚨 Wichtige Hinweise

### **Commits:**
- Alle Änderungen sind committed und gepusht
- Branch: `claude/fix-project-item-bugs-rcO0e`
- Letzter Commit: "Add vanilla item stats library and roadmap"

### **Testing:**
- App läuft auf: `http://localhost:8081`
- Expo Start: `npm start` (im `/app` Verzeichnis)

### **Linter:**
- ESLint/Prettier hat einige Dateien automatisch formatiert
- Keine Breaking Changes

---

## 🎯 Erfolgskriterien für nächste Session

**✅ Die Session ist erfolgreich, wenn:**
1. WorkshopScreen zeigt echte Stats aus `vanilla_stats.json`
2. Slider rastet am Standardwert ein (mit Vibration)
3. Item-Bilder werden von fabrik-library geladen
4. Unterschiedliche Slider je nach Item-Typ (Waffe/Rüstung/Nahrung)
5. Smooth UX - keine Lags, kein Ruckeln

**🎉 Bonus-Ziele:**
- Erweitert-Button implementiert
- Custom-Werte werden gespeichert
- Rarity-Auswahl funktioniert

---

**Geschätzter Zeitaufwand:** 5-8 Stunden (über mehrere Sessions verteilt)

**Viel Erfolg! 🚀**
