import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/api.dart';
import '../models/client.dart';

class ClientService {
  static final storage = FlutterSecureStorage();

  // Get JWT token
  static Future<Map<String, String>> _headers() async {
    final token = await storage.read(key: "token");
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  // Fetch all clients
  static Future<List<ClientModel>> getClients() async {
    final res = await http.get(Uri.parse(API.clients), headers: await _headers());

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((c) => ClientModel.fromJson(c)).toList();
    }

    return [];
  }

  // Create client
  static Future<bool> createClient(Map body) async {
    final res = await http.post(
      Uri.parse(API.clients),
      headers: await _headers(),
      body: json.encode(body),
    );

    return res.statusCode == 200;
  }

  // Update client
  static Future<bool> updateClient(String id, Map body) async {
    final res = await http.put(
      Uri.parse("${API.clients}/$id"),
      headers: await _headers(),
      body: json.encode(body),
    );

    return res.statusCode == 200;
  }

  // Delete client
  static Future<bool> deleteClient(String id) async {
    final res = await http.delete(
      Uri.parse("${API.clients}/$id"),
      headers: await _headers(),
    );

    return res.statusCode == 200;
  }
}
