import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/api.dart';
import '../models/item.dart';

class ItemService {
  static final storage = FlutterSecureStorage();

  static Future<Map<String, String>> _headers() async {
    final token = await storage.read(key: "token");
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  static Future<List<ItemModel>> getItems() async {
    final res = await http.get(Uri.parse(API.items), headers: await _headers());

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((x) => ItemModel.fromJson(x)).toList();
    }
    return [];
  }

  static Future<bool> createItem(Map body) async {
    final res = await http.post(
      Uri.parse(API.items),
      headers: await _headers(),
      body: json.encode(body),
    );
    return res.statusCode == 200;
  }

  static Future<bool> updateItem(String id, Map body) async {
    final res = await http.put(
      Uri.parse("${API.items}/$id"),
      headers: await _headers(),
      body: json.encode(body),
    );
    return res.statusCode == 200;
  }

  static Future<bool> deleteItem(String id) async {
    final res = await http.delete(
      Uri.parse("${API.items}/$id"),
      headers: await _headers(),
    );
    return res.statusCode == 200;
  }
}
