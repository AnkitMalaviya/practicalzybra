import 'package:hive/hive.dart';

part 'preferences_hive.g.dart';

@HiveType(typeId: 0)
class PreferencesModel {
  @HiveField(0)
  final String sortOrder; // Can be 'date' or 'priority'

  PreferencesModel({required this.sortOrder});
}
