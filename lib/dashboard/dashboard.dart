import 'package:flutter/material.dart';
import 'package:spicyspoon/utils/utils.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils();
    // final screenSize = MediaQuery.of(context).size;
    // final screenWidth = screenSize.width;
    // final screenHeight = screenSize.height;

    return Scaffold(
        appBar: AppBar(
          title: Text(utils.companyName),
          backgroundColor: utils.pimaryColor,
          centerTitle: true,
        ),
        body: Container());
  }
}
