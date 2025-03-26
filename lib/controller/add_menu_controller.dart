import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spicyspoon/boxes/boxes.dart';
import 'package:spicyspoon/model/deal_model.dart';
import 'package:spicyspoon/model/menu_model.dart';

class AddMenuController extends GetxController {
  var imageBytes = Rxn<Uint8List>();
  final TextEditingController productName = TextEditingController();
  final TextEditingController productCategory = TextEditingController();
  final TextEditingController productPrice = TextEditingController();
  RxBool isLoading = false.obs;
  var selectedMenuModel = Rxn<MenuModel>();
  var category = <String>[].obs;
  var selectedCategory = "".obs;
  var dealCategory = <String>[].obs;
  var selectedDealCategory = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadDealCategories();
  }

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

      if (productName.text.isEmpty || productCategory.text.isEmpty || productPrice.text.isEmpty) {
        Get.snackbar("Error", "All fields are required!", snackPosition: SnackPosition.TOP);
        return;
      }

      final data = MenuModel(
        productImage: imageBytes.value!,
        productName: productName.text,
        productCategory: productCategory.text,
        price: double.tryParse(productPrice.text) ?? 0.0,
      );

      final box = Boxes.getData();
      box.add(data);
      data.save();

      if (!category.contains(data.productCategory)) {
        category.add(data.productCategory);
      }

      imageBytes.value = null;
      productName.clear();
      productCategory.clear();
      productPrice.clear();

      Get.snackbar("Success", "Product saved successfully!", snackPosition: SnackPosition.TOP);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void delete(MenuModel menuModel) async {
    await menuModel.delete();
    loadCategories();
  }

  void fetchIntoFields(
      MenuModel menuModel, Uint8List image, String name, String category, double price) async {
    selectedMenuModel.value = menuModel;
    imageBytes.value = image;
    productName.text = name;
    productCategory.text = category;
    productPrice.text = price.toString();
  }

  void editData() async {
    try {
      if (selectedMenuModel.value == null) {
        Get.snackbar('Error', 'No product selected for editing.');
        return;
      }
      selectedMenuModel.value!.productImage = imageBytes.value;
      selectedMenuModel.value!.productName = productName.text.toString();
      selectedMenuModel.value!.productCategory = productCategory.text.toString();
      selectedMenuModel.value!.price = double.tryParse(productPrice.text) ?? 0.0;
      await selectedMenuModel.value!.save();
      Get.snackbar("Success", "Product Edit successfully!", snackPosition: SnackPosition.TOP);
      imageBytes.value = null;
      productName.clear();
      productCategory.clear();
      productPrice.clear();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void loadCategories() {
    final box = Boxes.getData();
    var data = box.values.toList().cast<MenuModel>();
    var uniqueCategories = data.map((item) => item.productCategory).toSet().toList();
    category.assignAll(uniqueCategories);
  }

  void loadDealCategories() {
    final box = Boxes.getDealData();
    var data = box.values.toList().cast<DealModel>();
    var uniqueCategories = data.map((item) => item.dealCategory).toSet().toList();
    dealCategory.assignAll(uniqueCategories);
    update();
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void setDealCategory(String category) {
    selectedDealCategory.value = category;
  }
}
