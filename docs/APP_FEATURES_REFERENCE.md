# 🎨 App Features & Design Reference

**Für Flutter-Migration - Komplette Feature-Beschreibung**

---

## 🎨 Design System

### **Farben:**
```
Primary: #8B5CF6 (Purple - Main accent)
Success: #10B981 (Green - Positive actions)
Info: #3B82F6 (Blue - Information, modified values)
Background: #111827 (Darkest)
Surface: #1F2937 (Cards, containers)
Text: #F9FAFB (Primary text)
TextSecondary: #9CA3AF
```

### **Spacing:**
```
xs: 4px
sm: 8px
md: 12px
lg: 16px
xl: 24px
xxl: 32px
```

### **Typography:**
```
sm: 12px
md: 16px
lg: 18px
xl: 24px
xxl: 32px
```

### **Border Radius:**
```
radiusSmall: 8px
radiusMedium: 12px
radiusLarge: 16px
```

---

## 📱 Screens & Features

### **1. Login Screen**
**Datei:** `app/src/screens/LoginScreen.tsx`

**Features:**
- Username Input (TextInput)
- GitHub Token Input (TextInput, secure)
- Login Button
- Daten werden in AsyncStorage gespeichert (@gameforge_auth)

**Layout:**
```
┌─────────────────────────────┐
│                             │
│         GameForge           │
│          Studio             │
│           Logo              │
│                             │
│  [Username Input]           │
│  [GitHub Token Input]       │
│                             │
│      [Login Button]         │
│                             │
└─────────────────────────────┘
```

---

### **2. Home Screen**
**Datei:** `app/src/screens/HomeScreen.tsx`

**Features:**
- Header mit Titel "Meine Projekte"
- "Neues Projekt" Button (groß, prominent)
- Projektliste (ScrollView)
  - Jedes Projekt zeigt:
    - Emoji (groß)
    - Projekt-Name
    - Item-Count (z.B. "3 Items")
    - Kategorie-Badge (z.B. "Waffen")
- Bottom Navigation (4 Tabs)

**Layout:**
```
┌─────────────────────────────┐
│  Meine Projekte        [⚙️]  │
├─────────────────────────────┤
│                             │
│  ┌───────────────────────┐  │
│  │   ➕ Neues Projekt   │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │ ⚔️  Supers Schwert    │  │
│  │     3 Items           │  │
│  │     [Waffen]          │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │ 🛡️  Mega Rüstung     │  │
│  │     5 Items           │  │
│  │     [Rüstung]         │  │
│  └───────────────────────┘  │
│                             │
├─────────────────────────────┤
│ [🏠] [📚] [🔧] [⚙️]       │
└─────────────────────────────┘
```

**Navigation:**
- Tap auf "Neues Projekt" → CreateProjectScreen
- Tap auf Projekt → ProjectDetailScreen

---

### **3. Create Project Screen**
**Datei:** `app/src/screens/CreateProjectScreen.tsx`

**Features:**
- 6 Kategorie-Karten:
  1. ⚔️ Waffen
  2. 🛡️ Rüstung
  3. 👾 Mobs
  4. 🍖 Nahrung
  5. 🧱 Blöcke
  6. 🔨 Werkzeuge

**Layout:**
```
┌─────────────────────────────┐
│  ← Neue Projekt             │
├─────────────────────────────┤
│                             │
│  Kategorie wählen           │
│                             │
│  ┌──────────┐ ┌──────────┐  │
│  │    ⚔️    │ │    🛡️    │  │
│  │  Waffen  │ │ Rüstung  │  │
│  └──────────┘ └──────────┘  │
│                             │
│  ┌──────────┐ ┌──────────┐  │
│  │    👾    │ │    🍖    │  │
│  │   Mobs   │ │ Nahrung  │  │
│  └──────────┘ └──────────┘  │
│                             │
│  ┌──────────┐ ┌──────────┐  │
│  │    🧱    │ │    🔨    │  │
│  │  Blöcke  │ │Werkzeuge │  │
│  └──────────┘ └──────────┘  │
│                             │
└─────────────────────────────┘
```

**Navigation:**
- Tap auf Kategorie → ProjectDetailScreen (mit newProject Param)

---

### **4. Project Detail Screen**
**Datei:** `app/src/screens/ProjectDetailScreen.tsx`

**Features:**
- Header mit Projekt-Name und Emoji
- "Item hinzufügen" Button
- Item-Liste
  - Jedes Item zeigt:
    - Emoji
    - Name
    - Stats (z.B. "7 ❤️")
    - Rarity-Badge
    - Löschen-Button (🗑️)
- Modal für Item-Auswahl (2-stufig):
  1. Kategorie auswählen
  2. Item aus Kategorie auswählen

**Layout:**
```
┌─────────────────────────────┐
│  ← ⚔️ Supers Schwert   [🗑️]│
├─────────────────────────────┤
│                             │
│  ┌───────────────────────┐  │
│  │  ➕ Item hinzufügen   │  │
│  └───────────────────────┘  │
│                             │
│  Items (3):                 │
│                             │
│  ┌───────────────────────┐  │
│  │ ⚔️ Diamantschwert     │  │
│  │    7 ❤️               │  │
│  │    [Selten]      [🗑️]│  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │ 🏹 Bogen              │  │
│  │    9 ❤️               │  │
│  │    [Normal]      [🗑️]│  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

**Item-Auswahl Modal:**
```
Schritt 1: Kategorie
┌─────────────────────────────┐
│  ← Kategorie wählen         │
├─────────────────────────────┤
│  [Suche: ___________]       │
│                             │
│  ⚔️ Waffen                   │
│  🛡️ Rüstung                 │
│  🍖 Nahrung                  │
│  etc.                       │
└─────────────────────────────┘

Schritt 2: Item
┌─────────────────────────────┐
│  ← Waffen                   │
├─────────────────────────────┤
│  [Suche: ___________]       │
│                             │
│  ⚔️ Diamantschwert (7 ❤️)   │
│  ⚔️ Eisenschwert (6 ❤️)     │
│  🗡️ Holzschwert (4 ❤️)      │
│  etc.                       │
└─────────────────────────────┘
```

**Navigation:**
- Tap auf Item → WorkshopScreen (mit selectedItem + projectId)

---

### **5. Workshop Screen** ⭐ WICHTIGSTER SCREEN
**Datei:** `app/src/screens/WorkshopScreen.tsx`

**Features:**
1. **Header:**
   - Zurück-Button (←)
   - Titel "🔧 Item Editor"
   - Speichern-Button (💾)

2. **Item Preview:**
   - Item-Bild (80x80px, von GitHub URL)
   - Item-Name (editierbar, TextInput)
   - Rarity-Badge

3. **Eigenschaften (Stats):**
   - **Dynamische Slider je nach Item-Typ!**

   **Für Waffen:**
   - 💥 Schaden (damage)
   - ⚡ Geschwindigkeit (attack_speed)
   - 🛡️ Haltbarkeit (durability)

   **Für Rüstung:**
   - 🛡️ Rüstung (armor)
   - 💪 Robustheit (armor_toughness)
   - ⚙️ Haltbarkeit (durability)

   **Für Nahrung:**
   - 🍖 Nahrung (nutrition)
   - ✨ Sättigung (saturation)

4. **Slider-Features (WICHTIG!):**
   - **Snap-to-Default:** Rastet am Standardwert ein (±0.5 Toleranz)
   - **Visuelle Markierung:** Kleiner Strich am Standardwert
   - **Farbcodierung:**
     - Grün (#10B981) = Standardwert
     - Blau (#3B82F6) = Modifiziert
   - **Anzeige:** "Aktuell / Standard" (z.B. "8 / 7")

5. **Farb-Auswahl:**
   - 8 Farben: Rot, Orange, Gelb, Grün, Blau, Lila, Pink, Weiß
   - Kreise mit Border wenn ausgewählt

6. **Spezial-Effekte:**
   - Toggle-Switches für:
     - 🔥 Feuer-Schaden
     - 💫 Leuchtend
     - 🧊 Eis-Effekt

7. **Action Button:**
   - "➕ Item hinzufügen" (wenn von ProjectDetail)
   - "🚀 Item erstellen" (wenn standalone)

**Layout:**
```
┌─────────────────────────────┐
│  ←  🔧 Item Editor      💾  │
├─────────────────────────────┤
│                             │
│       ┌───────────┐         │
│       │           │         │
│       │  [Image]  │         │
│       │  80x80    │         │
│       └───────────┘         │
│     Diamantschwert          │
│       [Selten]              │
│                             │
├─────────────────────────────┤
│  📊 EIGENSCHAFTEN           │
│                             │
│  💥 Schaden: 8 / 7          │
│  ├──────|●───────┤          │
│        ↑ Standard           │
│     [Angepasst]             │
│                             │
│  ⚡ Geschwindigkeit: 1.6    │
│  ├────────●──────┤          │
│     [Standard-Wert]         │
│                             │
│  🛡️ Haltbarkeit: 1561      │
│  ├────────●──────┤          │
│     [Standard-Wert]         │
│                             │
├─────────────────────────────┤
│  🎨 FARBE                   │
│  [🔴][🟠][🟡][🟢]          │
│  [🔵][🟣][🩷][⚪]          │
│                             │
├─────────────────────────────┤
│  ✨ SPEZIAL-EFFEKTE         │
│  🔥 Feuer-Schaden    [ON]   │
│  💫 Leuchtend        [OFF]  │
│  🧊 Eis-Effekt       [OFF]  │
│                             │
├─────────────────────────────┤
│  ┌───────────────────────┐  │
│  │  ➕ Item hinzufügen   │  │
│  └───────────────────────┘  │
└─────────────────────────────┘
```

**Slider-Details (SEHR WICHTIG FÜR FLUTTER!):**

```typescript
// SnapSlider Props:
interface SnapSliderProps {
  label: string;        // z.B. "Schaden"
  emoji: string;        // z.B. "💥"
  value: number;        // Aktueller Wert
  defaultValue: number; // Standard-Wert (zum Einrasten)
  minValue: number;     // Min (meist 0)
  maxValue: number;     // Max (meist 2x Standard)
  step: number;         // Schrittweite (0.1, 0.5, 1, 10)
  onValueChange: (value: number) => void;
  unit?: string;        // z.B. " ❤️" oder "x"
}

// Snap-Logik:
// Wenn |value - defaultValue| < 0.5 → Snap zu defaultValue
// Visuelle Markierung bei defaultValue-Position
// Farbwechsel: Grün (standard) → Blau (modified)
```

**Daten-Flow:**
```
1. Item aus ProjectDetail ausgewählt (selectedItem)
2. WorkshopScreen lädt vanilla_stats.json
3. Findet Item per ID (z.B. "diamond_sword")
4. Lädt echte Stats:
   {
     damage: 7,
     attack_speed: 1.6,
     durability: 1561
   }
5. Erstellt Slider mit:
   - min = 0
   - max = damage * 3 (z.B. 21)
   - default = 7
6. User ändert Werte
7. Speichert mit "Item hinzufügen"
```

---

### **6. Library Screen**
**Datei:** `app/src/screens/LibraryScreen.tsx`

**Features:**
- Item-Galerie (ScrollView)
- Filter-Buttons (Alle, Waffen, Rüstung, etc.)
- Items zeigen:
  - Emoji
  - Name
  - Typ-Badge
  - Rarity-Badge
  - Stats

**Layout:**
```
┌─────────────────────────────┐
│  Item Bibliothek            │
├─────────────────────────────┤
│  [✨Alle][⚔️][🛡️][🧪][🍎]  │
│                             │
│  ┌────────┐ ┌────────┐      │
│  │   ⚔️   │ │   🛡️   │      │
│  │Drachen-│ │Diamant │      │
│  │schwert │ │ Schild │      │
│  │[Legendär]│[Episch]│      │
│  └────────┘ └────────┘      │
│                             │
└─────────────────────────────┘
```

---

### **7. Settings Screen**
**Datei:** `app/src/screens/SettingsScreen.tsx`

**Features:**
- GitHub Username (anzeigen)
- Logout-Button
- App-Version
- Über-Section

**Layout:**
```
┌─────────────────────────────┐
│  Einstellungen              │
├─────────────────────────────┤
│                             │
│  👤 Account                 │
│  Username: ReichiMD         │
│                             │
│  [Logout Button]            │
│                             │
│  ℹ️ App Info                │
│  Version: 1.0.0             │
│                             │
└─────────────────────────────┘
```

---

## 📦 Daten & JSON

### **vanilla_stats.json**
**Datei:** `library/vanilla_stats.json`

**Struktur:**
```json
{
  "meta": {
    "version": "1.0.0",
    "last_update": "2026-02-06"
  },
  "items": {
    "diamond_sword": {
      "id": "minecraft:diamond_sword",
      "name": "Diamantschwert",
      "name_en": "Diamond Sword",
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
  }
}
```

**Wichtig:**
- 39 Items total
- 9 Waffen, 16 Rüstungen, 14 Nahrung
- Texture-Pfad ist relativ zu fabrik-library

**Bilder laden:**
```
Base URL: https://raw.githubusercontent.com/ReichiMD/fabrik-library/main/
Full URL: https://raw.githubusercontent.com/ReichiMD/fabrik-library/main/assets/vanilla/textures/items/diamond_sword.png
```

---

### **items.ts (Demo Items für Auswahl)**
**Datei:** `app/src/data/items.ts`

**Struktur:**
```typescript
export const demoItems: LibraryItem[] = [
  {
    id: 'diamond_sword',  // ← WICHTIG: Matched vanilla_stats.json!
    name: 'Diamantschwert',
    emoji: '⚔️',
    category: 'weapons',
    rarity: 'rare',
    stat: '7 ❤️'
  },
  // ... more items
];
```

**Wichtig:**
- Die IDs matchen mit vanilla_stats.json
- Werden für Item-Auswahl verwendet
- WorkshopScreen nutzt die ID, um echte Stats zu laden

---

## 🎯 Navigation Flow

```
App Start
  ↓
Login Screen
  ↓ (Login erfolgreich)
Bottom Navigation → Home (Tab 1)
  ↓
Home Screen
  ├─→ "Neues Projekt" → Create Project Screen
  │                        ↓
  │                     Kategorie wählen
  │                        ↓
  │                     Project Detail Screen (neu)
  │                        ↓
  │                     "Item hinzufügen"
  │                        ↓
  │                     CategoryItemModal
  │                        ↓
  │                     Workshop Screen
  │                        ↓
  │                     Item speichern
  │                        ↓
  │                     ← Zurück zu Project Detail
  │
  └─→ Projekt auswählen → Project Detail Screen
                              ↓
                          (gleicher Flow)
```

---

## 🎨 UI Components

### **Button Styles:**
```
Primary Button:
- Background: #10B981 (Success Green)
- Text: #F9FAFB (White)
- Border Radius: 16px
- Padding: 16px
- Shadow: 0 4px 15px rgba(16, 185, 129, 0.4)

Secondary Button:
- Background: #1F2937 (Surface)
- Text: #F9FAFB
- Border: 2px solid #374151
```

### **Card Styles:**
```
Project Card:
- Background: #1F2937
- Border Radius: 16px
- Padding: 16px
- Shadow: 0 2px 8px rgba(0, 0, 0, 0.2)
```

### **Input Styles:**
```
TextInput:
- Background: #1F2937
- Border: 2px solid #374151
- Border Radius: 12px
- Padding: 12px
- Text Color: #F9FAFB
- Placeholder: #6B7280
```

---

## 💾 Storage

### **AsyncStorage Keys:**
```
@gameforge_auth: {
  username: string,
  githubToken: string
}

@gameforge_projects: [
  {
    id: string,
    name: string,
    category: string,
    emoji: string,
    items: LibraryItem[]
  }
]
```

**In Flutter wird das: SharedPreferences**

---

## 🎯 Wichtigste Features für Flutter

### **Must-Have (Tag 1-3):**
1. ✅ Bottom Navigation (4 Tabs)
2. ✅ Home Screen mit Projektliste
3. ✅ Create Project (Kategorie-Auswahl)
4. ✅ Project Detail (Items anzeigen/löschen)
5. ✅ Workshop Screen mit:
   - Item-Bild von GitHub URL
   - Dynamische Slider (Waffe/Rüstung/Nahrung)
   - Snap-to-Default Feature
   - Farbauswahl
   - Effekt-Toggles

### **Nice-to-Have (Tag 4):**
6. ⚠️ Library Screen (Item-Galerie)
7. ⚠️ Settings Screen
8. ⚠️ Login Screen

### **Kann später:**
9. ⚠️ GitHub-Integration (Token, Push)
10. ⚠️ project.json Export

---

## 📸 Screenshots / Mockups

*(Keine Screenshots verfügbar, aber Code als Referenz in app/src/screens/)*

**Wichtigste Referenz-Dateien:**
- `WorkshopScreen.tsx` - Komplexester Screen
- `SnapSlider.tsx` - Wichtigste Komponente
- `vanillaItems.ts` - Daten-Logik
- `colors.ts` - Theme

---

**Version:** 1.0
**Erstellt:** 2026-02-06
**Für:** Flutter-Migration (Session #10+)
