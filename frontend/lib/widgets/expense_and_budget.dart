import 'package:flutter/material.dart';
import 'package:ai_expense_app/components/budget_provider.dart';

Widget buildTotalExpenses(BudgetProvider budgetProvider, TextStyle titleStyle) {
  double totalExpenses = budgetProvider.totalExpenses;
  double budget = budgetProvider.budget;

  return Card(
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20), // Rounded corners
    ),
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
          // Customize the progress bar
          Container(
            height: 14, // Adjust height to make it thicker
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // More rounded corners
              child: LinearProgressIndicator(
                value: budget > 0 ? totalExpenses / budget : 0,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                    totalExpenses > budget ? Colors.red : Colors.pinkAccent),
              ),
            ),
          ),
          const SizedBox(height: 4), // Reduce the space between progress bar and text
          Text(
            '\$${totalExpenses.toStringAsFixed(2)} / \$${budget.toStringAsFixed(2)}',
            style: TextStyle(
              color: totalExpenses > budget ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}
