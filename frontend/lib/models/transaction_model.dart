class Transaction {
  final String category;
  final double amount;
  final DateTime date;
  final bool isIncome;

  Transaction({
    required this.category,
    required this.amount,
    required this.date,
    required this.isIncome,
  });

  // Getter for formatted date
  String get formattedDate {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  // New getter for a message representation of the transaction
  String get itemAdded {
    return isIncome ? 'Income' : 'Expense';
  }

  // Method to check if the transaction is today
  bool isToday() {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  // Method to check if the transaction is in the current month
  bool isThisMonth() {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  // Method to check if the transaction is in the current year
  bool isThisYear() {
    final now = DateTime.now();
    return date.year == now.year; // Checks if the transaction year matches the current year
  }
}
