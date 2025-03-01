import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:spicyspoon/model/deal_model.dart';

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
  var selectedDealModel = Rxn<DealModel>();
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
        Get.snackbar("Error", "Please select an image before saving!",
            snackPosition: SnackPosition.TOP);
        return;
      }

      if (dealName.text.isEmpty || dealCategory.text.isEmpty || dealPrice.text.isEmpty) {
        Get.snackbar("Error", "All fields are required!", snackPosition: SnackPosition.TOP);
        return;
      }

      final data = DealModel(
        dealImage: imageBytes.value!,
        dealName: dealName.text,
        dealCategory: dealCategory.text,
        selectedProduct: selectedProduct.toList(),
        dealprice: dealPrice.text,
      );

      final box = Boxes.getDealData();
      box.add(data);
      data.save();

      imageBytes.value = null;
      dealName.clear();
      selectedProduct.clear();
      dealCategory.clear();
      dealPrice.clear();

      Get.snackbar("Success", "Product saved successfully!", snackPosition: SnackPosition.TOP);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void delete(DealModel dealModel) async {
    await dealModel.delete();
    loadCategories();
  }

  void fetchIntoFields(DealModel dealModel, Uint8List image, String name, List selectedItems,
      String category, String dealprice) async {
    selectedDealModel.value = dealModel;
    imageBytes.value = image;
    dealName.text = name;
    selectedProduct.value = selectedItems as List<String>;
    dealCategory.text = category;
    dealPrice.text = dealprice;
  }

  void editData() async {
    try {
      if (selectedDealModel.value == null) {
        Get.snackbar('Error', 'No product selected for editing.');
        return;
      }
      selectedDealModel.value!.dealImage = imageBytes.value;
      selectedDealModel.value!.dealName = dealName.text.toString();
      selectedDealModel.value!.dealCategory = dealCategory.text.toString();
      selectedDealModel.value!.selectedProduct = selectedProduct.toList();
      selectedDealModel.value!.dealprice = dealPrice.text.toString();

      await selectedDealModel.value!.save();
      Get.snackbar("Success", "Product Edit successfully!", snackPosition: SnackPosition.TOP);
      imageBytes.value = null;
      dealName.clear();
      selectedProduct.clear();
      dealCategory.clear();
      dealPrice.clear();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void loadCategories() {
    final box = Boxes.getDealData();
    var data = box.values.toList().cast<DealModel>();

    var uniqueCategories = data.map((item) => item.dealCategory).toSet().toList();
    category.assignAll(uniqueCategories);
  }

  void loadProducts() {
    final box = Boxes.getData();
    var data = box.values.toList().cast<MenuModel>();

    var uniqueProducts = data.map((item) => item.productName).toSet().toList();

    selectProduct.assignAll(
      uniqueProducts.map((product) => MultiSelectItem(product, product)).toList(),
    );
    print(uniqueProducts);
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }
}
