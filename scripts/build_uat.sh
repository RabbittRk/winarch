#!/bin/bash
# Build uat flavor APK
flutter build apk --flavor uat -t lib/main_uat.dart

# Build uat flavor iOS
# flutter build ios --flavor uat -t lib/main_uat.dart
