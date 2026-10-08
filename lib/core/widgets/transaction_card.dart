import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/models/transaction.dart';
import 'status_chip.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (statusLabel, statusType) = _status(transaction.status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: transaction.status == TransactionStatus.repaid
                  ? scheme.primaryContainer
                  : scheme.tertiaryContainer,
              foregroundColor: transaction.status == TransactionStatus.repaid
                  ? scheme.onPrimaryContainer
                  : scheme.onTertiaryContainer,
              child: const Icon(Icons.bolt),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TZS ${NumberFormat('#,###').format(transaction.amount)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      StatusChip(label: statusLabel, type: statusType),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Meter ${transaction.meterNumber} · ${DateFormat('MMM d, y').format(transaction.date)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  (String, StatusType) _status(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.repaid:
        return ('Repaid', StatusType.success);
      case TransactionStatus.pending:
        return ('Pending', StatusType.warning);
      case TransactionStatus.failed:
        return ('Failed', StatusType.error);
    }
  }
}
