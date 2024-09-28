
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
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTotalExpenses(),
              const SizedBox(height: 16),
              _buildExpenseList(),
              const SizedBox(height: 16),
              _buildRecentTransactions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalExpenses() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Total Expenses',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '\$500',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseList() {
    final data = [
      ExpenseCategory('Food', 200, Colors.blue),
      ExpenseCategory('Transport', 150, Colors.green),
      ExpenseCategory('Utilities', 100, Colors.red),
      ExpenseCategory('Others', 50, Colors.orange),
    ];

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expenses by Category',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...data.map((category) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: category.amount,
                      child: Container(
                        height: 24,
                        decoration: BoxDecoration(
                          color: category.color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${category.name} - \$${category.amount}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTransactionTile('Grocery Shopping', '2024-09-25', -50),
            _buildTransactionTile('Bus Ticket', '2024-09-24', -15),
            _buildTransactionTile('Dinner at Restaurant', '2024-09-23', -30),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(String title, String date, int amount) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('Date: $date'),
        trailing: Text(
          '${amount < 0 ? '' : '+'}\$${amount.abs()}',
          style: TextStyle(color: amount < 0 ? Colors.red : Colors.green),
        ),
      ),
    );
  }
}

class ExpenseCategory {
  final String name;
  final int amount;
  final Color color;

  ExpenseCategory(this.name, this.amount, this.color);
}