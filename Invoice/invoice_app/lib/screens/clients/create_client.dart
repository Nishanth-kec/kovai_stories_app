import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/client_provider.dart';

class CreateClientScreen extends StatefulWidget {
  const CreateClientScreen({super.key});

  @override
  State<CreateClientScreen> createState() => _CreateClientScreenState();
}

class _CreateClientScreenState extends State<CreateClientScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final notes = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClientProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Client")),
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
                        if (name.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Name is required")),
                          );
                          return;
                        }

                        setState(() => loading = true);

                        final ok = await provider.addClient({
                          "name": name.text,
                          "email": email.text,
                          "phone": phone.text,
                          "address": address.text,
                          "notes": notes.text,
                        });

                        setState(() => loading = false);

                        if (ok) {
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Failed to add client")),
                          );
                        }
                      },
                      child: const Text("Save"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
