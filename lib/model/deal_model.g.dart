// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DealModelAdapter extends TypeAdapter<DealModel> {
  @override
  final int typeId = 1;

  @override
  DealModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DealModel(
      dealImage: fields[0] as Uint8List?,
      dealName: fields[1] as String,
      selectedProduct: (fields[3] as List).cast<dynamic>(),
      dealCategory: fields[2] as String,
      dealprice: fields[4] as String,
      quantity: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DealModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.dealImage)
      ..writeByte(1)
      ..write(obj.dealName)
      ..writeByte(2)
      ..write(obj.dealCategory)
      ..writeByte(3)
      ..write(obj.selectedProduct)
      ..writeByte(4)
      ..write(obj.dealprice)
      ..writeByte(5)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DealModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
