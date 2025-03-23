import 'package:get/get.dart';
import 'package:spicyspoon/controller/order_checkout_controller.dart';

import '../model/deal_model.dart';
import '../model/menu_model.dart';

class KeyboardController extends GetxController {
  var text = ''.obs;
  var selectedItemIndex = (-1).obs;
  var shouldOverwrite = true.obs; 

  void onKeyboardTap(String value) {
    if (shouldOverwrite.value) {
      text.value = value;
      shouldOverwrite.value = false;
    } else {
      text.value += value;
    }
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

  void selectProduct(int index, int quantity) {
    if (selectedItemIndex.value != index) {
      selectedItemIndex.value = index;
      text.value = quantity.toString(); // Set quantity from product
      shouldOverwrite.value = true; // Ensure overwrite mode resets on new selection
    }
  }

  void clear() {
    text.value = '';
    selectedItemIndex.value = -1;
    shouldOverwrite.value = true; // Reset overwrite mode
  }
}
