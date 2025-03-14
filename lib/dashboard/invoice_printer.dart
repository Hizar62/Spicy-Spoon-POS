import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:spicyspoon/controller/order_checkout_controller.dart';
import 'package:spicyspoon/dashboard/pdf_preview_screen.dart';
import 'package:spicyspoon/model/menu_model.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoicePrinter {
  final OrderCheckoutController controller = Get.find<OrderCheckoutController>();

  Future<void> printInvoice() async {
    try {
      // Generate PDF
      final pdf = pw.Document();

      final ByteData data = await rootBundle.load('assets/Spicy_spoon.png');
      final Uint8List imgBytes = data.buffer.asUint8List();
      final image = img.decodeImage(imgBytes);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                if (image != null)
                  pw.Image(
                    pw.MemoryImage(Uint8List.fromList(img.encodePng(image))),
                    width: 200,
                    height: 100,
                  ),
                pw.Text('Phone: 03272826000', textAlign: pw.TextAlign.center),
                pw.Divider(),
                pw.Row(
                  children: [
                    pw.Expanded(flex: 6, child: pw.Text('Item')),
                    pw.Expanded(flex: 3, child: pw.Text('Qty', textAlign: pw.TextAlign.right)),
                    pw.Expanded(flex: 3, child: pw.Text('Price', textAlign: pw.TextAlign.right)),
                  ],
                ),
                pw.Divider(),
                for (var item in controller.checkOutList)
                  pw.Row(
                    children: [
                      pw.Expanded(
                          flex: 6,
                          child: pw.Text(item is MenuModel ? item.productName : item.dealName)),
                      pw.Expanded(
                          flex: 3,
                          child: pw.Text(item.quantity.toString(), textAlign: pw.TextAlign.right)),
                      pw.Expanded(
                          flex: 3,
                          child: pw.Text(item is MenuModel ? item.price : item.dealprice,
                              textAlign: pw.TextAlign.right)),
                    ],
                  ),
                pw.Divider(),
                pw.Text('Total: \$${controller.total}',
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
              ],
            );
          },
        ),
      );

      // Save the PDF to a byte array
      final Uint8List pdfBytes = await pdf.save();

      // Navigate to the PDF preview screen
      Get.to(() => PdfPreviewScreen(pdfBytes: pdfBytes));
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
