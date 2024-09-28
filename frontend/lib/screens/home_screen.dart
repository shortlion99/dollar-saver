import 'package:ai_expense_app/components/budget_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_transaction_screen.dart';
import 'package:ai_expense_app/components/custom_icons.dart';

// Define custom color
const Color customPurple = Color.fromARGB(255, 41, 14, 96); // Custom dark purple shade

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BudgetProvider>(
      builder: (context, budgetProvider, child) {
        return Scaffold(
          body: Column( // Remove SafeArea
            children: [
              _buildHeader(context, budgetProvider),
              _buildToggleButtons(),
              Expanded(
                child: _buildTransactionList(budgetProvider),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, BudgetProvider budgetProvider) {
    return Container(
      padding: EdgeInsets.all(20),
      color: customPurple, // Use custom purple for the header
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.menu, color: Colors.white),
              CircleAvatar(
                backgroundImage: AssetImage('assets/profile_picture.jpg'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'My budget',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          Text(
            '\$${budgetProvider.totalBudget.toStringAsFixed(2)}',
            style: const TextStyle(
                color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text('Today'),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: customPurple, // Use custom purple
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            child: Text('Month'),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: customPurple, // Use custom purple
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(BudgetProvider budgetProvider) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white, // White background for the list
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ListView.builder(
        itemCount: budgetProvider.transactions.length,
        itemBuilder: (context, index) {
          final transaction = budgetProvider.transactions[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Icon(
                  CustomIcons.getIconForCategory(transaction.category),
                  color: Colors.black),
            ),
            title: Text(transaction.category),
            trailing: Text(
              '\$${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(color: customPurple), // Use custom purple
            ),
          );
        },
      ),
    );
  }
}
