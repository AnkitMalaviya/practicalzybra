// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PreferencesModelAdapter extends TypeAdapter<PreferencesModel> {
  @override
  final int typeId = 0;

  @override
  PreferencesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PreferencesModel(
      sortOrder: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PreferencesModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.sortOrder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreferencesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
