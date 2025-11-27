import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoggedIn = false;
  Map? user;

  Future<bool> login(String email, String password) async {
    user = await AuthService.login(email, password);
    isLoggedIn = user != null;
    notifyListeners();
    return isLoggedIn;
  }

  Future<bool> register(String company, String name, String email, String password) async {
    user = await AuthService.register(company, name, email, password);
    isLoggedIn = user != null;
    notifyListeners();
    return isLoggedIn;
  }

  void logout() {
    AuthService.logout();
    isLoggedIn = false;
    user = null;
    notifyListeners();
  }
}
