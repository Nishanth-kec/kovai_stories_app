import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/item_service.dart';

class ItemProvider extends ChangeNotifier {
  List<ItemModel> items = [];
  bool loading = false;

  Future loadItems() async {
    loading = true;
    notifyListeners();

    items = await ItemService.getItems();

    loading = false;
    notifyListeners();
  }

  Future<bool> addItem(Map body) async {
    final ok = await ItemService.createItem(body);
    if (ok) await loadItems();
    return ok;
  }

  Future<bool> updateItem(String id, Map body) async {
    final ok = await ItemService.updateItem(id, body);
    if (ok) await loadItems();
    return ok;
  }

  Future<bool> deleteItem(String id) async {
    final ok = await ItemService.deleteItem(id);
    if (ok) await loadItems();
    return ok;
  }
}
