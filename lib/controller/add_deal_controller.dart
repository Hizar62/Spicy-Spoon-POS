import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../boxes/boxes.dart';
import '../model/menu_model.dart';

class AddDealController extends GetxController {
  var imageBytes = Rxn<Uint8List>();
  final TextEditingController dealName = TextEditingController();
  final TextEditingController dealCategory = TextEditingController();
  final TextEditingController dealPrice = TextEditingController();
  var selectProduct = <MultiSelectItem<String>>[].obs;
  var selectedProduct = <String>[].obs;
  RxBool isLoading = false.obs;
  var selectedMenuModel = Rxn<MenuModel>();
  var category = <String>[].obs;
  var selectedCategory = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    loadCategories();
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
        Get.snackbar("Error", "Please select an image before saving!", snackPosition: SnackPosition.TOP);
        return;
      }

      if (dealName.text.isEmpty || dealCategory.text.isEmpty || dealPrice.text.isEmpty) {
        Get.snackbar("Error", "All fields are required!", snackPosition: SnackPosition.TOP);
        return;
      }

      final data = MenuModel(
        productImage: imageBytes.value!,
        productName: dealName.text,
        productCategory: dealCategory.text,
        price: dealPrice.text,
      );

      final box = Boxes.getData();
      box.add(data);
      data.save();

      if (!category.contains(data.productCategory)) {
        category.add(data.productCategory);
      }

      imageBytes.value = null;
      dealName.clear();
      dealCategory.clear();
      dealPrice.clear();

      Get.snackbar("Success", "Product saved successfully!", snackPosition: SnackPosition.TOP);
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void delete(MenuModel menuModel) async {
    await menuModel.delete();
    loadCategories();
  }

  void fetchIntoFields(MenuModel menuModel, Uint8List image, String name, String category, String price) async {
    selectedMenuModel.value = menuModel;
    imageBytes.value = image;
    dealName.text = name;
    dealCategory.text = category;
    dealPrice.text = price;
  }

  void editData() async {
    try {
      if (selectedMenuModel.value == null) {
        Get.snackbar('Error', 'No product selected for editing.');
        return;
      }
      selectedMenuModel.value!.productImage = imageBytes.value;
      selectedMenuModel.value!.productName = dealName.text.toString();
      selectedMenuModel.value!.productCategory = dealCategory.text.toString();
      selectedMenuModel.value!.price = dealPrice.text.toString();

      await selectedMenuModel.value!.save();
      Get.snackbar("Success", "Product Edit successfully!", snackPosition: SnackPosition.TOP);
      imageBytes.value = null;
      dealName.clear();
      dealCategory.clear();
      dealPrice.clear();
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

  void loadProducts() {
    final box = Boxes.getData();
    var data = box.values.toList().cast<MenuModel>();

    var uniqueProducts = data.map((item) => item.productName).toSet().toList();

    selectProduct.assignAll(
      uniqueProducts.map((product) => MultiSelectItem(product, product)).toList(),
    );
    
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }
}
