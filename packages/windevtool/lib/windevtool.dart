/// Zero-config developer tools package for API tracking and schema diff detection.
///
/// ## Quick Start
///
/// 1. Initialize in your main():
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await Firebase.initializeApp();
///
///   // Zero config - just call initialize()
///   WinDevTool.initialize();
///
///   runApp(MyApp());
/// }
/// ```
///
/// 2. Add the interceptor to your Dio instance:
/// ```dart
/// final dio = Dio();
/// if (WinDevTool.isInitialized && WinDevTool.config.isEnabled) {
///   dio.interceptors.add(ApiTrackingInterceptor());
/// }
/// ```
///
/// 3. Add the tracking banner and route to your app:
/// ```dart
/// // In your router
/// GoRoute(
///   path: '/dev/api-tracking',
///   builder: (context, state) => const DevApiTrackingScreen(),
/// ),
///
/// // In your shell/scaffold
/// Stack(
///   children: [
///     child,
///     const DevApiTrackingBanner(),
///   ],
/// )
/// ```
library;

// Configuration
export 'src/config/windevtool_config.dart';

// Models
export 'src/models/dev_api_snapshot_models.dart';

// Utils
export 'src/utils/api_schema_diff.dart';
export 'src/utils/api_schema_mappers.dart';
export 'src/utils/api_request_signature.dart';

// Repositories
export 'src/repositories/dev_api_snapshot_repository.dart';

// Providers
export 'src/providers/dev_api_tracking_providers.dart';

// Interceptors
export 'src/interceptors/api_tracking_interceptor.dart';

// Widgets
export 'src/widgets/dev_api_tracking_banner.dart';
export 'src/widgets/dev_api_tracking_screen.dart';
