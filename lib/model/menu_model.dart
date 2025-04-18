import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'menu_model.g.dart';

@HiveType(typeId: 0)
class MenuModel extends HiveObject {
  @HiveField(0)
  Uint8List? productImage;
  @HiveField(1)
  String productName;
  @HiveField(2)
  String productCategory;
  @HiveField(3)
  double price;
  @HiveField(4)
  int quantity;

  MenuModel(
      {required this.productImage,
      required this.productName,
      required this.productCategory,
      required this.price,
      this.quantity = 1});

  MenuModel copyWith({
    Uint8List? productImage,
    String? productName,
    String? productCategory,
    double? price,
  }) {
    return MenuModel(
      productImage: productImage ?? this.productImage,
      productName: productName ?? this.productName,
      productCategory: productCategory ?? this.productCategory,
      price: price ?? this.price,
    );
  }
}

