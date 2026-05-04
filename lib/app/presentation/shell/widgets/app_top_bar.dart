import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:who_is_this_kansen/app/presentation/shell/app_tab.dart';
import 'package:who_is_this_kansen/core/presentation/widgets/surface_buttons.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    required this.selected,
    required this.onSelected,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final AppTab selected;
  final ValueChanged<AppTab> onSelected;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

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

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SurfaceIconButton(
                onPressed: () {
                  showCupertinoModalPopup<void>(
                    context: context,
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
              const SizedBox(width: 8),
              CupertinoSlidingSegmentedControl<AppTab>(
                groupValue: selected,
                backgroundColor: Colors.white.withValues(
                  alpha: isDark ? 0.08 : 0.56,
                ),
                thumbColor: KansenThemeTokens.of(context).segmentThumb,
                children: const {
                  AppTab.quiz: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(CupertinoIcons.question_circle, size: 18),
                  ),
                  AppTab.dex: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(CupertinoIcons.square_grid_2x2, size: 18),
                  ),
                },
                onValueChanged: (value) {
                  if (value != null) onSelected(value);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            t.app.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
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
