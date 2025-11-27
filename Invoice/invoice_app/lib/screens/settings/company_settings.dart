import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/company_provider.dart';

class CompanySettingsScreen extends StatefulWidget {
  const CompanySettingsScreen({super.key});

  @override
  State<CompanySettingsScreen> createState() => _CompanySettingsScreenState();
}

class _CompanySettingsScreenState extends State<CompanySettingsScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final taxNumber = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();

    final company = Provider.of<CompanyProvider>(context, listen: false).company;
    if (company != null) {
      name.text = company.name;
      email.text = company.email ?? "";
      phone.text = company.phone ?? "";
      address.text = company.address ?? "";
      taxNumber.text = company.taxNumber ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CompanyProvider>(context);
    final company = provider.company;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Company Settings"),
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // ------------- LOGO ------------------
                  Center(
                    child: InkWell(
                      onTap: () => _pickLogo(provider),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: company?.logoUrl != null
                            ? NetworkImage(company!.logoUrl!)
                            : null,
                        child: company?.logoUrl == null
                            ? const Icon(Icons.camera_alt, size: 40)
                            : null,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextField(
                    controller: name,
                    decoration: const InputDecoration(labelText: "Company Name"),
                  ),
                  const SizedBox(height: 15),

                  TextField(
                    controller: email,
                    decoration: const InputDecoration(labelText: "Email"),
                  ),
                  const SizedBox(height: 15),

                  TextField(
                    controller: phone,
                    decoration: const InputDecoration(labelText: "Phone"),
                  ),
                  const SizedBox(height: 15),

                  TextField(
                    controller: address,
                    decoration: const InputDecoration(labelText: "Address"),
                  ),
                  const SizedBox(height: 15),

                  TextField(
                    controller: taxNumber,
                    decoration: const InputDecoration(labelText: "Tax/GST Number"),
                  ),

                  const SizedBox(height: 30),

                  loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            setState(() => loading = true);

                            final ok = await provider.updateCompany({
                              "name": name.text,
                              "email": email.text,
                              "phone": phone.text,
                              "address": address.text,
                              "taxNumber": taxNumber.text,
                            });

                            setState(() => loading = false);

                            if (ok) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Updated successfully"),
                                ),
                              );
                            }
                          },
                          child: const Text("Save Changes"),
                        )
                ],
              ),
            ),
    );
  }

  Future _pickLogo(CompanyProvider provider) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final ok = await provider.updateLogo(file.path);

      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Logo updated")),
        );
      }
    }
  }
}
