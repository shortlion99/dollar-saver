import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 20),
            const Text(
              'Categorized Expenses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(child: _buildCategoryList()),
            const SizedBox(height: 20),
            _buildBudgetAlert(),
            const SizedBox(height: 20),
            _buildIncomeSummary(),
          ],
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
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
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

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: expense.color, // Color based on category
          child: ListTile(
            title: Text(
              expense.category,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              '\$${expense.amount}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBudgetAlert() {
    const totalExpenses = 1200; // Example total expenses
    const monthlyBudget = 2000;  // Example monthly budget

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: totalExpenses > monthlyBudget ? Colors.lightBlue[200] : Colors.lightGreen[200],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          totalExpenses > monthlyBudget
              ? 'Alert: You have exceeded your budget!'
              : 'You are within your budget.',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildIncomeSummary() {
    final List<Map<String, String>> incomes = [
      {'source': 'Salary', 'amount': '\$2,500'},
      {'source': 'Freelancing', 'amount': '\$800'},
      {'source': 'Investments', 'amount': '\$200'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Income Sources',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: incomes.length,
          itemBuilder: (context, index) {
            final income = incomes[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.pink[200], // Pastel blue color for income summary
              child: ListTile(
                title: Text(
                  income['source']!,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  income['amount']!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ],
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
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 5),
        Text(
          amount,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
