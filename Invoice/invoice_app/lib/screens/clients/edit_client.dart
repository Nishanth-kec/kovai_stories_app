import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/client.dart';
import '../../providers/client_provider.dart';

class EditClientScreen extends StatefulWidget {
  final ClientModel client;

  const EditClientScreen({super.key, required this.client});

  @override
  State<EditClientScreen> createState() => _EditClientScreenState();
}

class _EditClientScreenState extends State<EditClientScreen> {
  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController address;
  late TextEditingController notes;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.client.name);
    email = TextEditingController(text: widget.client.email ?? "");
    phone = TextEditingController(text: widget.client.phone ?? "");
    address = TextEditingController(text: widget.client.address ?? "");
    notes = TextEditingController(text: widget.client.notes ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClientProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Client")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: name, decoration: const InputDecoration(labelText: "Name")),
              const SizedBox(height: 15),
              TextField(controller: email, decoration: const InputDecoration(labelText: "Email")),
              const SizedBox(height: 15),
              TextField(controller: phone, decoration: const InputDecoration(labelText: "Phone")),
              const SizedBox(height: 15),
              TextField(controller: address, decoration: const InputDecoration(labelText: "Address")),
              const SizedBox(height: 15),
              TextField(controller: notes, decoration: const InputDecoration(labelText: "Notes")),
              const SizedBox(height: 25),

              loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() => loading = true);

                        final ok = await provider.updateClient(
                          widget.client.id,
                          {
                            "name": name.text,
                            "email": email.text,
                            "phone": phone.text,
                            "address": address.text,
                            "notes": notes.text,
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
