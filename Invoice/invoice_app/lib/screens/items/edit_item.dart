import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/item.dart';
import '../../providers/item_provider.dart';

class EditItemScreen extends StatefulWidget {
  final ItemModel item;

  const EditItemScreen({super.key, required this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  late TextEditingController name;
  late TextEditingController description;
  late TextEditingController unitPrice;
  late TextEditingController sku;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.item.name);
    description = TextEditingController(text: widget.item.description ?? "");
    unitPrice = TextEditingController(
        text: widget.item.unitPrice?.toString() ?? "");
    sku = TextEditingController(text: widget.item.sku ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Item")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: name, decoration: const InputDecoration(labelText: "Item Name")),
              const SizedBox(height: 10),

              TextField(controller: description, decoration: const InputDecoration(labelText: "Description")),
              const SizedBox(height: 10),

              TextField(
                controller: unitPrice,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Unit Price"),
              ),
              const SizedBox(height: 10),

              TextField(controller: sku, decoration: const InputDecoration(labelText: "SKU")),
              const SizedBox(height: 20),

              loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() => loading = true);

                        final ok = await provider.updateItem(
                          widget.item.id,
                          {
                            "name": name.text,
                            "description": description.text,
                            "unitPrice": double.tryParse(unitPrice.text) ?? 0,
                            "sku": sku.text,
                          },
                        );

                        setState(() => loading = false);

                        if (ok) {
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Update failed")),
                          );
                        }
                      },
                      child: const Text("Save Changes"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
