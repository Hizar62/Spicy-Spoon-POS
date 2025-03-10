import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/order_checkout_controller.dart';
import '../model/checkout_model.dart';

class SalesRecord extends StatelessWidget {
  const SalesRecord({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderCheckoutController controller = Get.find<OrderCheckoutController>();

    return FutureBuilder(
        future: Future.value(controller.getCheckoutList()), // Fetch data
        builder: (context, AsyncSnapshot<List<CheckoutModel>> snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No checkout data available."));
          }

          final checkoutList = snapshot.data!;

          return ListView.builder(
            itemCount: checkoutList.length,
            itemBuilder: (context, index) {
              final checkout = checkoutList[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(checkout.product,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Price: ${checkout.price}"),
                      Text("Quantity: ${checkout.quantity}"),
                      Text("Date: ${checkout.dateTime.toString()}"),
                    ],
                  ),
                ),
              );
            },
          );
        });
  
  }
}
