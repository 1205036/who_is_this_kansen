import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:who_is_this_kansen/app/presentation/shell/widgets/landing_mode_button.dart';
import 'package:who_is_this_kansen/app/presentation/shell/widgets/landing_title_art.dart';
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
                  // Top padding matches `LandingScreen` (260) so the
                  // button column lines up at the same Y on both screens.
                  // Difficulty used to use 230 with an in-screen mode label
                  // making up the rest; the label moved to the top bar, so
                  // the padding has to absorb the gap on its own.
                  padding: const EdgeInsets.only(top: 260),
                  child: Column(
                    children: [
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
