// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MessageSchema.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageSchemaAdapter extends TypeAdapter<MessageSchema> {
  @override
  final int typeId = 0;

  @override
  MessageSchema read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageSchema(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MessageSchema obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.message)
      ..writeByte(1)
      ..write(obj.sendBy)
      ..writeByte(2)
      ..write(obj.sendTo)
      ..writeByte(3)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageSchemaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
