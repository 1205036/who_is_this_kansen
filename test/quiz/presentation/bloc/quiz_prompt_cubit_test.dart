import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_this_kansen/quiz/presentation/bloc/quiz_prompt_cubit.dart';

void main() {
  test('starts on first prompt and advances in deterministic order', () {
    final cubit = QuizPromptCubit<_Prompt>(
      prompts: const [_Prompt('a', 'a'), _Prompt('b', 'b'), _Prompt('c', 'c')],
    );

    expect(cubit.state.activePrompt?.answerName, 'a');

    cubit.showNext();
    expect(cubit.state.activePrompt?.answerName, 'b');

    cubit.showNext();
    expect(cubit.state.activePrompt?.answerName, 'c');

    cubit.showNext();
    expect(cubit.state.activePrompt?.answerName, 'a');

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
    expect(cubit.state.message, 'Unlocked in Kansendex');

    cubit.close();
  });

  test('marks non-matching answer as incorrect', () {
    final cubit = QuizPromptCubit<_Prompt>(
      prompts: const [_Prompt('z23', 'Z23')],
    );

    cubit.submitGuess('Z24');

    expect(cubit.state.answerStatus, QuizAnswerStatus.incorrect);
    expect(cubit.state.isRevealed, isFalse);
    expect(cubit.state.message, 'Exact name required, case ignored');

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
