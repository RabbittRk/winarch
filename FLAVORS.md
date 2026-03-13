# Flutter Flavors Setup

This project is configured with three flavors: **dev**, **uat**, and **prod**.

## Package Names / Bundle Identifiers

| Flavor | Android Package Name | iOS Bundle ID |
|--------|---------------------|---------------|
| dev | com.skndan.winarch.dev | com.skndan.winarch.dev |
| uat | com.skndan.winarch.uat | com.skndan.winarch.uat |
| prod | com.skndan.winarch | com.skndan.winarch |

## App Names

| Flavor | App Name |
|--------|----------|
| dev | Winarch Dev |
| uat | Winarch UAT |
| prod | Winarch |

## Running the App

### Using Flutter CLI

```bash
# Dev flavor
flutter run --flavor dev -t lib/main_dev.dart

# UAT flavor
flutter run --flavor uat -t lib/main_uat.dart

# Prod flavor
flutter run --flavor prod -t lib/main_prod.dart
```

### Using Scripts

```bash
# Dev
./scripts/run_dev.sh

# UAT
./scripts/run_uat.sh

# Prod
./scripts/run_prod.sh
```

## Building the App

### Android APK

```bash
# Dev
flutter build apk --flavor dev -t lib/main_dev.dart

# UAT
flutter build apk --flavor uat -t lib/main_uat.dart

# Prod
flutter build apk --flavor prod -t lib/main_prod.dart
```

### Android App Bundle

```bash
# Dev
flutter build appbundle --flavor dev -t lib/main_dev.dart

# UAT
flutter build appbundle --flavor uat -t lib/main_uat.dart

# Prod
flutter build appbundle --flavor prod -t lib/main_prod.dart
```

### iOS

```bash
# Dev
flutter build ios --flavor dev -t lib/main_dev.dart

# UAT
flutter build ios --flavor uat -t lib/main_uat.dart

# Prod
flutter build ios --flavor prod -t lib/main_prod.dart
```

## Adding App Icons

### Android Icons

Place your launcher icons in the following directories:

```
android/app/src/dev/res/
├── mipmap-hdpi/ic_launcher.png      (72x72)
├── mipmap-mdpi/ic_launcher.png      (48x48)
├── mipmap-xhdpi/ic_launcher.png     (96x96)
├── mipmap-xxhdpi/ic_launcher.png    (144x144)
└── mipmap-xxxhdpi/ic_launcher.png   (192x192)

android/app/src/uat/res/
├── mipmap-hdpi/ic_launcher.png
├── mipmap-mdpi/ic_launcher.png
├── mipmap-xhdpi/ic_launcher.png
├── mipmap-xxhdpi/ic_launcher.png
└── mipmap-xxxhdpi/ic_launcher.png

android/app/src/prod/res/
├── mipmap-hdpi/ic_launcher.png
├── mipmap-mdpi/ic_launcher.png
├── mipmap-xhdpi/ic_launcher.png
├── mipmap-xxhdpi/ic_launcher.png
└── mipmap-xxxhdpi/ic_launcher.png
```

### iOS Icons

Place your app icons in the following asset catalogs:

```
ios/Runner/Assets.xcassets/
├── AppIcon-dev.appiconset/
│   ├── Icon-App-20x20@1x.png
│   ├── Icon-App-20x20@2x.png
│   ├── Icon-App-20x20@3x.png
│   ├── Icon-App-29x29@1x.png
│   ├── Icon-App-29x29@2x.png
│   ├── Icon-App-29x29@3x.png
│   ├── Icon-App-40x40@1x.png
│   ├── Icon-App-40x40@2x.png
│   ├── Icon-App-40x40@3x.png
│   ├── Icon-App-60x60@2x.png
│   ├── Icon-App-60x60@3x.png
│   ├── Icon-App-76x76@1x.png
│   ├── Icon-App-76x76@2x.png
│   ├── Icon-App-83.5x83.5@2x.png
│   └── Icon-App-1024x1024@1x.png
├── AppIcon-uat.appiconset/
│   └── (same files as above)
└── AppIcon-prod.appiconset/
    └── (same files as above)
```

### Icon Sizes Reference

| Name | Size |
|------|------|
| Icon-App-20x20@1x.png | 20x20 |
| Icon-App-20x20@2x.png | 40x40 |
| Icon-App-20x20@3x.png | 60x60 |
| Icon-App-29x29@1x.png | 29x29 |
| Icon-App-29x29@2x.png | 58x58 |
| Icon-App-29x29@3x.png | 87x87 |
| Icon-App-40x40@1x.png | 40x40 |
| Icon-App-40x40@2x.png | 80x80 |
| Icon-App-40x40@3x.png | 120x120 |
| Icon-App-60x60@2x.png | 120x120 |
| Icon-App-60x60@3x.png | 180x180 |
| Icon-App-76x76@1x.png | 76x76 |
| Icon-App-76x76@2x.png | 152x152 |
| Icon-App-83.5x83.5@2x.png | 167x167 |
| Icon-App-1024x1024@1x.png | 1024x1024 |

## Using flutter_launcher_icons (Recommended)

For easier icon generation, you can use the `flutter_launcher_icons` package:

1. Add to `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1
```

2. Create `flutter_launcher_icons-dev.yaml`:
```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icons/icon_dev.png"
  ios:
    generate_content_json: true
```

3. Create similar files for uat and prod.

4. Run:
```bash
flutter pub run flutter_launcher_icons -f flutter_launcher_icons-dev.yaml
flutter pub run flutter_launcher_icons -f flutter_launcher_icons-uat.yaml
flutter pub run flutter_launcher_icons -f flutter_launcher_icons-prod.yaml
```

## VS Code Launch Configurations

Add to `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Dev",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_dev.dart",
      "args": ["--flavor", "dev"]
    },
    {
      "name": "UAT",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_uat.dart",
      "args": ["--flavor", "uat"]
    },
    {
      "name": "Prod",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_prod.dart",
      "args": ["--flavor", "prod"]
    }
  ]
}
```

## Firebase Configuration

Each flavor should have its own Firebase project for proper separation.

### Android Setup

Place each flavor's `google-services.json` in its respective directory:

```
android/app/src/
├── dev/google-services.json      ← Dev Firebase project
├── uat/google-services.json      ← UAT Firebase project
└── prod/google-services.json     ← Prod Firebase project
```

**Steps:**
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create/select the appropriate Firebase project (dev/uat/prod)
3. Add an Android app with the correct package name:
   - Dev: `com.skndan.winarch.dev`
   - UAT: `com.skndan.winarch.uat`
   - Prod: `com.skndan.winarch`
4. Download `google-services.json` and place in the respective flavor directory

### iOS Setup

Place each flavor's `GoogleService-Info.plist` in its respective directory:

```
ios/config/
├── dev/GoogleService-Info.plist   ← Dev Firebase project
├── uat/GoogleService-Info.plist   ← UAT Firebase project
└── prod/GoogleService-Info.plist  ← Prod Firebase project
```

**Steps:**
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create/select the appropriate Firebase project (dev/uat/prod)
3. Add an iOS app with the correct bundle ID:
   - Dev: `com.skndan.winarch.dev`
   - UAT: `com.skndan.winarch.uat`
   - Prod: `com.skndan.winarch`
4. Download `GoogleService-Info.plist` and place in the respective config directory

The build script (`ios/scripts/copy_google_service.sh`) will automatically copy the correct plist based on the build configuration.

### Flutter Firebase Options

Update the `firebaseOptions` in each environment file if you have different Firebase configurations:

- `lib/env/dev.env.dart` → Dev Firebase options
- `lib/env/uat.env.dart` → UAT Firebase options  
- `lib/env/prod.env.dart` → Prod Firebase options

You can generate separate `firebase_options_*.dart` files using:

```bash
# For each flavor's Firebase project
flutterfire configure --project=your-dev-project --out=lib/firebase_options_dev.dart
flutterfire configure --project=your-uat-project --out=lib/firebase_options_uat.dart
flutterfire configure --project=your-prod-project --out=lib/firebase_options_prod.dart
```
