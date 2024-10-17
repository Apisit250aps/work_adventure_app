// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestAdapter extends TypeAdapter<Quest> {
  @override
  final int typeId = 0;

  @override
  Quest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quest(
      id: fields[0] as String?,
      title: fields[1] as String,
      isCompleted: fields[2] as bool,
      date: fields[3] as DateTime,
      details: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Quest obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.isCompleted)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.details);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
