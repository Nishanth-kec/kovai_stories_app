import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';
import '../clients/clients_list.dart';
import '../items/items_list.dart';
import '../invoices/invoices_list.dart';
import '../settings/company_settings.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  final screens = const [
    DashboardScreen(),   // index 0
    ClientsListScreen(), // index 1
    ItemsListScreen(),   // index 2
    InvoicesListScreen(), // index 3
    CompanySettingsScreen(), // index 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          setState(() {
            _index = i;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Clients",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: "Items",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: "Invoices",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),

        ],
      ),
    );
  }
}
