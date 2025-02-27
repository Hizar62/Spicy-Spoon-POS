import 'package:get/get.dart';
import 'package:spicyspoon/model/menu_model.dart';

class OrderCheckoutController extends GetxController {
  var quantity = 0.obs;
  var checkOutList = <MenuModel>[].obs;

  void addToCheckout(MenuModel menuModel) {
    checkOutList.add(menuModel);
  }

  void removeToCheckout(MenuModel menuModel) {
    checkOutList.remove(menuModel);
  }
}
