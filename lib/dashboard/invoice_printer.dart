import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:spicyspoon/controller/order_checkout_controller.dart';
import 'package:spicyspoon/model/menu_model.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoicePrinter {
  final OrderCheckoutController controller = Get.find<OrderCheckoutController>();

  Future<void> printInvoice() async {
    try {
      final pdf = pw.Document();

      final ByteData data = await rootBundle.load('assets/Spicy_spoon.png');
      final Uint8List imgBytes = data.buffer.asUint8List();
      final image = img.decodeImage(imgBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: const PdfPageFormat(80 * PdfPageFormat.mm, double.infinity),
          margin: pw.EdgeInsets.zero,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (image != null)
                  pw.Center(
                    child: pw.Image(
                      pw.MemoryImage(Uint8List.fromList(img.encodePng(image))),
                      width: 170,
                      height: 80,
                    ),
                  ),
                pw.SizedBox(height: 10),
                pw.Center(
                  child: pw.Text(
                    'Bhagowal Road Ada Gopalpur Sialkot',
                    style: const pw.TextStyle(fontSize: 10),
                    softWrap: true,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Center(
                  child: pw.Text(
                    'Phone: 03272826000',
                    style: const pw.TextStyle(fontSize: 10),
                    softWrap: true,
                  ),
                ),
                pw.Divider(),
                pw.Row(
                  children: [
                    pw.Expanded(
                        flex: 5,
                        child: pw.Text('Item',
                            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold))),
                    pw.Expanded(
                        flex: 3,
                        child: pw.Text('Price',
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold))),
                  ],
                ),
                pw.Divider(),
                for (var item in controller.checkOutList) ...[
                  pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 5,
                        child: pw.Text(
                          item is MenuModel ? item.productName : item.dealName,
                          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Expanded(flex: 3, child: pw.SizedBox()),
                    ],
                  ),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 5,
                        child: pw.Text(
                          '${item.quantity} × ${(item is MenuModel) ? item.price : item.dealprice}',
                          style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey),
                        ),
                      ),
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(
                          '${item.quantity * ((item is MenuModel) ? item.price : item.dealprice)}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                ],
                pw.Divider(),
                pw.Row(
                  children: [
                    pw.Expanded(
                        flex: 5,
                        child: pw.Text('Total:',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
                    pw.Expanded(
                        flex: 5,
                        child: pw.Text('RS: ${controller.total}',
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Center(
                  child:
                      pw.Text('Thank you for your visit!', style: const pw.TextStyle(fontSize: 10)),
                ),
              ],
            );
          },
        ),
      );

      final Uint8List pdfBytes = await pdf.save();
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
