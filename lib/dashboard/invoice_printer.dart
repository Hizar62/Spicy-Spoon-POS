import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:spicyspoon/controller/order_checkout_controller.dart';
import 'package:spicyspoon/model/menu_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart'; // Add this for date formatting

class InvoicePrinter {
  final OrderCheckoutController controller = Get.find<OrderCheckoutController>();

  Future<void> printInvoice() async {
    try {
      final pdf = pw.Document();

      final ByteData data = await rootBundle.load('assets/Spicy_spoon.png');
      final Uint8List imgBytes = data.buffer.asUint8List();
      final image = img.decodeImage(imgBytes);

      final now = DateTime.now();
      final dateFormat = DateFormat("dd/ MMMM/ yyyy hh:mm a");
      final formattedDateTime = dateFormat.format(now); 

      pdf.addPage(
        pw.Page(
          pageFormat: const PdfPageFormat(80 * PdfPageFormat.mm, double.infinity),
          margin: const pw.EdgeInsets.all(5),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (image != null)
                  pw.Center(
                    child: pw.Image(
                      pw.MemoryImage(Uint8List.fromList(img.encodePng(image))),
                      width: 150,
                      height: 70,
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
                pw.SizedBox(height: 5),
                pw.Center(
                  child: pw.Text(
                    'Phone: 03272826000',
                    style: const pw.TextStyle(fontSize: 10),
                    softWrap: true,
                  ),
                ),
                pw.SizedBox(height: 5),
                // Add Date and Time here
                pw.Center(
                  child: pw.Text(
                    formattedDateTime,
                    style: const pw.TextStyle(fontSize: 10),
                    softWrap: true,
                  ),
                ),
                pw.Divider(),
                pw.Table(
                  border: pw.TableBorder.all(width: 0.5),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(3),
                    1: const pw.FlexColumnWidth(1),
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Text(
                          'Item',
                          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.left,
                        ),
                        pw.Text(
                          'Price',
                          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.right,
                        ),
                      ],
                    ),
                    for (var item in controller.checkOutList)
                      pw.TableRow(
                        children: [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                item is MenuModel ? item.productName : item.dealName,
                                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                                maxLines: 2,
                                overflow: pw.TextOverflow.clip,
                              ),
                              pw.Text(
                                '${item.quantity} × ${(item is MenuModel) ? item.price : item.dealprice}',
                                style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey),
                              ),
                            ],
                          ),
                          pw.Text(
                            '${item.quantity * ((item is MenuModel) ? item.price : item.dealprice)}',
                            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.right,
                          ),
                        ],
                      ),
                  ],
                ),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Total:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                    ),
                    pw.Text(
                      'RS: ${controller.total}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                    ),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Center(
                  child: pw.Text(
                    'Thank you for your visit!',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
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
      print(e.toString());
    }
  }
}
