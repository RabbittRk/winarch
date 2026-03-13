import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class TranslationSeeder {
  TranslationSeeder({
    FirebaseFirestore? firestore,
    this.collection = 'translations',
  }) : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;
  final String collection;

  Future<void> seedAllTranslations() async {
    debugPrint('TranslationSeeder: Starting seed...');

    await seedEnglish();
    await seedTamil();

    debugPrint('TranslationSeeder: Seed complete!');
  }

  Future<void> seedEnglish() async {
    final data = {
      'version': 1,
      'updatedAt': FieldValue.serverTimestamp(),
      'main': {
        'app': {
          'title': 'Winarch',
        },
        'common': {
          'ok': 'OK',
          'cancel': 'Cancel',
          'save': 'Save',
          'delete': 'Delete',
          'edit': 'Edit',
          'loading': 'Loading...',
          'error': 'Error',
          'retry': 'Retry',
        },
        'nav': {
          'home': 'Home',
          'explore': 'Explore',
          'profile': 'Profile',
        },
        'home': {
          'welcome': 'Welcome Home',
          'browse_cars': 'Browse Cars',
        },
        'actions': {
          'toggle_theme': 'Toggle theme',
          'sign_out': 'Sign out',
        },
        'auth': {
          'login': 'Login',
          'logout': 'Logout',
          'email': 'Email',
          'password': 'Password',
        },
        'settings': {
          'language': 'Language',
          'english': 'English',
          'tamil': 'Tamil',
          'select_language': 'Select Language',
        },
      },
      'cars': {
        'cars': {
          'title': 'Cars',
          'details': 'Car Details',
          'brand': 'Brand',
          'model': 'Model',
          'year': 'Year',
          'price': 'Price',
          'view_details': 'View Details',
          'no_cars_found': 'No cars found',
          'search_cars': 'Search cars',
        },
      },
    };

    await _firestore.collection(collection).doc('en').set(data);
    debugPrint('TranslationSeeder: English translations seeded');
  }

  Future<void> seedTamil() async {
    final data = {
      'version': 1,
      'updatedAt': FieldValue.serverTimestamp(),
      'main': {
        'app': {
          'title': 'விண்ஆர்ச்',
        },
        'common': {
          'ok': 'சரி',
          'cancel': 'ரத்து',
          'save': 'சேமி',
          'delete': 'நீக்கு',
          'edit': 'திருத்து',
          'loading': 'ஏற்றுகிறது...',
          'error': 'பிழை',
          'retry': 'மீண்டும் முயற்சி',
        },
        'nav': {
          'home': 'முகப்பு',
          'explore': 'ஆராய்க',
          'profile': 'சுயவிவரம்',
        },
        'home': {
          'welcome': 'வரவேற்பு',
          'browse_cars': 'கார்களை பார்க்க',
        },
        'actions': {
          'toggle_theme': 'தீம் மாற்று',
          'sign_out': 'வெளியேறு',
        },
        'auth': {
          'login': 'உள்நுழை',
          'logout': 'வெளியேறு',
          'email': 'மின்னஞ்சல்',
          'password': 'கடவுச்சொல்',
        },
        'settings': {
          'language': 'மொழி',
          'english': 'ஆங்கிலம்',
          'tamil': 'தமிழ்',
          'select_language': 'மொழியை தேர்ந்தெடு',
        },
      },
      'cars': {
        'cars': {
          'title': 'கார்கள்',
          'details': 'கார் விவரங்கள்',
          'brand': 'நிறுவனம்',
          'model': 'மாடல்',
          'year': 'ஆண்டு',
          'price': 'விலை',
          'view_details': 'விவரங்களைக் காண்க',
          'no_cars_found': 'கார்கள் இல்லை',
          'search_cars': 'கார்களை தேடு',
        },
      },
    };

    await _firestore.collection(collection).doc('ta').set(data);
    debugPrint('TranslationSeeder: Tamil translations seeded');
  }

  Future<void> updateTranslation({
    required String locale,
    required String module,
    required Map<String, dynamic> translations,
  }) async {
    final docRef = _firestore.collection(collection).doc(locale);
    final doc = await docRef.get();

    if (!doc.exists) {
      throw Exception('Locale $locale does not exist. Seed it first.');
    }

    final currentVersion = (doc.data()?['version'] as int?) ?? 0;

    await docRef.update({
      'version': currentVersion + 1,
      'updatedAt': FieldValue.serverTimestamp(),
      module: translations,
    });

    debugPrint(
      'TranslationSeeder: Updated $locale/$module to version ${currentVersion + 1}',
    );
  }

  Future<void> updateSingleKey({
    required String locale,
    required String keyPath,
    required dynamic value,
  }) async {
    final docRef = _firestore.collection(collection).doc(locale);
    final doc = await docRef.get();

    if (!doc.exists) {
      throw Exception('Locale $locale does not exist.');
    }

    final currentVersion = (doc.data()?['version'] as int?) ?? 0;

    await docRef.update({
      'version': currentVersion + 1,
      'updatedAt': FieldValue.serverTimestamp(),
      keyPath: value,
    });

    debugPrint('TranslationSeeder: Updated $locale key $keyPath');
  }
}
