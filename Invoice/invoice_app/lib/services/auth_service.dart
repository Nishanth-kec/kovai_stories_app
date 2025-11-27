import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api.dart';

class AuthService {
  static final storage = FlutterSecureStorage();

  static Future<Map?> login(String email, String password) async {
    final res = await http.post(
      Uri.parse(API.login),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"email": email, "password": password}),
    );

    if (res.statusCode == 200) {
      final data = json.decode(res.body);

      await storage.write(key: "token", value: data["token"]);

      return data["user"];
    } else {
      return null;
    }
  }

  static Future<Map?> register(String company, String name, String email, String password) async {
    final res = await http.post(
      Uri.parse(API.register),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "companyName": company,
        "name": name,
        "email": email,
        "password": password
      }),
    );

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      await storage.write(key: "token", value: data["token"]);
      return data["user"];
    } else {
      return null;
    }
  }

  static Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  static Future logout() async {
    await storage.delete(key: "token");
  }
}
