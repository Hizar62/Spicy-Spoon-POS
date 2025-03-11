import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; 
import '../controller/order_checkout_controller.dart';
import '../model/checkout_model.dart';

class SalesRecord extends StatelessWidget {
  const SalesRecord({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderCheckoutController controller = Get.find<OrderCheckoutController>();

    return FutureBuilder(
      future: Future.value(controller.getCheckoutList()),
      builder: (context, AsyncSnapshot<List<CheckoutModel>> snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No checkout data available."));
        }

        final checkoutList = snapshot.data!;

        
        Map<String, List<CheckoutModel>> groupedByDate = {};

        for (var item in checkoutList) {
          String formattedDate = DateFormat('dd-MM-yyyy').format(item.dateTime);
          if (!groupedByDate.containsKey(formattedDate)) {
            groupedByDate[formattedDate] = [];
          }
          groupedByDate[formattedDate]!.add(item);
        }

        return ListView(
          padding: const EdgeInsets.all(10),
          children: groupedByDate.entries.map((entry) {
            String date = entry.key;
            List<CheckoutModel> items = entry.value;

            double dateTotal = items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

            return Container(
              margin: const EdgeInsets.only(bottom: 15),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Date: $date",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  Column(
                    children: items.map((checkout) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                checkout.product,
                                style: const TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text("Qty: ${checkout.quantity}"),
                            const Text('-'),
                            Text(
                              "Price: ${checkout.price}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Total: ${dateTotal.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
