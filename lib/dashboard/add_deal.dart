import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../controller/add_deal_controller.dart';
import '../utils/utils.dart';

class AddDeal extends StatelessWidget {
  const AddDeal({super.key});

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
          child: Container(),
        ),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          width: screenWidth * 0.25,
          height: screenHeight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              // Prevents overflow
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
                    child: Obx(() {
                      return MultiSelectDialogField(
                        items: controller.selectProduct.toList(),
                        title: const Text("Select Products"),
                        selectedColor: Colors.blue,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        buttonText: const Text("Select Products"),
                        initialValue: controller.selectedProduct.toList(),
                        onConfirm: (values) {
                          controller.selectedProduct.assignAll(values.cast<String>());
                        },
                      );
                    }),
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
                                  style: TextStyle(color: utils.backGroundColor, fontWeight: FontWeight.bold, fontSize: 18),
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
