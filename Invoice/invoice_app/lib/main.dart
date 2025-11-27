import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/item_provider.dart';
import 'providers/invoice_provider.dart';
import 'providers/client_provider.dart';
import 'providers/company_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/navigation/main_navigation.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => ClientProvider()),
      ChangeNotifierProvider(create: (_) => ItemProvider()),
      ChangeNotifierProvider(create: (_) => InvoiceProvider()),
      ChangeNotifierProvider(create: (_) => CompanyProvider()..loadCompany()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invoice App',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: Consumer<AuthProvider>(
        builder: (_, auth, __) =>
            auth.isLoggedIn ? const MainNavigation() : const LoginScreen(),
      ),
    );
  }
}
