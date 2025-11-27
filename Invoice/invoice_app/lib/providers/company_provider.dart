import 'dart:io';
import 'package:flutter/material.dart';
import '../models/company.dart';
import '../services/company_service.dart';

class CompanyProvider extends ChangeNotifier {
  CompanyModel? company;
  bool loading = false;

  Future loadCompany() async {
    loading = true;
    notifyListeners();

    company = await CompanyService.getCompany();

    loading = false;
    notifyListeners();
  }

  Future<bool> updateCompany(Map data) async {
    final ok = await CompanyService.updateCompany(data);
    if (ok) await loadCompany();
    return ok;
  }

  Future<bool> updateLogo(String path) async {
    final ok = await CompanyService.uploadLogo(File(path));
    if (ok) await loadCompany();
    return ok;
  }
}
