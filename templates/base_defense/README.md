# 🛡️ Base Defense Factory Template

Dieses Template ermöglicht es, ein komplettes Tower-Defense-Minispiel in Minecraft zu erstellen. Es ist speziell für die **Add-On Factory** entwickelt worden, sodass alle Spielparameter über den Editor angepasst werden können.

## 🕹️ Das Spielprinzip: "Überlebe den Ansturm"

1. **Einfacher Einstieg:** Der Spieler craftet mit nur **2x Holzbrettern** einen **Basis-Starter**.
2. **Aufbau:** Durch Platzieren des Starters erscheint der **Schutz-Kern**. Der Spieler erhält sofort eine festgelegte Anzahl an **Verteidigungstürmen**.
3. **Action:** Automatisch spawnen **Angreifer** im Umkreis und marschieren auf den Kern zu.
4. **Verteidigung:** Die Türme beschießen die Angreifer automatisch.
5. **Belohnung:** Besiegte Gegner lassen **Kristalle** (Smaragde) fallen, die für den weiteren Ausbau der Basis genutzt werden können.

## ⚙️ Editor-Variablen (Anpassbar)

Die folgenden Werte können in der App eingestellt werden, um das Spielerlebnis zu verändern:

| Platzhalter | Beschreibung | Standardwert |
| :--- | :--- | :--- |
| `{{CORE_HEALTH}}` | Lebenspunkte des Schutz-Kerns | 100 |
| `{{SPAWN_DELAY}}` | Zeit zwischen den einzelnen Spawns (Sekunden) | 10 |
| `{{SPAWN_RADIUS}}` | Entfernung, in der Gegner erscheinen (Blöcke) | 25 |
| `{{START_TURRETS}}` | Anzahl der Türme, die man zum Start geschenkt bekommt | 3 |
| `{{REWARD_COUNT}}` | Anzahl der Kristalle pro besiegtem Gegner | 1 |
| `{{TURRET_RANGE}}` | Reichweite der Verteidigungstürme (Blöcke) | 15 |

## 🛠️ Technische Struktur

* **Behavior Pack:** Enthält die KI der Türme, das Spawn-System im Kern und das Crafting-Rezept.
* **Resource Pack:** Enthält die Modelle (Eisengolem für Türme, Endkristall für den Kern) und die deutschen Texte.

## 🎮 Gameplay-Details

* **Gegner-Typen:** Normale Angreifer (80%) und Elite-Gegner (20%) mit doppeltem Leben und Schaden
* **Gegner-Geschwindigkeit:** 0.25 Blöcke/Sekunde (langsames Tempo)
* **Turm-Schussrate:** 1-2 Sekunden zwischen Schüssen
* **Endlos-Modus:** Das Spiel läuft ohne Zeitlimit - überlebe so lange wie möglich!

---
*Dieses Projekt ist eine Co-Produktion zwischen Mensch und KI – GameForge-Studio 2026.*
