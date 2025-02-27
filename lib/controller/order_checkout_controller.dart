import 'package:get/get.dart';
import 'package:spicyspoon/model/menu_model.dart';

class OrderCheckoutController extends GetxController {
  var checkOutList = <MenuModel>[].obs;
  var total = 0.obs;

  void addToCheckout(MenuModel menuModel) {
    int itemPrice = int.tryParse(menuModel.price) ?? 0;
    int index = checkOutList
        .indexWhere((item) => item.productName == menuModel.productName);

    if (index != -1) {
      checkOutList[index].quantity += 1;
      total.value += itemPrice;
      checkOutList.refresh();
    } else {
      menuModel.quantity = 1;
      total.value += itemPrice;
      checkOutList.add(menuModel);
    }
    checkOutList.refresh();
  }

  void removeToCheckout(MenuModel menuModel) {
    int index = checkOutList
        .indexWhere((item) => item.productName == menuModel.productName);
    if (index != -1) {
      int itemPrice = int.tryParse(checkOutList[index].price) ?? 0;

      total.value -= itemPrice * checkOutList[index].quantity;

      checkOutList.removeAt(index);
    }
  }
}
