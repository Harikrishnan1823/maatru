// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavouriteModelAdapter extends TypeAdapter<FavouriteModel> {
  @override
  final int typeId = 0;

  @override
  FavouriteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavouriteModel(
      id: fields[0] as String,
      originalText: fields[1] as String,
      translatedText: fields[2] as String,
      fromLanguage: fields[3] as String,
      toLanguage: fields[4] as String,
      scenario: fields[5] as String,
      savedAt: fields[6] as DateTime,
      customName: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FavouriteModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.originalText)
      ..writeByte(2)
      ..write(obj.translatedText)
      ..writeByte(3)
      ..write(obj.fromLanguage)
      ..writeByte(4)
      ..write(obj.toLanguage)
      ..writeByte(5)
      ..write(obj.scenario)
      ..writeByte(6)
      ..write(obj.savedAt)
      ..writeByte(7)
      ..write(obj.customName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavouriteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
