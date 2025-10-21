// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muser.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MUserAdapter extends TypeAdapter<MUser> {
  @override
  final int typeId = 1;

  @override
  MUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MUser(
      password: fields[2] as String,
      role: fields[3] as String,
      status: fields[4] as String,
      uploaded: fields[5] as bool,
      username: fields[1] as String,
      updatetAt: fields[6] as int,
      userId: fields[7] as int,
      position: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MUser obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.position)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.role)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.uploaded)
      ..writeByte(6)
      ..write(obj.updatetAt)
      ..writeByte(7)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
