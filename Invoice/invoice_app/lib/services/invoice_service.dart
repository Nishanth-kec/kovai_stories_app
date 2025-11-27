import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api.dart';
import '../models/invoice.dart';

class InvoiceService {
  static final storage = FlutterSecureStorage();

  static Future<Map<String, String>> _headers() async {
    final token = await storage.read(key: "token");
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  static Future<List<InvoiceModel>> getInvoices() async {
    final res = await http.get(Uri.parse(API.invoices), headers: await _headers());

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((x) => InvoiceModel.fromJson(x)).toList();
    }

    return [];
  }

  static Future<bool> createInvoice(Map body) async {
    final res = await http.post(
      Uri.parse(API.invoices),
      headers: await _headers(),
      body: json.encode(body),
    );
    return res.statusCode == 200;
  }

  static Future<bool> updateInvoice(String id, Map body) async {
    final res = await http.put(
      Uri.parse("${API.invoices}/$id"),
      headers: await _headers(),
      body: json.encode(body),
    );
    return res.statusCode == 200;
  }

  static Future<bool> markPaid(String id) async {
    final res = await http.patch(
      Uri.parse("${API.invoices}/$id/status"),
      headers: await _headers(),
      body: json.encode({"status": "paid"}),
    );
    return res.statusCode == 200;
  }

  static Future<bool> deleteInvoice(String id) async {
    final res = await http.delete(
      Uri.parse("${API.invoices}/$id"),
      headers: await _headers(),
      );
      return res.statusCode == 200;
    }

    static Future<List<InvoiceModel>> getFilteredInvoices({
    String? status,
    String? clientId,
    String? search,
  }) async {
    final queryParams = {
      if (status != null && status.isNotEmpty) "status": status,
      if (clientId != null && clientId.isNotEmpty) "clientId": clientId,
      if (search != null && search.isNotEmpty) "search": search,
    };

    final uri = Uri.parse(API.invoices).replace(queryParameters: queryParams);

    final res = await http.get(uri, headers: await _headers());

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((i) => InvoiceModel.fromJson(i)).toList();
    }

    return [];
  }

}
