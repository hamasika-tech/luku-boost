import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AmountChip extends StatelessWidget {
  final int amount;
  final bool selected;
  final ValueChanged<int>? onSelected;

  const AmountChip({
    super.key,
    required this.amount,
    this.selected = false,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final label = 'TZS ${NumberFormat('#,###').format(amount)}';

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected != null ? (_) => onSelected!(amount) : null,
      selectedColor: scheme.primaryContainer,
      backgroundColor: scheme.surfaceContainerHighest,
      labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: selected ? scheme.onPrimaryContainer : scheme.onSurface,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      showCheckmark: false,
    );
  }
}
