import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/client_provider.dart';
import '../../providers/item_provider.dart';
import '../../providers/invoice_provider.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  String? selectedClient;
  List<Map<String, dynamic>> lines = [];

  final tax = TextEditingController(text: "0");
  final discount = TextEditingController(text: "0");

  bool loading = false;

  double subtotal = 0;
  double total = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<ClientProvider>(context, listen: false).loadClients();
    Provider.of<ItemProvider>(context, listen: false).loadItems();
  }

  void calculateTotals() {
    subtotal = 0;
    for (var l in lines) {
      l["total"] = l["qty"] * l["price"];
      subtotal += l["total"];
    }
    total = subtotal + (double.tryParse(tax.text) ?? 0) - (double.tryParse(discount.text) ?? 0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final clients = Provider.of<ClientProvider>(context).clients;
    final items = Provider.of<ItemProvider>(context).items;
    final invoiceProvider = Provider.of<InvoiceProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Create Invoice")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // Select Client
            DropdownButtonFormField(
              initialValue: selectedClient,
              hint: const Text("Select Client"),
              items: clients
                  .map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.name),
                      ))
                  .toList(),
              onChanged: (val) {
                selectedClient = val;
                setState(() {});
              },
            ),

            const SizedBox(height: 20),

            // Add line item button
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Line Item"),
                onPressed: () {
                  lines.add({
                    "description": "",
                    "qty": 1,
                    "price": 0.0,
                    "total": 0.0,
                  });
                  calculateTotals();
                },
              ),
            ),

            const SizedBox(height: 10),

            // Line items
            Column(
              children: List.generate(lines.length, (i) {
                final line = lines[i];

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        TextField(
                          decoration: const InputDecoration(labelText: "Description"),
                          onChanged: (value) {
                            line["description"] = value;
                          },
                        ),
                        TextField(
                          decoration: const InputDecoration(labelText: "Qty"),
                          keyboardType: TextInputType.number,
                          onChanged: (v) {
                            line["qty"] = int.tryParse(v) ?? 1;
                            calculateTotals();
                          },
                        ),
                        TextField(
                          decoration: const InputDecoration(labelText: "Unit Price"),
                          keyboardType: TextInputType.number,
                          onChanged: (v) {
                            line["price"] =
                                double.tryParse(v) ?? 0;
                            calculateTotals();
                          },
                        ),
                        const SizedBox(height: 8),
                        Text("Line Total: \$${line["total"].toStringAsFixed(2)}"),
                        Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                lines.removeAt(i);
                                calculateTotals();
                              },
                              child: const Text("Remove"),
                            ))
                      ],
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: tax,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Tax"),
              onChanged: (_) => calculateTotals(),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: discount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Discount"),
              onChanged: (_) => calculateTotals(),
            ),

            const SizedBox(height: 20),

            Text("Subtotal: \$${subtotal.toStringAsFixed(2)}"),
            Text("Total: \$${total.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),

            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      if (selectedClient == null || lines.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Client and items required")),
                        );
                        return;
                      }

                      setState(() => loading = true);

                      final ok = await invoiceProvider.addInvoice({
                        "clientId": selectedClient,
                        "items": lines.map((l) => {
                              "description": l["description"],
                              "qty": l["qty"],
                              "unitPrice": l["price"],
                            }).toList(),
                        "tax": double.tryParse(tax.text) ?? 0,
                        "discount": double.tryParse(discount.text) ?? 0,
                      });

                      setState(() => loading = false);

                      if (ok) {
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Failed to save invoice")),
                        );
                      }
                    },
                    child: const Text("Save Invoice"),
                  )
          ],
        ),
      ),
    );
  }
}
