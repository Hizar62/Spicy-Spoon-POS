import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddMenuController extends GetxController {
  var imageBytes = Rxn<Uint8List>();
  final TextEditingController productName = TextEditingController();
  final TextEditingController productCategory = TextEditingController();
  final TextEditingController productPrice = TextEditingController();

  Future<void> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Uint8List bytes = await image.readAsBytes();
      imageBytes.value = bytes;
    }
  }
}
