import 'package:ai_expense_app/components/budget_provider.dart';
import 'package:ai_expense_app/screens/add_transaction_screen.dart';
import 'package:ai_expense_app/screens/home_screen.dart';
import 'package:ai_expense_app/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_expense_app/components/custom_icons.dart';

// Define custom color
const Color customPurple = Color.fromARGB(255, 41, 14, 96); // Custom dark purple shade

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

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
          backgroundColor: Colors.white,
          body: _getSelectedScreen(_selectedIndex, budgetProvider),
          bottomNavigationBar: _buildBottomNavBar(),
        );
      },
    );
  }

  Widget _getSelectedScreen(int index, BudgetProvider budgetProvider) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return AddTransactionScreen();
      case 2:
        return DashboardScreen();
      default:
        return HomeScreen();
    }
  }

  Widget _buildBottomNavBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(icon: Icons.home, index: 0),
          _buildNavItem(icon: Icons.add, index: 1), // Add button with circle
          _buildNavItem(icon: Icons.dashboard, index: 2),
        ],
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index}) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (index == 1) // Only for the Add button
            Container(
              width: 50, // Set the width of the circle
              height: 50, // Set the height of the circle
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.pink, // Circle color
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white, // Icon color
                  size: 28,
                ),
              ),
            )
          else
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.grey,
              size: isSelected ? 35 : 28,
            ),
          SizedBox(height: 4),
          Container(
            height: 4,
            color: isSelected ? Colors.grey : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
