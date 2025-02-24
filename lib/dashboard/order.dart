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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Quantity',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                ),
                Obx(() {
                  return Container(
                    width: screenWidth,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      keyboardController.text.value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
                SizedBox(
                  width: 300,
                  height: 400,
                  child: NumericKeyboard(
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
                      size: 30,
                    ),
                    leftButtonFn: () {},
                    leftIcon: const Icon(
                      Icons.check_circle_outline_outlined,
                      color: Colors.green,
                      size: 30,
                    ),
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
