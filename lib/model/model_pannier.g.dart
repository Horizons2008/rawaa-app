// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_pannier.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemAdapter extends TypeAdapter<CartItem> {
  @override
  final int typeId = 0;

  @override
  CartItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItem(
      productTitle: fields[0] as String,
      categorieTitle: fields[1] as String,
      stockId: fields[2] as int,
      price: fields[3] as double,
      qte: fields[4] as double,
      position: fields[5] as int,
      vendeurId: fields[6] as String,
      vendeurTitle: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CartItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.productTitle)
      ..writeByte(1)
      ..write(obj.categorieTitle)
      ..writeByte(2)
      ..write(obj.stockId)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.qte)
      ..writeByte(5)
      ..write(obj.position)
      ..writeByte(6)
      ..write(obj.vendeurId)
      ..writeByte(7)
      ..write(obj.vendeurTitle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
