import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_this_kansen/quiz/presentation/bloc/quiz_prompt_cubit.dart';

void main() {
  test('starts on first prompt and advances in deterministic order', () {
    final cubit = QuizPromptCubit<_Prompt>(
      prompts: const [_Prompt('a'), _Prompt('b'), _Prompt('c')],
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
    final cubit = QuizPromptCubit<_Prompt>(prompts: const [_Prompt('Z23')]);

    cubit.submitGuess(' z23 ');

    expect(cubit.state.answerStatus, QuizAnswerStatus.correct);
    expect(cubit.state.isRevealed, isTrue);
    expect(cubit.state.message, 'Unlocked in Kansendex');

    cubit.close();
  });

  test('marks non-matching answer as incorrect', () {
    final cubit = QuizPromptCubit<_Prompt>(prompts: const [_Prompt('Z23')]);

    cubit.submitGuess('Z24');

    expect(cubit.state.answerStatus, QuizAnswerStatus.incorrect);
    expect(cubit.state.isRevealed, isFalse);
    expect(cubit.state.message, 'Exact name required, case ignored');

    cubit.close();
  });
}

class _Prompt implements QuizPromptAnswer {
  const _Prompt(this.answerName);

  @override
  final String answerName;
}
