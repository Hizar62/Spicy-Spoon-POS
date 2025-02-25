import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spicyspoon/boxes/boxes.dart';
import 'package:spicyspoon/model/menu_model.dart';

class AddMenuController extends GetxController {
  var imageBytes = Rxn<Uint8List>();
  final TextEditingController productName = TextEditingController();
  final TextEditingController productCategory = TextEditingController();
  final TextEditingController productPrice = TextEditingController();
  RxBool isLoading = false.obs;

  Future<void> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Uint8List bytes = await image.readAsBytes();
      imageBytes.value = bytes;
    }
  }

  Future<void> saveData() async {
    try {
      isLoading.value = true;
      if (imageBytes.value == null) {
        Get.snackbar("Error", "Please select an image before saving!",
            snackPosition: SnackPosition.TOP);
        return;
      }

      if (productName.text.isEmpty ||
          productCategory.text.isEmpty ||
          productPrice.text.isEmpty) {
        Get.snackbar("Error", "All fields are required!",
            snackPosition: SnackPosition.TOP);
        return;
      }

      final data = MenuModel(
        productImage: imageBytes.value!,
        productName: productName.text,
        productCategory: productCategory.text,
        price: productPrice.text,
      );

      final box = Boxes.getData();
      box.add(data);
      data.save();

      imageBytes.value = null;
      productName.clear();
      productCategory.clear();
      productPrice.clear();

      Get.snackbar("Success", "Product saved successfully!",
          snackPosition: SnackPosition.TOP);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void delete(MenuModel menuModel) async {
    await menuModel.delete();
  }

  void editData(MenuModel menuModel, Uint8List image, String name,
      String category, String price) async {
    isLoading.value = true;
    imageBytes.value = image;
    productName.text = name;
    productCategory.text = category;
    productPrice.text = price;
    try {
      menuModel.productImage = imageBytes.value;
      menuModel.productName = productName.text.toString();
      menuModel.productCategory = productCategory.text.toString();
      menuModel.price = productPrice.text.toString();

      await menuModel.save();
      Get.snackbar("Success", "Product Edit successfully!",
          snackPosition: SnackPosition.TOP);
      imageBytes.value = null;
      productName.clear();
      productCategory.clear();
      productPrice.clear();
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
