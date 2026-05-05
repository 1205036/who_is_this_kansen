import 'package:flutter/material.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';

class LandingModeButton extends StatefulWidget {
  const LandingModeButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  State<LandingModeButton> createState() => _LandingModeButtonState();
}

class _LandingModeButtonState extends State<LandingModeButton> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = KansenThemeTokens.of(context);
    final primary = Theme.of(context).colorScheme.primary;
    final textColor = tokens.ink.withValues(alpha: enabled ? 0.94 : 0.38);
    final activeGradient = [
      Color.lerp(tokens.cardSurface, primary, isDark ? 0.22 : 0.12)!,
      Color.lerp(tokens.cardSurface, primary, isDark ? 0.12 : 0.24)!,
    ];
    final inactiveGradient = [
      tokens.cardSurface.withValues(alpha: 0.46),
      tokens.cardSurface.withValues(alpha: 0.22),
    ];

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
      onTap: enabled
          ? () {
              setState(() => _pressed = false);
              widget.onPressed?.call();
            }
          : null,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: enabled ? activeGradient : inactiveGradient,
            ),
            border: Border.all(
              color: enabled
                  ? primary.withValues(alpha: isDark ? 0.42 : 0.28)
                  : tokens.hairline.withValues(alpha: 0.12),
              width: 1.2,
            ),
            boxShadow: [
              if (enabled)
                BoxShadow(
                  color: primary.withValues(alpha: isDark ? 0.22 : 0.14),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
            ],
          ),
          child: SizedBox(
            width: 260,
            height: 48,
            child: Stack(
              children: [
                Positioned(
                  left: 12,
                  right: 12,
                  top: 6,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: Colors.white.withValues(
                        alpha: enabled ? (isDark ? 0.16 : 0.42) : 0.1,
                      ),
                    ),
                    child: const SizedBox(height: 11),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              widget.label.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(
                              alpha: enabled ? (isDark ? 0.16 : 0.52) : 0.08,
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(
                                alpha: enabled ? 0.38 : 0.12,
                              ),
                            ),
                          ),
                          child: SizedBox.square(
                            dimension: 30,
                            child: Icon(
                              widget.icon,
                              color: textColor,
                              size: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
