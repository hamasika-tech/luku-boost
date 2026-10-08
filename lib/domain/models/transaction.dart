enum TransactionStatus { repaid, pending, failed }

class Transaction {
  final int amount;
  final String meterNumber;
  final DateTime date;
  final TransactionStatus status;

  const Transaction({
    required this.amount,
    required this.meterNumber,
    required this.date,
    required this.status,
  });
}
