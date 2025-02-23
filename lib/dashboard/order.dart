import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:spicyspoon/controller/keyboard_controller.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final KeyboardController keyboardController = Get.put(KeyboardController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  color: Colors.blueGrey,
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.5)),
                  height: screenHeight * 0.2,
                  child: const Center(
                    child: Text(
                      'Checkout Order',
                    ),
                  )),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)),
          width: screenWidth * 0.25,
          height: screenHeight,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Obx(() {
                  return Text(
                    keyboardController.text.value,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  );
                }),
                NumericKeyboard(
                  onKeyboardTap: keyboardController.onKeyboardTap,
                  textColor: Colors.black,
                  rightButtonFn: () {
                    if (keyboardController.text.value.isNotEmpty) {
                      keyboardController.text.value =
                          keyboardController.text.value.substring(
                              0, keyboardController.text.value.length - 1);
                    }
                  },
                  rightIcon: const Icon(
                    Icons.backspace,
                    color: Colors.red,
                  ),
                  leftButtonFn: () {},
                  leftIcon: const Icon(
                    Icons.check,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
