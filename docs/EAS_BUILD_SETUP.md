# 🚀 EAS Build Setup - Anleitung

## Was ist EAS Build?

**EAS (Expo Application Services)** ist der professionelle Build-Service von Expo.
Die APK wird auf Expo-Servern gebaut (nicht auf GitHub), was robuster und zuverlässiger ist.

**Vorteile:**
- ✅ Funktioniert mit allen nativen Dependencies (Haptics, Slider, Images)
- ✅ Professionelle Build-Infrastruktur
- ✅ **Kostenlos** für Open-Source-Projekte
- ✅ Automatische Builds bei jedem Push

---

## 📋 Setup in 3 Schritten

### **Schritt 1: Expo-Account erstellen**

1. Gehe zu: https://expo.dev/signup
2. Erstelle einen kostenlosen Account
3. Bestätige deine E-Mail

---

### **Schritt 2: Expo Token erstellen**

1. Gehe zu: https://expo.dev/accounts/[dein-username]/settings/access-tokens
2. Klicke auf **"Create Token"**
3. Name: `GitHub Actions Build`
4. Kopiere den Token (sieht aus wie: `abc123...xyz`)

---

### **Schritt 3: Token zu GitHub hinzufügen**

1. Gehe zu deinem GitHub Repo: https://github.com/ReichiMD/GameForge-Studio
2. Klicke auf **Settings** (oben)
3. Sidebar: **Secrets and variables** → **Actions**
4. Klicke **"New repository secret"**
5. Name: `EXPO_TOKEN`
6. Value: [Dein kopierter Token]
7. Klicke **"Add secret"**

---

## ✅ Fertig!

Der nächste Push wird automatisch die APK mit EAS bauen!

**Build-Status checken:**
- GitHub Actions: https://github.com/ReichiMD/GameForge-Studio/actions
- Expo Dashboard: https://expo.dev

**APK herunterladen:**
- Nach dem Build: GitHub Actions → Artifacts → "GameForge-Studio-APK"

---

## 🛠️ Manueller Build (Optional)

Du kannst auch lokal bauen:

```bash
# 1. EAS CLI installieren
npm install -g eas-cli

# 2. In App-Verzeichnis wechseln
cd app

# 3. Login
eas login

# 4. Build starten
eas build --platform android --profile preview
```

Die APK wird dann auf expo.dev gespeichert.

---

## ℹ️ Build-Profile

- **preview**: Schneller Build, APK-Format (für Testing)
- **production**: Vollständiger Build, für Play Store

Aktuell verwenden wir **preview** für schnellere Builds.

---

**Bei Fragen:** https://docs.expo.dev/build/introduction/
