import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:winarch/core/di/injection.dart';

/// Exposes [GetIt] to Riverpod so presentation can resolve use cases and services.
final getItProvider = Provider<GetIt>((ref) => getIt);
