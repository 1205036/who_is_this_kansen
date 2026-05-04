import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';
import 'package:who_is_this_kansen/quiz/presentation/bloc/quiz_prompt_state.dart';

export 'package:who_is_this_kansen/quiz/presentation/bloc/quiz_prompt_state.dart';

class QuizPromptCubit<T extends QuizPromptAnswer>
    extends Cubit<QuizPromptState<T>> {
  QuizPromptCubit({required List<T> prompts})
    : _prompts = List.unmodifiable(prompts),
      super(
        QuizPromptState<T>(
          prompts: List.unmodifiable(prompts),
          message: t.quiz.defaultModeHint,
        ),
      );

  final List<T> _prompts;

  void showNext() {
    if (_prompts.isEmpty) return;
    emit(
      QuizPromptState<T>(
        prompts: _prompts,
        activeIndex: (state.activeIndex + 1) % _prompts.length,
        message: t.quiz.defaultModeHint,
      ),
    );
  }

  bool submitGuess(String guess) {
    final active = state.activePrompt;
    if (active == null) return false;

    final normalizedGuess = guess.trim().toLowerCase();
    final normalizedAnswer = active.answerName.trim().toLowerCase();

    if (normalizedGuess == normalizedAnswer) {
      emit(
        state.copyWith(
          answerStatus: QuizAnswerStatus.correct,
          message: t.quiz.feedbackUnlocked,
        ),
      );
      return true;
    } else {
      emit(
        state.copyWith(
          answerStatus: QuizAnswerStatus.incorrect,
          message: t.quiz.feedbackIncorrect,
        ),
      );
      return false;
    }
  }
}
