import 'package:get/get.dart';
import 'package:spicyspoon/boxes/boxes.dart';
import 'package:spicyspoon/model/checkout_model.dart';

class CheckoutController extends GetxController {
  var datetime = DateTime.timestamp().obs;
  var product = ''.obs;
  var quantity = 0.obs;
  var price = 0.obs;

  Future<void> savedata() async {
    try {
      final checkout = CheckoutModel(
          dateTime: datetime.value,
          product: product.value,
          quantity: quantity.value,
          price: price.value);

      final box = Boxes.getCheckout();
      box.add(checkout);
      checkout.save();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
