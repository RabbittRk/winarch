# WinDevTool

A zero-config Flutter developer tools package for **API tracking** and **schema diff detection**. Automatically captures API responses and detects schema changes in real-time during development.

## Features

- **API Response Tracking** - Automatically captures and stores API responses to Firestore
- **Schema Diff Detection** - Detects changes in API response structures and alerts developers
- **Visual Banner** - Floating action button that ripples when schema changes are detected
- **Tracking Screen** - Browse all captured API snapshots with filtering capabilities
- **Dio Interceptor** - Easy integration with existing Dio HTTP clients
- **Zero Config** - Works out of the box with minimal setup

## Getting Started

### Prerequisites

- Flutter 3.0.0 or higher
- Firebase project with Firestore enabled
- Dio HTTP client

### Installation

Add `windevtool` to your `pubspec.yaml`:

```yaml
dependencies:
  windevtool:
    path: ./packages/windevtool  # or from pub.dev when published
```

## Usage

### 1. Initialize WinDevTool

Initialize the devtool in your `main.dart` after Firebase initialization:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:windevtool/windevtool.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase first
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize WinDevTool with environment and Firebase options
  WinDevTool.initialize(
    DefaultWinDevToolConfig(
      envType: 'dev',  // 'dev', 'uat', or 'prod'
      firebaseOptions: DefaultFirebaseOptions.currentPlatform,
    ),
  );

  runApp(const MyApp());
}
```

### 2. Add the Dio Interceptor

Add the `ApiTrackingInterceptor` to your Dio instance:

```dart
import 'package:dio/dio.dart';
import 'package:windevtool/windevtool.dart';

Dio createDio({required String baseUrl}) {
  final dio = Dio(BaseOptions(baseUrl: baseUrl));

  // Add API tracking interceptor (only in dev mode)
  if (WinDevTool.isInitialized && WinDevTool.config.isEnabled) {
    dio.interceptors.add(ApiTrackingInterceptor());
  }

  return dio;
}
```

### 3. Add the Tracking Banner and Screen to Your Router

Add the visual components to your app's router:

```dart
import 'package:go_router/go_router.dart';
import 'package:windevtool/windevtool.dart';

final goRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Stack(
          children: [
            child,
            // Floating banner that shows schema change alerts
            const DevApiTrackingBanner(),
          ],
        );
      },
      routes: [
        // Your app routes...
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        
        // API Tracking screen route
        GoRoute(
          path: '/dev/api-tracking',
          name: 'devApiTracking',
          builder: (context, state) => const DevApiTrackingScreen(),
        ),
      ],
    ),
  ],
);
```

## Configuration Options

### DefaultWinDevToolConfig

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `envType` | `String` | Yes | - | Environment type: `'dev'`, `'uat'`, or `'prod'` |
| `firebaseOptions` | `FirebaseOptions?` | No | - | Firebase options from the host app |
| `firestore` | `FirebaseFirestore?` | No | `FirebaseFirestore.instance` | Custom Firestore instance |
| `apiTrackingRoute` | `String` | No | `'/dev/api-tracking'` | Route path for the tracking screen |
| `logger` | `DevToolLogger?` | No | `debugPrint` | Custom logger function |

### Custom Configuration Example

```dart
WinDevTool.initialize(
  DefaultWinDevToolConfig(
    envType: 'dev',
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
    apiTrackingRoute: '/custom/api-tracking',
    logger: (message) => myCustomLogger.log(message),
  ),
);
```

## Components

### DevApiTrackingBanner

A floating action button that appears in debug mode. It:
- Navigates to the API tracking screen when tapped
- Ripples/animates when a new schema change is detected

### DevApiTrackingScreen

A full-screen widget that displays:
- List of all captured API endpoints
- Filter by HTTP method (GET, POST, PUT, PATCH, DELETE)
- Search by endpoint path
- Response body preview
- Schema change history with diff visualization

### ApiTrackingInterceptor

A Dio interceptor that:
- Captures successful API responses
- Builds a schema from the response JSON
- Compares against previously captured schemas
- Stores baselines and changes to Firestore

## Firestore Structure

The package creates the following Firestore structure:

```
dev_api_snapshots/
  └── {endpoint_id}/
      ├── signatureKey: "GET /api/users"
      ├── method: "GET"
      ├── path: "/api/users"
      ├── query: ""
      ├── latestStatusCode: 200
      ├── latestCapturedAt: Timestamp
      ├── latestSchemaJson: {...}
      ├── latestBodySample: "..."
      ├── latestHasDiff: true/false
      ├── diffVersion: 1
      └── events/
          └── {event_id}/
              ├── capturedAt: Timestamp
              ├── statusCode: 200
              ├── diffText: "+ $.newField: String"
              ├── isBaseline: false
              └── schemaJson: {...}
```

## How It Works

1. **Baseline Capture**: When an API endpoint is called for the first time, WinDevTool captures the response and stores it as a baseline schema.

2. **Schema Comparison**: On subsequent calls to the same endpoint, the response schema is compared against the baseline.

3. **Diff Detection**: If the schema has changed (new fields added, fields removed, type changes), a diff is recorded.

4. **Visual Alert**: The `DevApiTrackingBanner` animates to alert developers of the change.

5. **Review Changes**: Developers can view all changes in the `DevApiTrackingScreen`.

## Best Practices

- Only enable in development/debug builds
- Review schema changes before deploying to production
- Use the tracking screen to document API changes
- Clear old snapshots periodically to manage Firestore usage

## License

MIT License
