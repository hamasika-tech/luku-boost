import 'package:get/get.dart';
import '../../domain/models/transaction.dart';

class HomeController extends GetxController {
  final outstandingAmount = 12500.obs;
  final limitAmount = 35000.obs;
  final totalTokens = 14.obs;
  final monthlyTokens = 2.obs;
  final dueDays = 6.obs;

  final trendData = <double>[50, 42, 46, 28, 34, 14, 20, 6].obs;
  final trendGrowth = '+18%'.obs;

  final transactions = <Transaction>[
    Transaction(
      amount: 5000,
      meterNumber: '•••• 4821',
      date: DateTime(2026, 7, 14),
      status: TransactionStatus.repaid,
    ),
    Transaction(
      amount: 7500,
      meterNumber: '•••• 4821',
      date: DateTime(2026, 7, 9),
      status: TransactionStatus.pending,
    ),
  ].obs;

  double get limitUsedRatio {
    final limit = limitAmount.value;
    if (limit == 0) return 0;
    return outstandingAmount.value / limit;
  }
}
