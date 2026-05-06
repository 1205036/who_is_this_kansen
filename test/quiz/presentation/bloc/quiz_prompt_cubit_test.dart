import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';
import 'package:who_is_this_kansen/quiz/presentation/bloc/quiz_prompt_cubit.dart';

void main() {
  setUpAll(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });
  test('cycles through every prompt without repeats before wrapping', () {
    final cubit = QuizPromptCubit<_Prompt>(
      prompts: const [_Prompt('a', 'a'), _Prompt('b', 'b'), _Prompt('c', 'c')],
      random: Random(0),
    );

    final order = <String>[];
    for (var i = 0; i < 3; i++) {
      order.add(cubit.state.activePrompt!.id);
      cubit.showNext();
    }

    // Discovery mode now shuffles, so the exact order depends on the seed,
    // but every prompt must appear exactly once before the cycle wraps.
    expect(order.toSet(), {'a', 'b', 'c'});
    expect(order, hasLength(3));
    expect(cubit.state.activePrompt?.id, order.first);

    cubit.close();
  });

  test('handles empty prompt list', () {
    final cubit = QuizPromptCubit<_Prompt>(prompts: const []);

    expect(cubit.state.activePrompt, isNull);
    cubit.showNext();
    expect(cubit.state.activePrompt, isNull);

    cubit.close();
  });

  test('marks exact answer as correct while ignoring case', () {
    final cubit = QuizPromptCubit<_Prompt>(
      prompts: const [_Prompt('z23', 'Z23')],
    );

    cubit.submitGuess(' z23 ');

    expect(cubit.state.answerStatus, QuizAnswerStatus.correct);
    expect(cubit.state.isRevealed, isTrue);
    expect(cubit.state.message, t.quiz.feedbackUnlocked);

    cubit.close();
  });

  test('marks non-matching answer as incorrect', () {
    final cubit = QuizPromptCubit<_Prompt>(
      prompts: const [_Prompt('z23', 'Z23')],
    );

    cubit.submitGuess('Z24');

    expect(cubit.state.answerStatus, QuizAnswerStatus.incorrect);
    expect(cubit.state.isRevealed, isFalse);
    expect(cubit.state.message, t.quiz.feedbackIncorrect);

    cubit.close();
  });

  test('discovery mode excludes already unlocked prompts', () {
    final cubit = QuizPromptCubit<_Prompt>(
      prompts: const [_Prompt('z23', 'Z23'), _Prompt('z28', 'Z28')],
      unlockedKansenIds: const {'z23'},
    );

    expect(cubit.state.activePrompt?.answerName, 'Z28');

    cubit.close();
  });

  test('discovery mode drops a kansen from the pool after recordUnlocked', () {
    final cubit = QuizPromptCubit<_Prompt>(
      prompts: const [
        _Prompt('a', 'a'),
        _Prompt('b', 'b'),
        _Prompt('c', 'c'),
      ],
      random: Random(0),
    );

    final firstId = cubit.state.activePrompt!.id;
    cubit.recordUnlocked(firstId);
    cubit.showNext();

    // After unlocking the first kansen the cubit should keep advancing only
    // through the remaining two, in some shuffled order.
    final remaining = <String>{};
    for (var i = 0; i < 2; i++) {
      remaining.add(cubit.state.activePrompt!.id);
      cubit.showNext();
    }

    expect(remaining, {'a', 'b', 'c'}.difference({firstId}));
    expect(remaining, hasLength(2));

    cubit.close();
  });

  test('random mode keeps unlocked prompts in play', () {
    final cubit = QuizPromptCubit<_Prompt>(
      mode: QuizMode.random,
      prompts: const [_Prompt('z23', 'Z23'), _Prompt('z28', 'Z28')],
      unlockedKansenIds: const {'z23', 'z28'},
    );

    expect(cubit.state.prompts, hasLength(2));

    cubit.close();
  });
}

class _Prompt implements QuizPromptAnswer {
  const _Prompt(this.id, this.answerName);

  @override
  final String id;

  @override
  final String answerName;
}
