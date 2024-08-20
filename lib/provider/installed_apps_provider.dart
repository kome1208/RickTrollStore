import 'dart:convert';

import 'package:ricktrollstore/provider/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:math' as math;

part 'installed_apps_provider.g.dart';

@Riverpod(keepAlive: true)
class InstalledAppsNotifier extends _$InstalledAppsNotifier {
  @override
  List<String> build() {
    final result = _load();
    return result;
  }

  static const _prefs = 'InstalledApps';

  void add() {
    final newList = List<String>.from(state)
    ..insert(0, json.encode({
      "icon": "icon${(math.Random().nextInt(9))}.png"
    }));
    
    state = newList;

    ref.read(sharedPreferencesProvider).setStringList(_prefs, newList);
  }

  void remove(int index) {
    final newList = List<String>.from(state)
    ..removeAt(index);

    state = newList;
    
    ref.read(sharedPreferencesProvider).setStringList(_prefs, newList);
  }

  List<String> _load() {
    final prefs = ref.read(sharedPreferencesProvider);
    final value = prefs.getStringList(_prefs);

    return value ?? [];
  }

}