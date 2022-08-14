// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'students.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentsAdapter extends TypeAdapter<Students> {
  @override
  final int typeId = 0;

  @override
  Students read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Students(
      stdName: fields[0] as String?,
      stdNumber: fields[1] as String?,
      dataEntryId: fields[2] as int?,
      qrCode: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Students obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.stdName)
      ..writeByte(1)
      ..write(obj.stdNumber)
      ..writeByte(2)
      ..write(obj.dataEntryId)
      ..writeByte(3)
      ..write(obj.qrCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}


