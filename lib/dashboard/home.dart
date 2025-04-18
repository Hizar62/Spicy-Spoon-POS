import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spicyspoon/controller/home_controller.dart';
import 'package:spicyspoon/dashboard/add_deal.dart';
import 'package:spicyspoon/dashboard/add_menu.dart';
import 'package:spicyspoon/dashboard/edit_deal.dart';
import 'package:spicyspoon/dashboard/edit_menu.dart';
import 'package:spicyspoon/dashboard/order.dart';
import 'package:spicyspoon/dashboard/sales_record.dart';

import 'package:spicyspoon/utils/utils.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _screen = [
    const Order(),
    const AddMenu(),
    const EditMenu(),
    const AddDeal(),
    const EditDeal(),
    SalesRecord()
  ];

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils();

    return Scaffold(
        appBar: AppBar(
          title: Text(utils.companyName),
          backgroundColor: utils.primaryColor,
          centerTitle: true,
        ),
        bottomNavigationBar: MediaQuery.of(context).size.width < 640
            ? Obx(() {
                return BottomNavigationBar(
                  currentIndex: homeController.selectedIndex.value,
                  unselectedItemColor: Colors.grey,
                  selectedItemColor: Colors.red,
                  onTap: (int index) {
                    homeController.selectedIndexValue(index);
                  },
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: 'Home'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.add), label: 'Add Menu'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.edit), label: 'Edit Menu'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.add_circle_outline_outlined), label: 'Add Deals'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.edit_note_outlined), label: 'Edit Deals'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.history), label: 'Sales Record'),
                  ],
                );
              })
            : null,
        body: Row(
          children: [
            if (MediaQuery.of(context).size.width >= 640)
              Obx(() {
                return NavigationRail(
                  groupAlignment: -1.0, 
                  destinations: const [
                    NavigationRailDestination(
                      icon: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 12.0), 
                        child: Icon(Icons.home),
                      ),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Icon(Icons.add),
                      ),
                      label: Text('Add Menu'),
                    ),
                    NavigationRailDestination(
                      icon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Icon(Icons.edit),
                      ),
                      label: Text('Edit Menu'),
                    ),
                    NavigationRailDestination(
                      icon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Icon(Icons.add_circle_outline_outlined),
                      ),
                      label: Text('Add Deals'),
                    ),
                    NavigationRailDestination(
                      icon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Icon(Icons.edit_note_outlined),
                      ),
                      label: Text('Edit Deals'),
                    ),
                    NavigationRailDestination(
                      icon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Icon(Icons.history),
                      ),
                      label: Text('Sales Record'),
                    ),
                  ],
                  labelType: NavigationRailLabelType.all,
                  selectedLabelTextStyle: const TextStyle(color: Colors.black),
                  unselectedLabelTextStyle: const TextStyle(color: Colors.black),
                  leading: const Column(
                    children: [
                      SizedBox(height: 8),
                      CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.person),
                      ),
                      SizedBox(height: 20), 
                    ],
                  ),
                  selectedIndex: homeController.selectedIndex.value,
                  onDestinationSelected: (int index) {
                    homeController.selectedIndexValue(index);
                  },
                );
              }),
            Obx(() {
              return Expanded(
                  child: _screen[homeController.selectedIndex.value]);
            })
          ],
        ));
  }
}
