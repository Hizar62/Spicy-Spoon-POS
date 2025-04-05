import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/order_checkout_controller.dart';
import '../model/checkout_model.dart';

class SalesRecord extends StatelessWidget {
  SalesRecord({super.key});

  final OrderCheckoutController controller = Get.find<OrderCheckoutController>();
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: searchController,
            onChanged: (value) => searchQuery.value = value.toLowerCase(),
            decoration: InputDecoration(
              hintText: "Search by product name...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: Future.value(controller.getCheckoutList()),
            builder: (context, AsyncSnapshot<List<CheckoutModel>> snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No checkout data available."));
              }

              final checkoutList = snapshot.data!;

              Map<String, List<CheckoutModel>> groupedByDate = {};
              for (var item in checkoutList) {
                String formattedDate = DateFormat('dd-MM-yyyy').format(item.dateTime);
                groupedByDate.putIfAbsent(formattedDate, () => []).add(item);
              }
              var sortedEntries = groupedByDate.entries.toList()
                ..sort((a, b) {
                  DateTime dateA = DateFormat('dd-MM-yyyy').parse(a.key);
                  DateTime dateB = DateFormat('dd-MM-yyyy').parse(b.key);
                  return dateB.compareTo(dateA);
                });

              return Obx(() {
                return ListView(
                  padding: const EdgeInsets.all(10),
                  children: sortedEntries.map((entry) {
                    String date = entry.key;
                    List<CheckoutModel> items = entry.value;

                    List<CheckoutModel> filteredItems = items.where((item) {
                      return item.product.toLowerCase().contains(searchQuery.value);
                    }).toList();

                    if (filteredItems.isEmpty) return const SizedBox();

                    double dateTotal =
                        filteredItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

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
                            children: filteredItems.map((checkout) {
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
              });
            },
          ),
        ),
      ],
    );
  }
}
