import 'package:flutter_usb_printer/flutter_usb_printer.dart';
import 'dart:typed_data';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:get/get.dart';
import 'package:spicyspoon/controller/order_checkout_controller.dart';
import 'package:spicyspoon/model/menu_model.dart';
import 'package:spicyspoon/model/deal_model.dart';

class InvoicePrinter {
  final OrderCheckoutController controller = Get.find<OrderCheckoutController>();

  Future<void> printInvoice() async {
    try {
      FlutterUsbPrinter printer = FlutterUsbPrinter();

      List<Map<String, dynamic>> devices = await FlutterUsbPrinter.getUSBDeviceList();
      if (devices.isEmpty) {
        print("No USB printer found!");
        return;
      }

      Map<String, dynamic> selectedPrinter = devices.first;
      int vendorId = selectedPrinter['vendorId'];
      int productId = selectedPrinter['productId'];

      bool? isConnected = await printer.connect(vendorId, productId);
      if (isConnected != true) {
        print("Failed to connect to printer.");
        return;
      }

      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile);

      List<int> bytes = [];

      bytes += generator.text('Spicy Spoon',
          styles: const PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2));
      bytes +=
          generator.text('Phone: +1234567890', styles: const PosStyles(align: PosAlign.center));
      bytes += generator.hr();

      bytes += generator.row([
        PosColumn(text: 'Item', width: 6),
        PosColumn(text: 'Qty', width: 3, styles: const PosStyles(align: PosAlign.right)),
        PosColumn(text: 'Price', width: 3, styles: const PosStyles(align: PosAlign.right)),
      ]);
      bytes += generator.hr();

      for (var item in controller.checkOutList) {
        String productName = "";
        String price = "";
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

        bytes += generator.row([
          PosColumn(text: productName, width: 6),
          PosColumn(
              text: quantity.toString(), width: 3, styles: const PosStyles(align: PosAlign.right)),
          PosColumn(
              text: price.toString(), width: 3, styles: const PosStyles(align: PosAlign.right)),
        ]);
      }

      bytes += generator.hr();
      bytes += generator.text('Total: \$${controller.total}',
          styles: const PosStyles(align: PosAlign.right, bold: true, height: PosTextSize.size2));

      bytes += generator.feed(2);
      bytes += generator.cut();

      await printer.write(Uint8List.fromList(bytes));
      print("Invoice Printed Successfully!");
    } catch (e) {
      print("Error printing invoice: $e");
    }
  }
}
