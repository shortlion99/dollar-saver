import 'package:ai_expense_app/components/budget_provider.dart';
import 'package:ai_expense_app/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_transaction_screen.dart';
import 'package:ai_expense_app/screens/categorization_screen.dart';
import 'package:ai_expense_app/components/custom_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedPeriod = 'Today';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Initialize TabController
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BudgetProvider>(
      builder: (context, budgetProvider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Expense Tracker',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeMessage(),
                  const SizedBox(height: 16),
                  _buildTotalExpenses(budgetProvider), // Pass the budgetProvider to this method
                  const SizedBox(height: 16),
                  _buildToggleButtons(),
                  const SizedBox(height: 16),
                  _buildExpenseList(),
                  const SizedBox(height: 16),
                  _buildRecentTransactions(),
                  const SizedBox(height: 16),
                  
                  
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeMessage() {
    return const Text(
      'Welcome to your expense tracker!',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildGraphsSection() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 3,
            blurRadius: 6,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Graphs will be displayed here (Pie Chart)',
          style: TextStyle(color: Colors.grey[700]),
        ),
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _toggleButton('Today'),
          const SizedBox(width: 10),
          _toggleButton('Month'),
          const SizedBox(width: 10),
          _toggleButton('Year'),
        ],
      ),
    );
  }

  Widget _toggleButton(String label) {
    return ElevatedButton(
      child: Text(label, style: TextStyle(color: selectedPeriod == label ? Colors.white : Colors.black)),
      onPressed: () {
        setState(() {
          selectedPeriod = label;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: selectedPeriod == label ? Colors.white : Colors.blueAccent,
        backgroundColor: selectedPeriod == label ? Colors.blueAccent : Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
    );
  }

  Widget _buildTransactionList(BudgetProvider budgetProvider) {
    List<Transaction> filteredTransactions = budgetProvider.transactions.where((transaction) {
      if (selectedPeriod == 'Today') {
        return transaction.isToday();
      } else if (selectedPeriod == 'Month') {
        return transaction.isThisMonth();
      }
      return true; // Return all if no specific filter is selected
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 3,
            blurRadius: 6,
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true, // Prevent overflow
        physics: const NeverScrollableScrollPhysics(), // Disable scrolling in this list
        itemCount: filteredTransactions.length,
        itemBuilder: (context, index) {
          final transaction = filteredTransactions[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Icon(CustomIcons.getIconForCategory(transaction.category),
                  color: Colors.blueAccent),
            ),
            title: Text(transaction.category),
            subtitle: Text(transaction.date.toString()),
            trailing: Text(
              '\$${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              _showEditDeleteOptions(transaction);
            },
          );
        },
      ),
    );
  }

  void _showEditDeleteOptions(Transaction transaction) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Options for ${transaction.category}'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Implement edit functionality
                  Navigator.pop(context);
                },
                child: const Text('Edit'),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<BudgetProvider>(context, listen: false)
                      .removeTransaction(transaction);
                  Navigator.pop(context);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTotalExpenses(BudgetProvider budgetProvider) {
  double totalExpenses = budgetProvider.totalExpenses; // Get the total expenses
  double budget = budgetProvider.budget; // Get the budget

  return Card(
    elevation: 6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align the text to the start
        children: [
          const Text(
            'Total Expenses',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            '\$${totalExpenses.toStringAsFixed(2)}', // Display dynamic total expenses
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
          const SizedBox(height: 20), // Add some space between total expenses and progress indicator
          const Text(
            'Budget vs Expenses',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: budget > 0 ? totalExpenses / budget : 0, // Prevent division by zero
              backgroundColor: Colors.grey[300],
              color: totalExpenses > budget ? Colors.red : Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${totalExpenses.toStringAsFixed(2)} / \$${budget.toStringAsFixed(2)}',
            style: TextStyle(color: totalExpenses > budget ? Colors.red : Colors.black),
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

    return Padding(
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
                    flex: category.amount.toInt(),
                    child: Container(
                      height: 20,
                      color: category.color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${category.name} - \$${category.amount}'),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

Widget _buildRecentTransactions() {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Transactions',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // You can replace this with dynamic data
        ListTile(
          title: Text('Coffee'),
          subtitle: Text('Date: 2024-09-26'),
          trailing: Text('\$4.50'),
        ),
        ListTile(
          title: Text('Taxi'),
          subtitle: Text('Date: 2024-09-25'),
          trailing: Text('\$15.00'),
        ),
      ],
    ),
  );
}


class ExpenseCategory {
  final String name;
  final double amount;
  final Color color;

  ExpenseCategory(this.name, this.amount, this.color);
}
