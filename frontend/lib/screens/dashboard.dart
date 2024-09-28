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
                _buildSummaryCard(context),
                const SizedBox(height: 20),
                const Text(
                  'Expense Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                _buildCategoryList(context),
                const SizedBox(height: 30),
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                RecentTransactions(limit: 6), // Set limit here to show more entries
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
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
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => _editSummaryItem(context, 'Total Expenses', '\$1,200'),
                  child: _SummaryItem(title: 'Total Expenses', amount: '\$1,200'),
                ),
                GestureDetector(
                  onTap: () => _editSummaryItem(context, 'Monthly Budget', '\$2,000'),
                  child: _SummaryItem(title: 'Monthly Budget', amount: '\$2,000'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context) {
    final List<ExpenseCategory> expenses = [
      ExpenseCategory('Food', 200, Colors.pink[200]!, [
        ExpenseItem('Groceries', 50),
        ExpenseItem('Restaurant', 100),
        ExpenseItem('Snacks', 50),
      ]),
      ExpenseCategory('Transport', 150, Colors.lightGreen[200]!, [
        ExpenseItem('Bus', 50),
        ExpenseItem('Taxi', 100),
      ]),
      ExpenseCategory('Utilities', 100, Colors.orange[200]!, [
        ExpenseItem('Electricity', 40),
        ExpenseItem('Water', 30),
        ExpenseItem('Internet', 30),
      ]),
      ExpenseCategory('Others', 50, Colors.blue[200]!, [
        ExpenseItem('Gifts', 30),
        ExpenseItem('Miscellaneous', 20),
      ]),
    ];

    return Column(
      children: expenses.map((expense) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: expense.color,
          child: ExpansionTile(
            title: Text(
              expense.category,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            trailing: GestureDetector(
              onTap: () => _editCategory(context, expense),
              child: Text(
                '\$${expense.amount}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            children: expense.items.map((item) {
              return ListTile(
                title: GestureDetector(
                  onTap: () => _editExpense(context, item),
                  child: Text(
                    item.name,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                trailing: Text(
                  '\$${item.amount}',
                  style: const TextStyle(color: Colors.white70),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  void _editSummaryItem(BuildContext context, String title, String currentAmount) {
    // Implement your editing logic here (e.g., show a dialog to update the amount)
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            decoration: InputDecoration(labelText: 'Amount'),
            controller: TextEditingController(text: currentAmount),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Save changes and update the UI
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _editCategory(BuildContext context, ExpenseCategory category) {
    // Implement your editing logic for categories here
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit ${category.category}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Category Name'),
                controller: TextEditingController(text: category.category),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: TextEditingController(text: '${category.amount}'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Save changes and update the UI
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _editExpense(BuildContext context, ExpenseItem item) {
    // Implement your editing logic for individual expenses here
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit ${item.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Expense Name'),
                controller: TextEditingController(text: item.name),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: TextEditingController(text: '${item.amount}'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Save changes and update the UI
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class ExpenseCategory {
  final String category;
  final double amount;
  final Color color;
  final List<ExpenseItem> items;

  ExpenseCategory(this.category, this.amount, this.color, this.items);
}

class ExpenseItem {
  final String name;
  final double amount;

  ExpenseItem(this.name, this.amount);
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
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }
}
