import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:spicyspoon/controller/order_checkout_controller.dart';
import 'package:spicyspoon/model/menu_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

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
          pageFormat: const PdfPageFormat(74 * PdfPageFormat.mm, double.infinity),
          margin: const pw.EdgeInsets.all(8),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                if (image != null)
                  pw.Center(
                    child: pw.Image(
                      pw.MemoryImage(Uint8List.fromList(img.encodePng(image))),
                      width: 120,
                      height: 60,
                    ),
                  ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Bhagowal Road Ada Gopalpur Sialkot',
                  style: const pw.TextStyle(fontSize: 9),
                  textAlign: pw.TextAlign.center,
                  softWrap: true,
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Phone: 03272826000',
                  style: const pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.center,
                  softWrap: true,
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  formattedDateTime,
                  style: const pw.TextStyle(fontSize: 7),
                  textAlign: pw.TextAlign.center,
                  softWrap: true,
                ),
                pw.SizedBox(height: 4),
                pw.Divider(),
                pw.Table(
                  border: pw.TableBorder.all(width: 0.5),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(2.5), // ITEM
                    1: const pw.FlexColumnWidth(1), // QTY
                    2: const pw.FlexColumnWidth(1), // PRICE
                    3: const pw.FlexColumnWidth(1), // TOTAL
                  },
                  defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(1),
                          child: pw.Text(
                            'ITEM',
                            style: const pw.TextStyle(fontSize: 8),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(1),
                          child: pw.Text(
                            'QTY',
                            style: const pw.TextStyle(fontSize: 8),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(1),
                          child: pw.Text(
                            'PRICE',
                            style: const pw.TextStyle(fontSize: 8),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(1),
                          child: pw.Text(
                            'TOTAL',
                            style: const pw.TextStyle(fontSize: 8),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    for (var item in controller.checkOutList)
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(1),
                            child: pw.Text(
                              item is MenuModel ? item.productName : item.dealName,
                              style: const pw.TextStyle(fontSize: 7),
                              textAlign: pw.TextAlign.center,
                              maxLines: 2,
                              overflow: pw.TextOverflow.clip,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(1),
                            child: pw.Text(
                              '${item.quantity}',
                              style: const pw.TextStyle(fontSize: 7),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(1),
                            child: pw.Text(
                              '${(item is MenuModel) ? item.price : item.dealprice}',
                              style: const pw.TextStyle(fontSize: 7),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(1),
                            child: pw.Text(
                              '${item.quantity * ((item is MenuModel) ? item.price : item.dealprice)}',
                              style: const pw.TextStyle(fontSize: 7),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    pw.TableRow(
                      children: [
                        pw.Text(''),
                        pw.Text(''),
                        pw.Text(''),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(1),
                          child: pw.Text(
                            '${controller.total}',
                            style: const pw.TextStyle(fontSize: 9),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.Divider(),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Thank You!',
                  style: const pw.TextStyle(fontSize: 9),
                  textAlign: pw.TextAlign.center,
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
