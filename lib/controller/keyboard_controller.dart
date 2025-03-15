import 'package:get/get.dart';
import 'package:spicyspoon/controller/order_checkout_controller.dart';

import '../model/deal_model.dart';
import '../model/menu_model.dart';

class KeyboardController extends GetxController {
  var text = ''.obs;
  var selectedItemIndex = (-1).obs; // Track the selected item index

  void onKeyboardTap(String value) {
    text.value = text.value + value;
    updateQuantity();
  }

  void updateQuantity() {
    if (selectedItemIndex.value != -1) {
      final OrderCheckoutController orderCheckoutController = Get.find();
      final item = orderCheckoutController.checkOutList[selectedItemIndex.value];
      int newQuantity = int.tryParse(text.value) ?? 1;

      if (item is MenuModel) {
        item.quantity = newQuantity;
      } else if (item is DealModel) {
        item.quantity = newQuantity;
      }

      orderCheckoutController.calculateTotal();
      orderCheckoutController.checkOutList.refresh();
    }
  }

  void clear() {
    text.value = '';
    selectedItemIndex.value = -1;
  }
}