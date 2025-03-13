import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:spicyspoon/controller/keyboard_controller.dart';
import 'package:spicyspoon/controller/order_checkout_controller.dart';
import 'package:spicyspoon/dashboard/check_out_screen.dart';
import 'package:spicyspoon/model/deal_model.dart';

import '../boxes/boxes.dart';
import '../controller/add_menu_controller.dart';
import '../model/menu_model.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {

  @override
  void initState() {
    super.initState();
    final AddMenuController controller = Get.put(AddMenuController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadDealCategories();
    });
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final KeyboardController keyboardController = Get.put(KeyboardController());
    final OrderCheckoutController orderCheckoutController = Get.put(OrderCheckoutController());
    final AddMenuController controller = Get.put(AddMenuController());

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
                child: Text(
                  'Product Category',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
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
              const SizedBox(
                height: 30,
                child: Text(
                  'Deals',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(() {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.dealCategory.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.setCategory(controller.dealCategory[index]);
                          },
                          child: Text(
                            controller.dealCategory[index],
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
                  builder: (context, menuBox, _) {
                    return ValueListenableBuilder<Box<DealModel>>(
                      valueListenable: Boxes.getDealData().listenable(),
                      builder: (context, dealBox, _) {
                        return Obx(() {
                          var menuData = menuBox.values.toList().cast<MenuModel>();
                          var dealData = dealBox.values.toList().cast<DealModel>();

                          var filteredMenu = controller.selectedCategory.value.isEmpty
                              ? menuData
                              : menuData
                                  .where((item) =>
                                      item.productCategory.trim().toLowerCase() ==
                                      controller.selectedCategory.value.trim().toLowerCase())
                                  .toList();

                          var filteredDeals = controller.selectedDealCategory.value.isEmpty
                              ? dealData
                              : dealData
                                  .where((deal) =>
                                      deal.dealCategory.trim().toLowerCase() ==
                                      controller.selectedDealCategory.value.trim().toLowerCase())
                                  .toList();

                          var combinedList = [...filteredMenu, ...filteredDeals];

                          return GridView.builder(
                            padding: const EdgeInsets.all(10.0),
                            itemCount: combinedList.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0,
                              childAspectRatio: 0.9,
                            ),
                            itemBuilder: (context, index) {
                              var item = combinedList[index];
                              Uint8List? imageBytes;
                              String name = "";
                              String price = "";
                              String category = "";
                              String extraInfo = "";

                              if (item is MenuModel) {
                                imageBytes = item.productImage;
                                name = item.productName;
                                price = "RS:${item.price}";
                                category = item.productCategory;
                                extraInfo = "";
                              } else if (item is DealModel) {
                                imageBytes = item.dealImage;
                                name = item.dealName;
                                price = "RS:${item.dealprice}";
                                category = item.dealCategory;
                              }

                              return GestureDetector(
                                onTap: () {
                                  orderCheckoutController.addToCheckout(item);
                                  keyboardController.selectedItemIndex.value =
                                      orderCheckoutController.checkOutList.indexOf(item);
                                  keyboardController.text.value = item.quantity.toString();
                                },
                                child: Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      imageBytes != null
                                          ? Image.memory(imageBytes, height: 100, fit: BoxFit.cover)
                                          : const Icon(Icons.image_not_supported, size: 100),
                                      const SizedBox(height: 8),
                                      Text(name,
                                          style: const TextStyle(fontWeight: FontWeight.bold)),
                                      Text(category, style: const TextStyle(color: Colors.grey)),
                                      if (extraInfo.isNotEmpty)
                                        Text(extraInfo, style: const TextStyle(color: Colors.grey)),
                                      Text(price, style: const TextStyle(color: Colors.green)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        });
                      },
                    );
                  },
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.0, bottom: 2.0),
                      child: Text(
                        "Checkout Order",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.5),
                    ),
                    height: screenHeight * 0.25,
                    child: Center(
                      child: Obx(() {
                        return SizedBox(
                          width: double.infinity,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: orderCheckoutController.checkOutList.length,
                            itemBuilder: (context, index) {
                              final item = orderCheckoutController.checkOutList[index];

                              bool isMenu = item is MenuModel;
                              bool isDeal = item is DealModel;

                              if (!isMenu && !isDeal) {
                                return const SizedBox();
                              }

                              Uint8List? imageBytes = isMenu
                                  ? item.productImage
                                  : isDeal
                                      ? item.dealImage
                                      : null;

                              return Stack(
                                children: [
                                  Card(
                                    margin: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        imageBytes != null
                                            ? Image.memory(imageBytes,
                                                height: 70, fit: BoxFit.cover)
                                            : const Icon(Icons.image_not_supported, size: 70),
                                        const SizedBox(height: 2),
                                        Text(
                                          isMenu
                                              ? item.productName
                                              : isDeal
                                                  ? item.dealName
                                                  : 'Unknown',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          isMenu
                                              ? item.productCategory
                                              : isDeal
                                                  ? item.selectedProduct.join(', ')
                                                  : 'Unknown',
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                        Text(
                                          "RS:${isMenu ? item.price : isDeal ? item.dealprice : 0}",
                                          style: const TextStyle(color: Colors.green),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 5.0,
                                    right: 1.0,
                                    child: IconButton(
                                      onPressed: () {
                                        orderCheckoutController.removeToCheckout(item);
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 5.0,
                                    left: 1.0,
                                    child: IconButton(
                                      onPressed: () {
                                        keyboardController.onKeyboardTap(item.quantity.toString());
                                      },
                                      icon: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          const Icon(Icons.circle, color: Colors.green, size: 24),
                                          Text(
                                            item.quantity.toString(),
                                            style: const TextStyle(
                                                color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Quantity',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Obx(() {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      keyboardController.text.value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: NumericKeyboard(
                    onKeyboardTap: keyboardController.onKeyboardTap,
                    textColor: Colors.black,
                    rightButtonFn: () {
                      if (keyboardController.text.value.isNotEmpty) {
                        keyboardController.text.value = keyboardController.text.value
                            .substring(0, keyboardController.text.value.length - 1);
                        keyboardController.updateQuantity();
                      }
                    },
                    rightIcon: const Icon(
                      Icons.backspace,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                ),
                const Text(
                  'Net Total',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                Obx(() {
                  return SizedBox(
                    width: screenWidth * 0.25,
                    child: Center(
                      child: Text(
                        'RS = ${orderCheckoutController.total.value.toString()}',
                        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: screenWidth * 0.85,
                  height: screenHeight * 0.09,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        Get.to(const CheckOutScreen());
                      },
                      child: const Text(
                        'Order Checkout',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

extension on HiveObject {
  get quantity => 1;
}
