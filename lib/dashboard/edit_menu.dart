import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spicyspoon/controller/add_menu_controller.dart';

import '../utils/utils.dart';

class EditMenu extends StatelessWidget {
  const EditMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final Utils utils = Utils();
    final AddMenuController controller = Get.put(AddMenuController());
    return Row(
      children: [
        Expanded(child: Container()),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)),
          width: screenWidth * 0.25,
          height: screenHeight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Edit Product',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    controller.getImage();
                  },
                  child: Obx(() {
                    return Container(
                      width: screenWidth * 0.25,
                      height: screenHeight * 0.2,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: controller.imageBytes.value != null
                          ? Image.memory(
                              controller.imageBytes.value!,
                              fit: BoxFit.contain,
                            )
                          : const Icon(Icons.camera_alt,
                              size: 40, color: Colors.grey),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  child: TextFormField(
                    controller: controller.productName,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                      labelStyle: const TextStyle(color: Colors.black),
                      hintText: 'Product Name',
                      hintStyle: const TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  child: TextFormField(
                    controller: controller.productCategory,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Product Category',
                      labelStyle: const TextStyle(color: Colors.black),
                      hintText: 'Product Category',
                      hintStyle: const TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  child: TextFormField(
                    controller: controller.productPrice,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Product Price',
                      labelStyle: const TextStyle(color: Colors.black),
                      hintText: 'Product Price',
                      hintStyle: const TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: screenWidth * 0.85,
                  height: screenHeight * 0.07,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor: utils.primaryColor,
                      ),
                      onPressed: () {},
                      child: Text(
                        'Edit',
                        style: TextStyle(
                            color: utils.backGroundColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
