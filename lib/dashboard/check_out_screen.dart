import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spicyspoon/controller/order_checkout_controller.dart';
import 'package:spicyspoon/dashboard/invoice_printer.dart';
import 'package:spicyspoon/model/menu_model.dart';
import 'package:spicyspoon/model/deal_model.dart';
import 'package:spicyspoon/utils/utils.dart';

class CheckOutScreen extends StatelessWidget {
  const CheckOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils();
    final OrderCheckoutController controller = Get.find<OrderCheckoutController>();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        backgroundColor: utils.primaryColor,
      ),
      body: Obx(() {
        if (controller.checkOutList.isEmpty) {
          return const Center(child: Text("No checkout data available."));
        }

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Checkout Items:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...controller.checkOutList.map((item) {
                  String productName = "";
                  double price = 0.0;
                  int quantity = 1;

                  if (item is MenuModel) {
                    productName = item.productName;
                    price = item.price;
                    quantity = item.quantity;
                  } else if (item is DealModel) {
                    productName = item.dealName;
                    price = item.dealprice;
                    quantity = item.quantity;
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            productName,
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text("Qty: $quantity"),
                        Text("Price: $price"),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => controller.removeToCheckout(item),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Grand Total ${controller.total}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.85,
                    height: screenHeight * 0.09,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          InvoicePrinter().printInvoice();
                        },
                        child: const Text(
                          'Print',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                        )),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.85,
                    height: screenHeight * 0.09,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          controller.savedata();
                          // InvoicePrinter().printInvoice();
                        },
                        child: const Text(
                          'Order Checkout',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                        )),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
