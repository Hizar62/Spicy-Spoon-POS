import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:spicyspoon/controller/keyboard_controller.dart';

import '../boxes/boxes.dart';
import '../model/menu_model.dart';

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
                child: ValueListenableBuilder<Box<MenuModel>>(
                  valueListenable: Boxes.getData().listenable(),
                  builder: (context, box, _) {
                    var data = box.values.toList().cast<MenuModel>();

                    return GridView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemCount: data.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (context, index) {
                        Uint8List? imageBytes = data[index].productImage;

                        return Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              imageBytes != null
                                  ? Image.memory(imageBytes,
                                      height: 100, fit: BoxFit.cover)
                                  : const Icon(Icons.image_not_supported,
                                      size: 100),
                              const SizedBox(height: 8),
                              Text(data[index].productName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(data[index].productCategory,
                                  style: const TextStyle(color: Colors.grey)),
                              Text("\$${data[index].price}",
                                  style: const TextStyle(color: Colors.green)),
                            ],
                          ),
                        );
                      },
                    );
                  },
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
