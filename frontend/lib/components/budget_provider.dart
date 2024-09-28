import 'package:ai_expense_app/models/transaction_model.dart';
import 'package:flutter/foundation.dart';

class BudgetProvider with ChangeNotifier {
  // Sample transactions for initial data
  List<Transaction> _transactions = [
    Transaction(category: 'Electricity', amount: 60.00, date: DateTime(2020, 5, 18), isIncome: false),
    Transaction(category: 'Home', amount: 23.50, date: DateTime(2020, 5, 18), isIncome: false),
    Transaction(category: 'Food & Drink', amount: 150.00, date: DateTime(2020, 5, 18), isIncome: false),
    Transaction(category: 'Pet Food', amount: 36.50, date: DateTime(2020, 5, 18), isIncome: false),
    // Add income transactions as needed
    // Transaction(category: 'Salary', amount: 3000.00, date: DateTime(2020, 5, 18), isIncome: true),
  ];

  // Current budget amount
  double _budget = 5430.60; // This could be dynamic based on income/expenses

  // Getters
  List<Transaction> get transactions => _transactions;

  double get budget => _budget; // Getter for budget

  double get totalIncome {
    return _transactions.fold(0, (sum, transaction) => sum + (transaction.isIncome ? transaction.amount : 0));
  }

  double get totalExpenses {
    return _transactions.fold(0, (sum, transaction) => sum + (!transaction.isIncome ? transaction.amount : 0));
  }

  // Add a new transaction
  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners(); // Notify listeners about the change
  }

  // Remove a specified transaction
  void removeTransaction(Transaction transaction) {
    _transactions.remove(transaction); // Remove the specified transaction
    notifyListeners(); // Notify listeners about the change
  }

  // Calculate total spending by category
  Map<String, double> calculateCategorySpending() {
    Map<String, double> categoryTotals = {};

    for (var transaction in _transactions) {
      // Check if the category already exists in the map
      if (categoryTotals.containsKey(transaction.category)) {
        // If it exists, add the amount; if null, treat it as 0.0
        categoryTotals[transaction.category] = (categoryTotals[transaction.category] ?? 0.0) + transaction.amount;
      } else {
        // If it doesn't exist, initialize it with the transaction amount
        categoryTotals[transaction.category] = transaction.amount;
      }
    }

    return categoryTotals; // Return the map of category totals
  }
}
