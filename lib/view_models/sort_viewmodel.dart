import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/preferences_hive.dart';

// Create a Provider for PreferencesModel
final preferencesProvider = StateNotifierProvider<PreferencesNotifier, PreferencesModel>((ref) {
  return PreferencesNotifier();
});

class PreferencesNotifier extends StateNotifier<PreferencesModel> {
  PreferencesNotifier() : super(PreferencesModel(sortOrder: 'date')) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final box = await Hive.openBox('preferencesBox');
    final preferences = box.get('sortOrder', defaultValue: 'date');
    state = PreferencesModel(sortOrder: preferences);
  }

  Future<void> updateSortOrder(String newSortOrder) async {
    final box = await Hive.openBox('preferencesBox');
    await box.put('sortOrder', newSortOrder);
    state = PreferencesModel(sortOrder: newSortOrder);
  }
}
