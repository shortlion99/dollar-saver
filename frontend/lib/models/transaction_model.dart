class Transaction {
  final String category;
  final double amount;
  final DateTime date;
  final String notes;

  Transaction({
    required this.category,
    required this.amount,
    required this.date,
    this.notes = '',
  });
}
