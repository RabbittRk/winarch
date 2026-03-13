#!/bin/bash
# Build prod flavor APK
flutter build apk --flavor prod -t lib/main_prod.dart

# Build prod flavor iOS
# flutter build ios --flavor prod -t lib/main_prod.dart
