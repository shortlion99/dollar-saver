import 'package:ai_expense_app/components/budget_provider.dart';
import 'package:ai_expense_app/screens/add_transaction_screen.dart';
import 'package:ai_expense_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScaffold extends StatefulWidget {
  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BudgetProvider>(
      builder: (context, budgetProvider, child) {
        return Scaffold(
          body: _getSelectedScreen(_selectedIndex, budgetProvider),
          bottomNavigationBar: _buildBottomNavBar(),
        );
      },
    );
  }

  Widget _getSelectedScreen(int index, BudgetProvider budgetProvider) {
    switch (index) {
      case 0:
        return HomeScreen(); // Your existing HomeScreen
      case 1:
        return AddTransactionScreen(); // Your Add Transaction Screen
      // case 2:
      //   return DashboardScreen(); // Your Dashboard Screen
      default:
        return HomeScreen();
    }
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.deepPurple, // Dark purple for the nav bar
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () => _onItemTapped(0),
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => _onItemTapped(1),
          ),
          IconButton(
            icon: Icon(Icons.dashboard, color: Colors.white),
            onPressed: () => _onItemTapped(2),
          ),
        ],
      ),
    );
  }
}
