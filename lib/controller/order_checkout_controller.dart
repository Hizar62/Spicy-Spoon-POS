import 'package:get/get.dart';
import 'package:spicyspoon/model/menu_model.dart';

class OrderCheckoutController extends GetxController {
  var quantity = 0.obs;
  var selectedMenuModel = Rxn<MenuModel>();

  void addToCheckout(MenuModel menuModel) {
    selectedMenuModel.value = menuModel;
  }

  void removeToCheckout(MenuModel menuModel) {
    selectedMenuModel.value == null;
  }
}
