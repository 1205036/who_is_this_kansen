import 'package:flutter/material.dart';

class RarityEdge extends StatelessWidget {
  const RarityEdge({super.key, required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: isDark ? 0.22 : 0.16),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: const SizedBox(width: 3.5),
    );
  }
}
