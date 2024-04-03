class TransactionModel {
  final String address;
  final int amount;
  final String reason;
  final DateTime timestamp;

  TransactionModel({
    required this.address,
    required this.amount,
    required this.reason,
    required this.timestamp,
  });
}
