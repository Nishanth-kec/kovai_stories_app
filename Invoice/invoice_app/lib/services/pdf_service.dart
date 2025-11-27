import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../models/invoice.dart';
import '../models/client.dart';

class PdfService {
  static Future<Uint8List> generateInvoicePdf({
    required InvoiceModel invoice,
    required ClientModel client,
    required String companyName,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (pw.Context context) {
          return [
            // HEADER
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(companyName,
                        style: pw.TextStyle(
                            fontSize: 22, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 5),
                    pw.Text("Invoice #: ${invoice.number}"),
                    pw.Text("Status: ${invoice.status.toUpperCase()}"),
                  ],
                ),
                pw.Text("INVOICE",
                    style: pw.TextStyle(
                        fontSize: 32, fontWeight: pw.FontWeight.bold)),
              ],
            ),

            pw.SizedBox(height: 30),

            // BILL TO
            pw.Text("Bill To",
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(client.name),
                  if (client.email != null) pw.Text(client.email!),
                  if (client.phone != null) pw.Text(client.phone!),
                  if (client.address != null) pw.Text(client.address!),
                ],
              ),
            ),

            pw.SizedBox(height: 25),

            // ITEMS TABLE
            pw.Table.fromTextArray(
              headers: ["Description", "Qty", "Unit Price", "Total"],
              data: invoice.items.map((i) {
                return [
                  i.description,
                  i.qty.toString(),
                  "\$${i.unitPrice.toStringAsFixed(2)}",
                  "\$${i.total.toStringAsFixed(2)}",
                ];
              }).toList(),
              headerStyle:
                  pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
              cellStyle: const pw.TextStyle(fontSize: 12),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              border: pw.TableBorder.all(color: PdfColors.grey),
              cellAlignment: pw.Alignment.centerLeft,
            ),

            pw.SizedBox(height: 20),

            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("Subtotal: \$${invoice.subTotal.toStringAsFixed(2)}"),
                    pw.Text("Tax: \$${invoice.tax.toStringAsFixed(2)}"),
                    pw.Text("Discount: \$${invoice.discount.toStringAsFixed(2)}"),
                    pw.SizedBox(height: 5),
                    pw.Text("TOTAL: \$${invoice.total.toStringAsFixed(2)}",
                        style: pw.TextStyle(
                            fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  ],
                )
              ],
            ),

            pw.SizedBox(height: 30),

            pw.Text("Thank you for your business!",
                style: pw.TextStyle(
                    fontSize: 14, fontWeight: pw.FontWeight.bold)),
          ];
        },
      ),
    );

    return pdf.save();
  }
}
