import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winarch/storage/secure_storage_helper.dart';

/// Singleton [SecureStorageHelper] for the app.
final secureStorageProvider = Provider<SecureStorageHelper>((ref) {
  return SecureStorageHelper();
});
