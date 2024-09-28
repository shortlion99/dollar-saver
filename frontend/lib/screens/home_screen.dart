import 'package:ai_expense_app/components/budget_provider.dart';
import 'package:ai_expense_app/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_transaction_screen.dart';
import 'package:ai_expense_app/screens/categorization_screen.dart';
import 'package:ai_expense_app/components/custom_icons.dart';
import 'package:ai_expense_app/widgets/app_logo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedPeriod = 'Today';

  // Define text styles
  TextStyle titleStyle = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  TextStyle subtitleStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  TextStyle bodyStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  TextStyle largeAmountStyle = const TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: Colors.purple,
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

@override
Widget build(BuildContext context) {
  return Consumer<BudgetProvider>(
    builder: (context, budgetProvider, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 30.0), // Reduce the top padding for the logo
              child: AppLogo(size: 120), // Add the logo here
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTotalExpenses(budgetProvider),
                      const SizedBox(height: 16),
                      _buildToggleButtons(),
                      _buildExpenseList(),
                      const SizedBox(height: 10),
                      _buildRecentTransactions(),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
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
      child: Text(label,
          style: TextStyle(
              color: selectedPeriod == label ? Colors.white : Colors.black)),
      onPressed: () {
        setState(() {
          selectedPeriod = label;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor:
            selectedPeriod == label ? Colors.white : Colors.blueAccent,
        backgroundColor: selectedPeriod == label ? Colors.pinkAccent : Colors.pink[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
    );
  }

  Widget _buildTransactionList(BudgetProvider budgetProvider) {
    List<Transaction> filteredTransactions =
        budgetProvider.transactions.where((transaction) {
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
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredTransactions.length,
        itemBuilder: (context, index) {
          final transaction = filteredTransactions[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.pink[100],
                child: Icon(
                    CustomIcons.getIconForCategory(transaction.category),
                    color: Colors.pinkAccent),
              ),
              title: Text(transaction.category, style: bodyStyle),
              subtitle: Text(transaction.date.toString(), style: bodyStyle),
              trailing: Text(
                '\$${transaction.amount.toStringAsFixed(2)}',
                style: bodyStyle,
              ),
              
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalExpenses(BudgetProvider budgetProvider) {
  double totalExpenses = budgetProvider.totalExpenses;
  double budget = budgetProvider.budget;

  return Card(
    elevation: 6,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)), // Rounded corners
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget vs Expenses',
            style: titleStyle,
          ),
          const SizedBox(height: 10),
          // Add a Container to customize the progress bar
          Container(
            height: 14, // Adjust height to make it thicker
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // More rounded corners
              child: LinearProgressIndicator(
                value: budget > 0 ? totalExpenses / budget : 0,
                backgroundColor: Colors.grey[300],
                color: totalExpenses > budget ? Colors.grey : Colors.pinkAccent,
              ),
            ),
          ),
          const SizedBox(height: 4), // Reduce the space between progress bar and text
          Text(
            '\$${totalExpenses.toStringAsFixed(2)} / \$${budget.toStringAsFixed(2)}',
            style: TextStyle(
                color: totalExpenses > budget ? Colors.red : Colors.black),
          ),
        ],
      ),
    ),
  );
}
  Widget _buildExpenseList() {
    final data = [
      ExpenseCategory('Food', 200, Colors.pink[200]!),
      ExpenseCategory('Transport', 150, Colors.lightGreen[200]!),
      ExpenseCategory('Utilities', 100, Colors.orange[200]!),
      ExpenseCategory('Others', 50, Colors.blue[200]!),
    ];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expenses by Category',
            style: titleStyle,
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
                      decoration: BoxDecoration(
                        color: category.color,
                        borderRadius: BorderRadius.circular(10), // Rounded corners for expense bars
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${category.name} - \$${category.amount}', style: bodyStyle),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  
  Widget _buildRecentTransactions() {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Transactions',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // You can replace this with dynamic data
          ListTile(
            title: Text('Coffee'),
            subtitle: Text('Date: 2024-09-26'),
            trailing: Text('\$4.50'),
          ),
          ListTile(
            title: Text('Groceries'),
            subtitle: Text('Date: 2024-09-25'),
            trailing: Text('\$30.00'),
          ),
          ListTile(
            title: Text('Transport'),
            subtitle: Text('Date: 2024-09-24'),
            trailing: Text('\$15.00'),
          ),
        ],
      ),
    );
  }
}

class ExpenseCategory {
  final String name;
  final double amount;
  final Color color;

  ExpenseCategory(this.name, this.amount, this.color);
}