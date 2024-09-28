import 'package:flutter/material.dart';
import 'package:ai_expense_app/widgets/recent_transactions.dart';
import 'package:provider/provider.dart';
import 'package:ai_expense_app/components/budget_provider.dart'; // Adjust this import as necessary

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const TextStyle titleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    final budgetProvider = Provider.of<BudgetProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: titleStyle),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(),
                const SizedBox(height: 30),
                const Text(
                  'Expense Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                _buildCategoryList(),
                const SizedBox(height: 30),
                RecentTransactions(limit: 6), // Set limit here to show more entries
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SummaryItem(title: 'Total Expenses', amount: '\$1,200'),
                _SummaryItem(title: 'Monthly Budget', amount: '\$2,000'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    final List<ExpenseCategory> expenses = [
      ExpenseCategory('Food', 200, Colors.pink[200]!),
      ExpenseCategory('Transport', 150, Colors.lightGreen[200]!),
      ExpenseCategory('Utilities', 100, Colors.orange[200]!),
      ExpenseCategory('Others', 50, Colors.blue[200]!),
    ];

    return Column(
      children: expenses.map((expense) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: expense.color,
          child: ListTile(
            title: Text(
              expense.category,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              '\$${expense.amount}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class ExpenseCategory {
  final String category;
  final double amount;
  final Color color;

  ExpenseCategory(this.category, this.amount, this.color);
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String amount;

  const _SummaryItem({required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
