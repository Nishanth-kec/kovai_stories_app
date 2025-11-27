import 'package:flutter/material.dart';
import '../models/client.dart';
import '../services/client_service.dart';

class ClientProvider extends ChangeNotifier {
  List<ClientModel> clients = [];

  bool loading = false;

  Future loadClients() async {
    loading = true;
    notifyListeners();

    clients = await ClientService.getClients();

    loading = false;
    notifyListeners();
  }

  Future<bool> addClient(Map body) async {
    final ok = await ClientService.createClient(body);
    if (ok) await loadClients();
    return ok;
  }

  Future<bool> updateClient(String id, Map body) async {
    final ok = await ClientService.updateClient(id, body);
    if (ok) await loadClients();
    return ok;
  }

  Future<bool> deleteClient(String id) async {
    final ok = await ClientService.deleteClient(id);
    if (ok) await loadClients();
    return ok;
  }
}
