import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/invoice_provider.dart';
import '../../providers/client_provider.dart';
import 'create_invoice.dart';
import 'invoice_detail.dart';

class InvoicesListScreen extends StatefulWidget {
  const InvoicesListScreen({super.key});

  @override
  State<InvoicesListScreen> createState() => _InvoicesListScreenState();
}

class _InvoicesListScreenState extends State<InvoicesListScreen> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<InvoiceProvider>(context, listen: false).loadInvoices();
    Provider.of<ClientProvider>(context, listen: false).loadClients();
  }

  @override
  Widget build(BuildContext context) {
    final invoiceProvider = Provider.of<InvoiceProvider>(context);
    final clientProvider = Provider.of<ClientProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoices"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              invoiceProvider.clearFilters();
              invoiceProvider.loadInvoices();
              searchController.clear();
            },
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateInvoiceScreen()),
        ),
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search invoice number...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) {
                invoiceProvider.searchQuery = value;
                invoiceProvider.applyFilters();
              },
            ),
          ),

          // FILTERS ROW
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                // STATUS FILTER
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: "Status"),
                    initialValue: invoiceProvider.filterStatus,
                    items: const [
                      DropdownMenuItem(value: null, child: Text("All")),
                      DropdownMenuItem(value: "paid", child: Text("Paid")),
                      DropdownMenuItem(value: "draft", child: Text("Draft")),
                      DropdownMenuItem(value: "sent", child: Text("Sent")),
                      DropdownMenuItem(value: "overdue", child: Text("Overdue")),
                    ],
                    onChanged: (val) {
                      invoiceProvider.filterStatus = val;
                      invoiceProvider.applyFilters();
                    },
                  ),
                ),

                const SizedBox(width: 10),

                // CLIENT FILTER
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: "Client"),
                    initialValue: invoiceProvider.filterClient,
                    items: [
                      const DropdownMenuItem(value: null, child: Text("All")),
                      ...clientProvider.clients.map(
                        (c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(c.name),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      invoiceProvider.filterClient = val;
                      invoiceProvider.applyFilters();
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // LIST LOADING OR CONTENT
          Expanded(
            child: invoiceProvider.loading
                ? const Center(child: CircularProgressIndicator())
                : invoiceProvider.invoices.isEmpty
                    ? const Center(child: Text("No invoices found"))
                    : ListView.builder(
                        itemCount: invoiceProvider.invoices.length,
                        itemBuilder: (_, i) {
                          final inv = invoiceProvider.invoices[i];

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: ListTile(
                              leading: const Icon(Icons.receipt_long),
                              title: Text("Invoice #${inv.number}"),
                              subtitle: Text("Total: \$${inv.total.toStringAsFixed(2)}"),
                              trailing: Text(inv.status.toUpperCase()),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => InvoiceDetailScreen(invoice: inv),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          )
        ],
      ),
    );
  }
}
