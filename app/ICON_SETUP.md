# 🎨 App-Icon & Splash-Screen Setup

## Status: ✅ Packages installiert, ⏳ Icon-Grafik fehlt noch

Die Infrastruktur für App-Icon und Splash-Screen ist fertig! Du musst nur noch eigene Icon-Grafiken hinzufügen.

---

## 📱 Was ist bereits konfiguriert?

✅ **Packages installiert:**
- `flutter_launcher_icons` - für App-Icons
- `flutter_native_splash` - für Splash-Screen

✅ **Farbschema konfiguriert:**
- Background: `#8B5CF6` (Purple - passt zum App-Theme)
- Splash Screen: `#1F2937` (Dark Gray - passt zum App-Theme)

---

## 🚀 Nächste Schritte

### 1. Icon-Grafik erstellen

Du brauchst ein **1024x1024 PNG** Bild für das App-Icon.

**Empfohlene Tools:**
- [Canva](https://www.canva.com) - Einfach, kostenlos
- [Figma](https://www.figma.com) - Professionell
- GIMP / Photoshop - Lokale Tools

**Icon-Design Ideen:**
- ⚔️ Ein Schwert + Hammer (GameForge = Schmiede)
- 🎮 Minecraft-Style Block mit Werkzeug
- 🔥 Flammen + Werkzeug (für "Forge")

### 2. Icon-Datei speichern

Erstelle einen Ordner und speichere dein Icon:

```
app/
└── assets/
    └── icon/
        └── app_icon.png  (1024x1024 PNG)
```

### 3. pubspec.yaml aktualisieren

Aktiviere die Icon-Zeile in `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"  # <- Auskommentieren!
  adaptive_icon_background: "#8B5CF6"
```

### 4. Icons generieren

Führe diesen Befehl aus (wenn Flutter lokal installiert ist):

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

**GitHub Actions macht das automatisch beim Build!** 🚀

---

## 🌅 Splash-Screen (Optional)

Du kannst auch ein Splash-Screen Bild hinzufügen:

1. Erstelle `app/assets/splash/splash_icon.png` (512x512 PNG)
2. Aktiviere die Zeile in `pubspec.yaml`:
   ```yaml
   flutter_native_splash:
     image: "assets/splash/splash_icon.png"
   ```
3. Generiere: `flutter pub run flutter_native_splash:create`

---

## 💡 Quick-Tipp für Anfänger

**Kein Photoshop? Kein Problem!**

1. Gehe zu [Canva](https://www.canva.com)
2. Erstelle ein "Custom Size" Design (1024x1024)
3. Füge ein cooles Icon + Text "GameForge" hinzu
4. Download als PNG
5. Fertig! 🎉

---

## 🎨 Farben des GameForge Studios

Nutze diese Farben für dein Icon-Design:

- **Purple** (Primary): `#8B5CF6`
- **Dark Gray** (Background): `#1F2937`
- **White** (Text): `#FFFFFF`
- **Green** (Success): `#10B981`

---

## ✅ Checklist

- [ ] Icon-Grafik erstellen (1024x1024 PNG)
- [ ] Datei nach `app/assets/icon/app_icon.png` speichern
- [ ] Zeile in `pubspec.yaml` auskommentieren
- [ ] Build in GitHub Actions prüfen

**Hinweis:** GitHub Actions wird die Icons automatisch beim Build generieren - du musst nichts manuell ausführen! 🚀
