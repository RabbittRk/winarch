import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:winarch/env/app.env.dart';

class DevApiTrackingBanner extends StatelessWidget {
  const DevApiTrackingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode || AppEnvironment().appEnvType != AppEnvType.dev) {
      return const SizedBox.shrink();
    }
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: FloatingActionButton.extended(
          onPressed: () {
            context.push('/dev/api-tracking');
          },
          label: const Text('API Tracking'),
        ),
      ),
    );
  }
}
