import 'package:flutter/material.dart';

/// Material 3 spacing and shape constants.
class AppRadius {
  AppRadius._();
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double pill = 999;
}

class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double xxxxl = 40;
}

/// Minimal, low-opacity elevation used sparingly for the hero card.
class AppShadows {
  AppShadows._();

  static List<BoxShadow> hero(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shadowColor = isDark ? Colors.black : const Color(0xFF132420);
    return [
      BoxShadow(
        color: shadowColor.withValues(alpha: isDark ? 0.35 : 0.08),
        blurRadius: 24,
        offset: const Offset(0, 10),
      ),
    ];
  }
}
