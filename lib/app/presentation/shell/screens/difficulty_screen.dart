import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:who_is_this_kansen/app/presentation/shell/widgets/landing_mode_button.dart';
import 'package:who_is_this_kansen/app/presentation/shell/widgets/landing_title_art.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';
import 'package:who_is_this_kansen/quiz/presentation/bloc/quiz_prompt_cubit.dart';

class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({
    super.key,
    required this.mode,
    required this.onSelected,
  });

  final QuizMode mode;
  final ValueChanged<QuizDifficulty> onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = KansenThemeTokens.of(context);

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
                  padding: const EdgeInsets.only(top: 230),
                  child: Column(
                    children: [
                      Text(
                        switch (mode) {
                          QuizMode.discovery => t.quiz.modeDiscovery,
                          QuizMode.random => t.quiz.modeRandom,
                        },
                        style: TextStyle(
                          color: tokens.ink.withValues(alpha: 0.76),
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 14),
                      LandingModeButton(
                        key: const ValueKey('difficulty-easy-button'),
                        label: t.quiz.difficultyEasy,
                        icon: Icons.auto_awesome,
                        iconPlacement: LandingButtonIconPlacement.leading,
                        onPressed: () => onSelected(QuizDifficulty.easy),
                      ),
                      const SizedBox(height: 16),
                      LandingModeButton(
                        key: const ValueKey('difficulty-medium-button'),
                        label: t.quiz.difficultyMedium,
                        icon: CupertinoIcons.circle_lefthalf_fill,
                        iconPlacement: LandingButtonIconPlacement.leading,
                        onPressed: () => onSelected(QuizDifficulty.medium),
                      ),
                      const SizedBox(height: 16),
                      LandingModeButton(
                        key: const ValueKey('difficulty-hard-button'),
                        label: t.quiz.difficultyHard,
                        icon: CupertinoIcons.flame_fill,
                        iconPlacement: LandingButtonIconPlacement.leading,
                        onPressed: () => onSelected(QuizDifficulty.hard),
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
