import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spicyspoon/controller/add_menu_controller.dart';

class AddMenu extends StatelessWidget {
  const AddMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
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
            child: SingleChildScrollView(
              // Prevents overflow
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Add Product',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    return GestureDetector(
                      onTap: () {
                        controller.getImage();
                      },
                      child: Container(
                          width: screenWidth * 0.25,
                          height: screenHeight * 0.2,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.camera_alt,
                              size: 40, color: Colors.grey)),
                    );
                  })
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
