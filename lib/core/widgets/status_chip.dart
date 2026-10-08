import 'package:flutter/material.dart';

enum StatusType { success, warning, error, info }

class StatusChip extends StatelessWidget {
  final String label;
  final StatusType type;

  const StatusChip({
    super.key,
    required this.label,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (bg, fg) = _colors(scheme);

    return Chip(
      label: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: bg,
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }

  (Color, Color) _colors(ColorScheme scheme) {
    switch (type) {
      case StatusType.success:
        return (scheme.primaryContainer, scheme.onPrimaryContainer);
      case StatusType.warning:
        return (scheme.tertiaryContainer, scheme.onTertiaryContainer);
      case StatusType.error:
        return (scheme.errorContainer, scheme.onErrorContainer);
      case StatusType.info:
        return (scheme.secondaryContainer, scheme.onSecondaryContainer);
    }
  }
}
