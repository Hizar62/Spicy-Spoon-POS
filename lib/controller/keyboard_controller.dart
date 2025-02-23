import 'package:get/get.dart';

class KeyboardController extends GetxController {
  var text = ''.obs;

  void onKeyboardTap(var value) {
    text.value = text.value + value;
  }
}
