import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/item_provider.dart';
import 'create_item.dart';
import 'edit_item.dart';

class ItemsListScreen extends StatefulWidget {
  const ItemsListScreen({super.key});

  @override
  State<ItemsListScreen> createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ItemProvider>(context, listen: false).loadItems();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Items")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateItemScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.items.isEmpty
              ? const Center(child: Text("No items found"))
              : ListView.builder(
                  itemCount: provider.items.length,
                  itemBuilder: (_, i) {
                    final item = provider.items[i];

                    return ListTile(
                      leading: const Icon(Icons.inventory),
                      title: Text(item.name),
                      subtitle: Text(item.unitPrice != null
                          ? "\$${item.unitPrice!.toStringAsFixed(2)}"
                          : "No price"),
                      trailing: PopupMenuButton(
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: "edit",
                            child: Text("Edit"),
                          ),
                          const PopupMenuItem(
                            value: "delete",
                            child: Text("Delete"),
                          ),
                        ],
                        onSelected: (value) async {
                          if (value == "edit") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditItemScreen(item: item),
                              ),
                            );
                          } else if (value == "delete") {
                            bool ok = await provider.deleteItem(item.id);
                            if (!ok) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Delete failed")),
                              );
                            }
                          }
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
