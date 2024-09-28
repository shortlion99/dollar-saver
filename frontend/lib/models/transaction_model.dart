
class Transaction {
  final String category;
  final double amount;
  final DateTime date;
  final bool isIncome; // Add this property

  Transaction({
    required this.category,
    required this.amount,
    required this.date,
    required this.isIncome,
  });

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

  // Method to format the date for display
  String formattedDate() {
    return "${date.day}/${date.month}/${date.year}"; // Adjust format as needed
  }
}
