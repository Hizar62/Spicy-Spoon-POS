import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spicyspoon/boxes/boxes.dart';
import 'package:spicyspoon/controller/add_menu_controller.dart';
import 'package:spicyspoon/model/menu_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../utils/utils.dart';

class AddMenu extends StatelessWidget {
  const AddMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final AddMenuController controller = Get.put(AddMenuController());
    final Utils utils = Utils();

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(() {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.category.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.setCategory(controller.category[index]);
                          },
                          child: Text(
                            controller.category[index],
                            style: const TextStyle(color: Colors.black), 
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              Expanded(
                child: ValueListenableBuilder<Box<MenuModel>>(
                  valueListenable: Boxes.getData().listenable(),
                  builder: (context, box, _) {
                    return Obx(() {
                      var data = box.values.toList().cast<MenuModel>();

                      var filteredData = controller.selectedCategory.value.isEmpty
                          ? data
                          : data
                              .where((item) =>
                                  item.productCategory.trim().toLowerCase() ==
                                  controller.selectedCategory.value.trim().toLowerCase())
                              .toList();

                      return GridView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: filteredData.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                          childAspectRatio: 0.9,
                        ),
                        itemBuilder: (context, index) {
                          Uint8List? imageBytes = filteredData[index].productImage;

                          return Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                imageBytes != null
                                    ? Image.memory(imageBytes, height: 100, fit: BoxFit.cover)
                                    : const Icon(Icons.image_not_supported, size: 100),
                                const SizedBox(height: 8),
                                Text(filteredData[index].productName,
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(filteredData[index].productCategory,
                                    style: const TextStyle(color: Colors.grey)),
                                Text("RS:${filteredData[index].price}",
                                    style: const TextStyle(color: Colors.green)),
                              ],
                            ),
                          );
                        },
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          width: screenWidth * 0.25,
          height: screenHeight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Add Product',
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
                            : const Icon(Icons.camera_alt, size: 40, color: Colors.grey),
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
                          backgroundColor: utils.buttonColor,
                        ),
                        onPressed: () {
                          controller.saveData();
                        },
                        child: Obx(() {
                          return controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Save',
                                  style: TextStyle(
                                      color: utils.backGroundColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                );
                        })),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
