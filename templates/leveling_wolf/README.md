# 🐺 Leveling Wolf Template

Dieses Template ermöglicht es, einen spezialisierten Wolf in Minecraft Bedrock (Version 1.21.131+) zu erstellen, der durch Training stärker und größer wird.

## 🚀 Funktionen
- **Level-System:** Der Wolf startet auf Level 1 nach der Zähmung.
- **Wachstum:** Durch das Füttern von **2 Knochen** steigt der Wolf auf Level 2 auf.
- **Dynamische Werte:** Mit dem Level-Aufstieg erhöht sich die physische Größe (`scale`) und der Angriffsschaden (`attack damage`) automatisch um 25% (oder den konfigurierten Wert).
- **Fehlerfrei:** Nutzt einen Custom Render Controller, um die Molang-Fehler der neuen Minecraft 1.21 Wolf-Varianten zu vermeiden.

## 🍖 Spielmechanik: Heilung vs. Training
Um die Spielbalance zu wahren, unterscheidet dieses Add-On strikt zwischen Nahrung und Training:
- **Fleisch (Rind, Schwein, etc.):** Dient wie gewohnt zur **Heilung** der Lebenspunkte des Wolfes.
- **Knochen:** Dienen exklusiv als **Trainings-Item** für das Level-Up. So verhinderst du, dass der Wolf versehentlich wächst, wenn du ihn nur heilen möchtest.

## 🛠 Konfigurations-Platzhalter
Diese Werte können im Editor der App angepasst werden:

| Platzhalter | Beschreibung | Standardwert |
|-------------|--------------|--------------|
| `{{WOLF_BASE_DAMAGE}}` | Der Schaden, den der Wolf auf Level 1 verursacht. | 4 |
| `{{WOLF_LEVEL_UP_BONUS}}` | Multiplikator für den Schaden bei Level-Aufstieg (z.B. 1.25 = +25%). | 1.25 |
| `{{WOLF_SCALE_START}}` | Die Anfangsgröße des Wolfs (1.0 = Standard). | 1.0 |

## 📂 Struktur & Technik
- **UUID-System:** Verwendet das GameForge Studio Platzhalter-System (`{{HEADER_UUID}}`, etc.).
- **Identifier:** `{{PROJECT_NAME}}:wolf`.
- **Kompatibilität:** Optimiert für Minecraft Bedrock 1.21.131+.

## 📝 Installationshinweis (Flutter)
Stelle sicher, dass alle Unterordner dieses Templates in der `pubspec.yaml` unter `assets` registriert sind, damit die App auf die JSON-Dateien zugreifen kann.
