# GJJ Jobs

GJJ Jobs je multiplatformní mobilní aplikace vytvořená pomocí Flutteru. Slouží k propojení studentů hledajících brigádu s těmi, kteří ji nabízejí. Obsahuje přihlašování, správu nabídek a chat v reálném čase.

## Funkce

- Přihlášení a registrace (Firebase Authentication)
- Přidávání a správa nabídek
- Chat mezi uživateli (Firestore)
- Responzivní design podle Material Design

## Požadavky

- Flutter SDK (https://flutter.dev)
- Firebase účet
- Android Studio nebo VS Code

## Instalace

1. Naklonuj repozitář:
   ```
   git clone https://github.com/FilipMusil19/GJJ-Jobs.git
   cd GJJ-Jobs
   ```

2. Nainstaluj závislosti:
   ```
   flutter pub get
   ```

3. Přidej konfigurační soubory Firebase:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`

4. Spusť aplikaci:
   ```
   flutter run
   ```

## Struktura projektu

```
lib/
├── components/          // vlastní widgety
├── paces/               // jednotlivé obrazovky
└── main.dart            // vstupní bod aplikace
```

## Použité technologie

- Flutter + Dart
- Firebase (Authentication, Firestore)
- Material Design

