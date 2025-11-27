import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/client_provider.dart';
import 'create_client.dart';
import 'edit_client.dart';

class ClientsListScreen extends StatefulWidget {
  const ClientsListScreen({super.key});

  @override
  State<ClientsListScreen> createState() => _ClientsListScreenState();
}

class _ClientsListScreenState extends State<ClientsListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ClientProvider>(context, listen: false).loadClients();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClientProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Clients"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateClientScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.clients.length,
              itemBuilder: (_, i) {
                final c = provider.clients[i];

                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(c.name),
                  subtitle: Text(c.email ?? ""),
                  trailing: PopupMenuButton(
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: "edit",
                        child: const Text("Edit"),
                      ),
                      PopupMenuItem(
                        value: "delete",
                        child: const Text("Delete"),
                      ),
                    ],
                    onSelected: (value) async {
                      if (value == "edit") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EditClientScreen(client: c)),
                        );
                      } else if (value == "delete") {
                        bool ok = await provider.deleteClient(c.id);
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
