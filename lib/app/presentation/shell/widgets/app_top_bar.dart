import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:who_is_this_kansen/core/presentation/widgets/surface_buttons.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.onHome,
    required this.showHome,
    this.title,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final VoidCallback onHome;
  final bool showHome;

  // Optional context label rendered between the home and theme buttons.
  // Used to surface things like the active quiz mode/difficulty or the
  // "Dex" label so individual screens don't need to draw their own header.
  final String? title;

  IconData get themeIcon {
    return switch (themeMode) {
      ThemeMode.light => CupertinoIcons.sun_max,
      ThemeMode.dark => CupertinoIcons.moon,
      ThemeMode.system => CupertinoIcons.device_phone_portrait,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = KansenThemeTokens.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedOpacity(
                opacity: showHome ? 1 : 0,
                duration: const Duration(milliseconds: 180),
                child: IgnorePointer(
                  ignoring: !showHome,
                  child: SurfaceIconButton(
                    onPressed: onHome,
                    icon: const Icon(CupertinoIcons.house_fill),
                    tooltip: t.topBar.homeTooltip,
                    size: 32,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: title == null
                        ? const SizedBox.shrink(
                            key: ValueKey('top-bar-title-empty'),
                          )
                        : Text(
                            title!,
                            key: ValueKey('top-bar-title-$title'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: tokens.ink.withValues(alpha: 0.86),
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                  ),
                ),
              ),
              SurfaceIconButton(
                onPressed: () {
                  showCupertinoModalPopup<void>(
                    context: context,
                    barrierColor: Colors.black.withValues(
                      alpha: isDark ? 0.64 : 0.46,
                    ),
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    builder: (context) {
                      return CupertinoActionSheet(
                        title: Text(t.topBar.appearance),
                        actions: [
                          ThemeAction(
                            label: t.topBar.themeSystem,
                            icon: CupertinoIcons.device_phone_portrait,
                            selected: themeMode == ThemeMode.system,
                            onPressed: () {
                              onThemeModeChanged(ThemeMode.system);
                              Navigator.of(context).pop();
                            },
                          ),
                          ThemeAction(
                            label: t.topBar.themeLight,
                            icon: CupertinoIcons.sun_max,
                            selected: themeMode == ThemeMode.light,
                            onPressed: () {
                              onThemeModeChanged(ThemeMode.light);
                              Navigator.of(context).pop();
                            },
                          ),
                          ThemeAction(
                            label: t.topBar.themeDark,
                            icon: CupertinoIcons.moon,
                            selected: themeMode == ThemeMode.dark,
                            onPressed: () {
                              onThemeModeChanged(ThemeMode.dark);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(t.topBar.cancel),
                        ),
                      );
                    },
                  );
                },
                icon: Icon(themeIcon),
                tooltip: t.topBar.appearanceTooltip,
                size: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ThemeAction extends StatelessWidget {
  const ThemeAction({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheetAction(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
          if (selected) ...[
            const SizedBox(width: 8),
            const Icon(CupertinoIcons.check_mark, size: 17),
          ],
        ],
      ),
    );
  }
}
