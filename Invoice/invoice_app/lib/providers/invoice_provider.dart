import 'package:flutter/material.dart';
import '../models/invoice.dart';
import '../services/invoice_service.dart';

class InvoiceProvider extends ChangeNotifier {
  List<InvoiceModel> invoices = [];
  bool loading = false;

  Future loadInvoices() async {
    loading = true;
    notifyListeners();

    invoices = await InvoiceService.getInvoices();

    loading = false;
    notifyListeners();
  }

  Future<bool> addInvoice(Map body) async {
    final ok = await InvoiceService.createInvoice(body);
    if (ok) await loadInvoices();
    return ok;
  }

  Future<bool> updateInvoice(String id, Map body) async {
    final ok = await InvoiceService.updateInvoice(id, body);
    if (ok) await loadInvoices();
    return ok;
  }

  Future<bool> markPaid(String id) async {
    final ok = await InvoiceService.markPaid(id);
    if (ok) await loadInvoices();
    return ok;
  }

  Future<bool> deleteInvoice(String id) async {
    final ok = await InvoiceService.deleteInvoice(id);
    if (ok) await loadInvoices();
    return ok;
  }


  int get totalInvoices => invoices.length;

  int get paidInvoices =>
      invoices.where((i) => i.status == "paid").length;

  int get overdueInvoices =>
      invoices.where((i) => i.status == "overdue").length;

  int get draftInvoices =>
      invoices.where((i) => i.status == "draft").length;

  double get totalRevenue => invoices
      .where((i) => i.status == "paid")
      .fold(0.0, (sum, i) => sum + i.total);

  String? filterStatus;
  String? filterClient;
  String? searchQuery;

  Future applyFilters() async {
    loading = true;
    notifyListeners();

    invoices = await InvoiceService.getFilteredInvoices(
      status: filterStatus,
      clientId: filterClient,
      search: searchQuery,
    );

    loading = false;
    notifyListeners();
  }

  void clearFilters() {
    filterStatus = null;
    filterClient = null;
    searchQuery = null;
    notifyListeners();
  }


}
