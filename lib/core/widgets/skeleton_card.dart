import 'package:flutter/material.dart';

class SkeletonCard extends StatelessWidget {
  final int lineCount;
  final bool hasLeading;

  const SkeletonCard({
    super.key,
    this.lineCount = 3,
    this.hasLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasLeading) ...[
              _SkeletonBox(size: 48, color: scheme.surfaceContainerHighest),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < lineCount; i++) ...[
                    _SkeletonBox(
                      widthFactor: i == 0 ? 0.7 : 0.45,
                      height: 12,
                      color: scheme.surfaceContainerHighest,
                    ),
                    if (i < lineCount - 1) const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double? size;
  final double? height;
  final double widthFactor;
  final Color color;

  const _SkeletonBox({
    this.size,
    this.height,
    this.widthFactor = 1.0,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final box = Container(
      width: size,
      height: size ?? height ?? 12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );

    if (widthFactor == 1.0) return box;

    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: box,
    );
  }
}
