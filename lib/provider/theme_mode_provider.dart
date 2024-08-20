import 'package:flutter/material.dart';
import 'package:ricktrollstore/provider/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:collection/collection.dart';

part 'theme_mode_provider.g.dart';

@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    final result = _load();
    if (result != null) {
      return result;
    }
    return ThemeMode.system;
  }

  static const _prefs = 'ThemeMode';

  void setTheme(ThemeMode theme) {
    state = theme;
    ref.read(sharedPreferencesProvider).setString(_prefs, theme.name);
  }

  ThemeMode? _load() {
    final prefs = ref.read(sharedPreferencesProvider);
    final value = prefs.getString(_prefs);
    if (value == null) {
      return null;
    }
    return ThemeMode.values.firstWhereOrNull((x) => x.name == value);
  }

}