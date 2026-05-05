import 'package:flutter/cupertino.dart';
import 'package:who_is_this_kansen/app/presentation/shell/widgets/landing_mode_button.dart';
import 'package:who_is_this_kansen/app/presentation/shell/widgets/landing_title_art.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({
    super.key,
    required this.showDiscovery,
    required this.onDiscovery,
    required this.onRandom,
    required this.onDex,
  });

  final bool showDiscovery;
  final VoidCallback onDiscovery;
  final VoidCallback onRandom;
  final VoidCallback onDex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 34),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: [
                SizedBox(width: constraints.maxWidth, child: LandingTitleArt()),
                Padding(
                  padding: const EdgeInsets.only(top: 260),
                  child: Column(
                    children: [
                      if (showDiscovery) ...[
                        LandingModeButton(
                          key: const ValueKey('landing-discovery-button'),
                          label: t.quiz.modeDiscovery,
                          icon: CupertinoIcons.play_fill,
                          onPressed: onDiscovery,
                        ),
                        const SizedBox(height: 16),
                      ],
                      LandingModeButton(
                        key: const ValueKey('landing-random-button'),
                        label: t.quiz.modeRandom,
                        icon: CupertinoIcons.shuffle,
                        onPressed: onRandom,
                      ),
                      const SizedBox(height: 16),
                      LandingModeButton(
                        key: const ValueKey('landing-dex-button'),
                        label: t.quiz.modeDex,
                        icon: CupertinoIcons.square_grid_2x2_fill,
                        onPressed: onDex,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
