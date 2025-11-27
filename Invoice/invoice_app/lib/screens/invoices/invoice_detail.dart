import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/invoice.dart';
import '../../providers/invoice_provider.dart';

import 'package:printing/printing.dart';
import '../../services/pdf_service.dart';
import '../../providers/client_provider.dart';


class InvoiceDetailScreen extends StatelessWidget {
  final InvoiceModel invoice;

  const InvoiceDetailScreen({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final invoiceProvider = Provider.of<InvoiceProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Invoice #${invoice.number}")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Status: ${invoice.status}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Total: \$${invoice.total.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            const Text("Items:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: invoice.items
                    .map((i) => ListTile(
                          title: Text(i.description),
                          subtitle: Text("Qty: ${i.qty} × \$${i.unitPrice}"),
                          trailing: Text("\$${i.total.toStringAsFixed(2)}"),
                        ))
                    .toList(),
              ),
            ),

            if (invoice.status != "paid")
              ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Download PDF"),
                onPressed: () async {
                  final clientProvider = Provider.of<ClientProvider>(context, listen: false);
                  final client = clientProvider.clients
                      .firstWhere((c) => c.id == invoice.clientId);

                  final pdfBytes = await PdfService.generateInvoicePdf(
                    invoice: invoice,
                    client: client,
                    companyName: "YOUR COMPANY NAME", // optional dynamic
                  );

                  await Printing.layoutPdf(
                    onLayout: (format) async => pdfBytes,
                  );
                },
              ),

          ],
        ),
      ),
    );
  }
}
