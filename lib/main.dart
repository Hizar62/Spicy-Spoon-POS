import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spicyspoon/controller/order_checkout_controller.dart';
import 'package:spicyspoon/dashboard/home.dart';
import 'package:spicyspoon/model/checkout_model.dart';
import 'package:spicyspoon/model/deal_model.dart';
import 'package:spicyspoon/model/menu_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path); 
  Hive.registerAdapter(MenuModelAdapter());
  Hive.registerAdapter(DealModelAdapter());
  Hive.registerAdapter(CheckoutModelAdapter());
  await Hive.openBox<MenuModel>('pos');
  await Hive.openBox<DealModel>('posdeal');
  await Hive.openBox<CheckoutModel>('checkout');
  Get.put(OrderCheckoutController()); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Spicy Spoon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}
