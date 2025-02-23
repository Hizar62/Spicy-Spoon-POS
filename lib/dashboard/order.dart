import 'package:flutter/material.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  color: Colors.blueGrey,
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.5)),
                  height: screenHeight * 0.2,
                  child: const Center(
                    child: Text(
                      'Checkout Order',
                    ),
                  )),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)),
          width: screenWidth * 0.25,
          height: screenHeight,
          child: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Quantity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }
}
