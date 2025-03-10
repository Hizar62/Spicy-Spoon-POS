import 'package:get/get.dart';
import 'package:spicyspoon/model/deal_model.dart';
import 'package:spicyspoon/model/menu_model.dart';

class OrderCheckoutController extends GetxController {
  var checkOutList = <dynamic>[].obs;

  var total = 0.obs;

  void addToCheckout(dynamic item) {
    int itemPrice = 0;
    String name = '';

    if (item is MenuModel) {
      itemPrice = int.tryParse(item.price) ?? 0;
      name = item.productName;
    } else if (item is DealModel) {
      itemPrice = int.tryParse(item.dealprice) ?? 0;
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
      int itemPrice = 0;
      int quantity = 1;

      if (checkOutList[index] is MenuModel) {
        MenuModel menuItem = checkOutList[index] as MenuModel;
        itemPrice = int.tryParse(menuItem.price) ?? 0;
        quantity = menuItem.quantity;
      } else if (checkOutList[index] is DealModel) {
        DealModel dealItem = checkOutList[index] as DealModel;
        itemPrice = int.tryParse(dealItem.dealprice) ?? 0;
        quantity = dealItem.quantity;
      }

      // Update total price
      total.value -= itemPrice * quantity;

      // Remove item from the list
      checkOutList.removeAt(index);
    }
  }
}
