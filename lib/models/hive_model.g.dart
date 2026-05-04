// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryModelAdapter extends TypeAdapter<HistoryModel> {
  @override
  final int typeId = 2;

  @override
  HistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryModel(
      question: fields[0] as String,
      solution: fields[1] as String,
      category: fields[2] as String,
      type: fields[3] as String,
      steps: (fields[4] as List).cast<dynamic>(),
      searchText: fields[5] as String,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.question)
      ..writeByte(1)
      ..write(obj.solution)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.steps)
      ..writeByte(5)
      ..write(obj.searchText)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
