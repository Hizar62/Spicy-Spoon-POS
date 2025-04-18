import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spicyspoon/model/deal_model.dart';
import '../boxes/boxes.dart';
import '../controller/add_deal_controller.dart';
import '../utils/utils.dart';

class AddDeal extends StatefulWidget {
  const AddDeal({super.key});

  @override
  State<AddDeal> createState() => _AddDealState();
}

class _AddDealState extends State<AddDeal> {
  @override
  void initState() {
    super.initState();
    final AddDealController controller = Get.put(AddDealController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final AddDealController controller = Get.put(AddDealController());
    final Utils utils = Utils();

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
                  Uint8List? imageBytes = data[index].dealImage;

                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Add Deals',
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
                        labelText: 'Deal Name',
                        labelStyle: const TextStyle(color: Colors.black),
                        hintText: 'Deal Name',
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
                          controller: controller.productInputController, // Add this to controller
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
                        labelText: 'Category',
                        labelStyle: const TextStyle(color: Colors.black),
                        hintText: 'Category',
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
                        labelText: 'Deal Price',
                        labelStyle: const TextStyle(color: Colors.black),
                        hintText: 'Deal Price',
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
