

import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'deal_model.g.dart';


@HiveType(typeId: 1)
class DealModel extends HiveObject {
  @HiveField(0)
  Uint8List? dealImage;
  @HiveField(1)
  String dealName;
  @HiveField(2)
  String dealCategory;
  @HiveField(3)
  List selectedProduct;
  @HiveField(4)
  double dealprice;
  @HiveField(5)
  int quantity;

  DealModel(
      {required this.dealImage,
      required this.dealName,
      required this.selectedProduct,
      required this.dealCategory,
      required this.dealprice,
      this.quantity = 1});

  DealModel copyWith(
      {Uint8List? dealImage,
      String? dealName,
      String? dealCategory,
      List? selectedProduct,
      double? dealprice}) {
    return DealModel(
        dealImage: dealImage ?? this.dealImage,
        dealName: dealName ?? this.dealName,
        selectedProduct: selectedProduct ?? this.selectedProduct,
        dealCategory: dealCategory ?? this.dealCategory,
        dealprice: dealprice ?? this.dealprice);
  }
}
