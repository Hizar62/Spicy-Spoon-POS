import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spicyspoon/boxes/boxes.dart';
import 'package:spicyspoon/controller/add_deal_controller.dart';
import 'package:spicyspoon/model/deal_model.dart';
import 'package:spicyspoon/utils/utils.dart';

class EditDeal extends StatelessWidget {
  const EditDeal({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final Utils utils = Utils();
    final AddDealController controller = Get.put(AddDealController());

    return Row(
      children: [
        Expanded(
          child: ValueListenableBuilder<Box<DealModel>>(
            valueListenable: Boxes.getDealData().listenable(),
            builder: (context, box, _) {
              var data = box.values.toList().cast<DealModel>();

              return GridView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  Uint8List imageBytes = data[index].dealImage ?? Uint8List(0);

                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ignore: unnecessary_null_comparison
                        imageBytes != null
                            ? Image.memory(imageBytes, height: 100, fit: BoxFit.cover)
                            : const Icon(Icons.image_not_supported, size: 100),
                        const SizedBox(height: 8),
                        Text(data[index].dealName,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(data[index].selectedProduct.toString(),
                            style: const TextStyle(color: Colors.black)),
                        Text(data[index].dealCategory, style: const TextStyle(color: Colors.grey)),
                        Text("RS:${data[index].dealprice}",
                            style: const TextStyle(color: Colors.green)),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {
                                controller.fetchIntoFields(
                                    data[index],
                                    imageBytes,
                                    data[index].dealName,
                                    data[index].selectedProduct.cast<String>(),
                                    data[index].dealCategory,
                                    data[index].dealprice);
                              },
                              icon: const Icon(Icons.edit),
                              color: Colors.green,
                              tooltip: "Edit Item",
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Confirmation"),
                                      content:
                                          const Text("Are you sure you want to delete this item?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            controller.delete(data[index]);
                                            Navigator.of(context)
                                                .pop(); // Close the dialog after deleting
                                          },
                                          child: const Text("Delete"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              tooltip: "Delete Item",
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
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
                          : const Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  child: TextFormField(
                    controller: controller.dealName,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: controller.productInputController, 
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Add Product',
                          labelStyle: const TextStyle(color: Colors.black),
                          hintText: 'Enter product and press Enter',
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
                        onFieldSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            controller.selectedProduct.add(value.trim());
                            controller.productInputController.clear();
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      Obx(() => Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: controller.selectedProduct
                                .map((product) => Chip(
                                      label: Text(product),
                                      backgroundColor: Colors.blue.withOpacity(0.1),
                                      deleteIcon: const Icon(Icons.close, size: 18),
                                      onDeleted: () {
                                        controller.selectedProduct.remove(product);
                                      },
                                    ))
                                .toList(),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  child: TextFormField(
                    controller: controller.dealCategory,
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
                    controller: controller.dealPrice,
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
                      onPressed: () {
                        controller.editData();
                      },
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
