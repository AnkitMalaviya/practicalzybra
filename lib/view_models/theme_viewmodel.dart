import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final themeProvider = StateNotifierProvider<ThemeViewModel, ThemeMode>((ref) {
  return ThemeViewModel();
});

class ThemeViewModel extends StateNotifier<ThemeMode> {

  static const String _themeKey = 'themeMode';
  final Box _settingsBox;

  ThemeViewModel()
      : _settingsBox = Hive.box('settings'),
        super(_loadThemeFromHive());

  // Load theme from Hive
  static ThemeMode _loadThemeFromHive() {
    final box = Hive.box('settings');
    final themeIndex = box.get(_themeKey, defaultValue: ThemeMode.light.index);
    return ThemeMode.values[themeIndex];
  }

  void toggleTheme() {
    final newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    state = newTheme;
    _settingsBox.put(_themeKey, newTheme.index);
  }
}
