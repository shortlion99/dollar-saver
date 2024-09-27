import 'package:ai_expense_app/models/transaction_model.dart';
import 'package:flutter/foundation.dart';

class BudgetProvider with ChangeNotifier {
  List<Transaction> _transactions = [
    Transaction(category: 'Electricity', amount: 60.00, date: DateTime(2020, 5, 18)),
    Transaction(category: 'Home', amount: 23.50, date: DateTime(2020, 5, 18)),
    Transaction(category: 'Food & Drink', amount: 150.00, date: DateTime(2020, 5, 18)),
    Transaction(category: 'Pet Food', amount: 36.50, date: DateTime(2020, 5, 18)),
  ];

  List<Transaction> get transactions => _transactions;

  double get totalBudget => 5430.60;

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

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

  return categoryTotals;
}

}
