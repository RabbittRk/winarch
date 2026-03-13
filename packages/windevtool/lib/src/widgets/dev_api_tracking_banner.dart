import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../config/windevtool_config.dart';
import '../providers/dev_api_tracking_providers.dart';

class DevApiTrackingBanner extends ConsumerStatefulWidget {
  const DevApiTrackingBanner({super.key});

  @override
  ConsumerState<DevApiTrackingBanner> createState() =>
      _DevApiTrackingBannerState();
}

class _DevApiTrackingBannerState extends ConsumerState<DevApiTrackingBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _isRippling = false;
  int _lastDiffVersion = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerRipple() {
    if (_isRippling) return;
    setState(() => _isRippling = true);
    _controller.forward(from: 0);
    _controller.addStatusListener(_onAnimStatus);
  }

  void _onAnimStatus(AnimationStatus status) {
    if (!mounted) return;
    if (status == AnimationStatus.completed) {
      _controller.reverse();
    } else if (status == AnimationStatus.dismissed) {
      _controller.removeStatusListener(_onAnimStatus);
      setState(() => _isRippling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!WinDevTool.isInitialized || !WinDevTool.config.isEnabled) {
      return const SizedBox.shrink();
    }

    final diffVersionAsync = ref.watch(devApiLatestDiffVersionProvider);
    final diffVersion = diffVersionAsync.maybeWhen(
      data: (value) => value,
      orElse: () => 0,
    );

    if (_lastDiffVersion == -1) {
      _lastDiffVersion = diffVersion;
    } else if (diffVersion > _lastDiffVersion) {
      _lastDiffVersion = diffVersion;
      _triggerRipple();
    } else {
      _lastDiffVersion = diffVersion;
    }

    final colorScheme = Theme.of(context).colorScheme;
    final route = WinDevTool.config.apiTrackingRoute;

    final Widget fab = FloatingActionButton(
      onPressed: () => context.push(route),
    );

    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final t = _controller.value;
              final radius = 28.0 + (t * 10.0);
              final borderColor = Color.lerp(
                Colors.transparent,
                colorScheme.error,
                t,
              );

              return AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: _isRippling
                      ? Border.all(
                          color: borderColor ?? Colors.transparent,
                          width: 2,
                        )
                      : null,
                  boxShadow: _isRippling
                      ? [
                          BoxShadow(
                            color: (borderColor ?? colorScheme.error)
                                .withValues(alpha: 0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: SizedBox(
                  height: radius,
                  width: radius,
                  child: Center(child: child),
                ),
              );
            },
            child: fab,
          ),
        ),
      ),
    );
  }
}
