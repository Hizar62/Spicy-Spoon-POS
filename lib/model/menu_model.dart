import 'package:flutter/widgets.dart';

class MenuModel {
  final Image productImage;
  final String productName;
  final String productCategory;
  final int price;

  MenuModel(
      {required this.productImage,
      required this.productName,
      required this.productCategory,
      required this.price});
}
