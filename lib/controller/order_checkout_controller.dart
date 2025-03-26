import 'package:get/get.dart';
import 'package:spicyspoon/controller/keyboard_controller.dart';
import 'package:spicyspoon/dashboard/home.dart';
import 'package:spicyspoon/model/deal_model.dart';
import 'package:spicyspoon/model/menu_model.dart';

import '../boxes/boxes.dart';
import '../model/checkout_model.dart';

class OrderCheckoutController extends GetxController {
  var checkOutList = <dynamic>[].obs;
  var total = 0.0.obs;
  String name = '';
  final KeyboardController keyboardController = Get.put(KeyboardController());
  void addToCheckout(dynamic item) {
    double itemPrice = 0.0;

    if (item is MenuModel) {
      itemPrice = item.price;
      name = item.productName;
    } else if (item is DealModel) {
      itemPrice = item.dealprice;
      name = item.dealName;
    }

    int index = checkOutList.indexWhere((cartItem) {
      if (cartItem is MenuModel && item is MenuModel) {
        return cartItem.productName == item.productName;
      } else if (cartItem is DealModel && item is DealModel) {
        return cartItem.dealName == item.dealName;
      }
      return false;
    });

    if (index != -1) {
      if (checkOutList[index] is MenuModel) {
        (checkOutList[index] as MenuModel).quantity += 1;
      } else if (checkOutList[index] is DealModel) {
        (checkOutList[index] as DealModel).quantity += 1;
      }
      total.value += itemPrice;
    } else {
      if (item is MenuModel) {
        item.quantity = 1;
      } else if (item is DealModel) {
        item.quantity = 1;
      }
      total.value += itemPrice;
      checkOutList.add(item);
    }

    checkOutList.refresh();
  }

  void removeToCheckout(dynamic item) {
    int index = checkOutList.indexWhere((checkoutItem) {
      if (checkoutItem is MenuModel && item is MenuModel) {
        return checkoutItem.productName == item.productName;
      } else if (checkoutItem is DealModel && item is DealModel) {
        return checkoutItem.dealName == item.dealName;
      }
      return false;
    });

    if (index != -1) {
      double itemPrice = 0;
      int quantity = 1;

      if (checkOutList[index] is MenuModel) {
        MenuModel menuItem = checkOutList[index] as MenuModel;
        itemPrice = menuItem.price;
        quantity = menuItem.quantity;
      } else if (checkOutList[index] is DealModel) {
        DealModel dealItem = checkOutList[index] as DealModel;
        itemPrice = dealItem.dealprice;
        quantity = dealItem.quantity;
      }
      total.value -= itemPrice * quantity;
      checkOutList.removeAt(index);

      final KeyboardController keyboardController = Get.find();
      if (keyboardController.selectedItemIndex.value == index) {
        keyboardController.clear();
      }
    }
  }

  void calculateTotal() {
    total.value = 0.0;
    for (var item in checkOutList) {
      if (item is MenuModel) {
        total.value += item.price * item.quantity;
      } else if (item is DealModel) {
        total.value += item.dealprice * item.quantity;
      }
    }
  }

  List<CheckoutModel> getCheckoutList() {
    final box = Boxes.getCheckout();
    return box.values.toList();
  }

  void deleteCheckout(CheckoutModel checkout) {
    checkout.delete();
    Get.snackbar("Deleted", "Checkout item removed successfully.");
  }

  Future<void> savedata() async {
    try {
      final box = Boxes.getCheckout();

      for (var item in checkOutList) {
        CheckoutModel checkout;

        if (item is DealModel) {
          checkout = CheckoutModel(
            dateTime: DateTime.now(),
            product: item.dealName,
            quantity: item.quantity,
            price: item.dealprice,
          );
        } else if (item is MenuModel) {
          checkout = CheckoutModel(
            dateTime: DateTime.now(),
            product: item.productName,
            quantity: item.quantity,
            price: item.price,
          );
        } else {
          continue;
        }

        box.add(checkout);
        checkout.save();
      }

      Get.snackbar('Success', 'Checkout Completed');
      Get.to(const Home());
      checkOutList.clear();
      keyboardController.clear();
      total.value = 0;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
