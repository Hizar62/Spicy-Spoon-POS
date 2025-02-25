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
  String price;

  MenuModel(
      {required this.productImage,
      required this.productName,
      required this.productCategory,
      required this.price});

  MenuModel copyWith({
    Uint8List? productImage,
    String? productName,
    String? productCategory,
    String? price,
  }) {
    return MenuModel(
      productImage: productImage ?? this.productImage,
      productName: productName ?? this.productName,
      productCategory: productCategory ?? this.productCategory,
      price: price ?? this.price,
    );
  }
}
