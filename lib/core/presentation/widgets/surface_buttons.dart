import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';

class SurfaceActionButton extends StatelessWidget {
  const SurfaceActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  final VoidCallback onPressed;
  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = KansenThemeTokens.of(context);

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(48, 48),
      borderRadius: BorderRadius.circular(8),
      onPressed: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.72),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: tokens.hairline.withValues(alpha: 0.12)),
        ),
        child: SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconTheme(
                data: IconThemeData(color: tokens.ink, size: 20),
                child: icon,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: tokens.ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SurfaceIconButton extends StatelessWidget {
  const SurfaceIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.tooltip,
    this.size = 48,
  });

  final VoidCallback onPressed;
  final Widget icon;
  final String tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = KansenThemeTokens.of(context);

    return Tooltip(
      message: tooltip,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size(size, size),
        borderRadius: BorderRadius.circular(8),
        onPressed: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: isDark ? 0.1 : 0.68),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: tokens.hairline.withValues(alpha: 0.12)),
          ),
          child: SizedBox.square(
            dimension: size,
            child: IconTheme(
              data: IconThemeData(color: tokens.ink, size: size * 0.4),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}
