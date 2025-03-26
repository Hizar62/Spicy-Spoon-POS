import 'package:hive/hive.dart';

part 'checkout_model.g.dart';


@HiveType(typeId: 2)
class CheckoutModel extends HiveObject {
  @HiveField(0)
  DateTime dateTime;
  @HiveField(1)
  String product;
  @HiveField(2)
  int quantity;
  @HiveField(3)
  double price;

  CheckoutModel(
      {required this.dateTime, required this.product, required this.quantity, required this.price});

  CheckoutModel copyWith({
    DateTime? dateTime,
    String? product,
    int? quantity,
    double? price,
  }) {
    return CheckoutModel(
        dateTime: dateTime ?? this.dateTime,
        product: product ?? this.product,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price);
  }
}
