import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/api.dart';
import '../models/company.dart';

class CompanyService {
  static final storage = FlutterSecureStorage();

  static Future<Map<String, String>> _headers() async {
    final token = await storage.read(key: "token");
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }

  static Future<CompanyModel?> getCompany() async {
    final res = await http.get(Uri.parse(API.companyMe), headers: await _headers());

    if (res.statusCode == 200) {
      return CompanyModel.fromJson(json.decode(res.body));
    }
    return null;
  }

  static Future<bool> updateCompany(Map body) async {
    final res = await http.put(
      Uri.parse(API.companyMe),
      headers: await _headers(),
      body: json.encode(body),
    );
    return res.statusCode == 200;
  }

  static Future<bool> uploadLogo(File file) async {
    final token = await storage.read(key: "token");
    final uri = Uri.parse(API.companyLogo);

    var req = http.MultipartRequest("POST", uri);
    req.headers["Authorization"] = "Bearer $token";

    req.files.add(await http.MultipartFile.fromPath("logo", file.path));

    final res = await req.send();
    return res.statusCode == 200;
  }
}
