import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winarch/theme/material.dart';
import 'package:winarch/theme/typography.dart';

/// Composes typography and material into light/dark [ThemeData].
class AppTheme {
  AppTheme() : _material = MaterialTheme(TextTypoGraphy.instance!.textTheme);

  final MaterialTheme _material;

  ThemeData get light => _material.light();
  ThemeData get dark => _material.dark();
}

/// State exposed to [MaterialApp]: theme, darkTheme, themeMode.
class ThemeState {
  const ThemeState({
    required this.theme,
    required this.darkTheme,
    required this.themeMode,
  });

  final ThemeData theme;
  final ThemeData darkTheme;
  final ThemeMode themeMode;
}

class ThemeNotifier extends Notifier<ThemeState> {
  late final AppTheme _appTheme;

  @override
  ThemeState build() {
    _appTheme = AppTheme();
    return ThemeState(
      theme: _appTheme.light,
      darkTheme: _appTheme.dark,
      themeMode: ThemeMode.system,
    );
  }

  void toggle() {
    state = ThemeState(
      theme: _appTheme.light,
      darkTheme: _appTheme.dark,
      themeMode:
          state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
    );
  }

  void setLight() => _setMode(ThemeMode.light);
  void setDark() => _setMode(ThemeMode.dark);
  void setSystem() => _setMode(ThemeMode.system);

  void _setMode(ThemeMode mode) {
    state = ThemeState(
      theme: _appTheme.light,
      darkTheme: _appTheme.dark,
      themeMode: mode,
    );
  }
}

final themeProvider =
    NotifierProvider<ThemeNotifier, ThemeState>(ThemeNotifier.new);
