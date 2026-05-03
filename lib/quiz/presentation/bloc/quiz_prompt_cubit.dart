import 'package:flutter_bloc/flutter_bloc.dart';

class QuizPromptCubit<T extends QuizPromptAnswer>
    extends Cubit<QuizPromptState<T>> {
  QuizPromptCubit({required List<T> prompts})
    : _prompts = List.unmodifiable(prompts),
      super(QuizPromptState<T>(prompts: List.unmodifiable(prompts)));

  final List<T> _prompts;

  void showNext() {
    if (_prompts.isEmpty) return;
    emit(
      QuizPromptState<T>(
        prompts: _prompts,
        activeIndex: (state.activeIndex + 1) % _prompts.length,
      ),
    );
  }

  void submitGuess(String guess) {
    final active = state.activePrompt;
    if (active == null) return;

    final normalizedGuess = guess.trim().toLowerCase();
    final normalizedAnswer = active.answerName.trim().toLowerCase();

    if (normalizedGuess == normalizedAnswer) {
      emit(
        state.copyWith(
          answerStatus: QuizAnswerStatus.correct,
          message: 'Unlocked in Kansendex',
        ),
      );
    } else {
      emit(
        state.copyWith(
          answerStatus: QuizAnswerStatus.incorrect,
          message: 'Exact name required, case ignored',
        ),
      );
    }
  }
}

class QuizPromptState<T> {
  const QuizPromptState({
    required this.prompts,
    this.activeIndex = 0,
    this.answerStatus = QuizAnswerStatus.awaitingAnswer,
    this.message =
        'Variant, rarity, and class hints are visible in Default mode.',
  });

  final List<T> prompts;
  final int activeIndex;
  final QuizAnswerStatus answerStatus;
  final String message;

  T? get activePrompt {
    if (prompts.isEmpty) return null;
    return prompts[activeIndex % prompts.length];
  }

  bool get isRevealed => answerStatus == QuizAnswerStatus.correct;

  QuizPromptState<T> copyWith({
    List<T>? prompts,
    int? activeIndex,
    QuizAnswerStatus? answerStatus,
    String? message,
  }) {
    return QuizPromptState<T>(
      prompts: prompts ?? this.prompts,
      activeIndex: activeIndex ?? this.activeIndex,
      answerStatus: answerStatus ?? this.answerStatus,
      message: message ?? this.message,
    );
  }
}

abstract interface class QuizPromptAnswer {
  String get answerName;
}

enum QuizAnswerStatus { awaitingAnswer, correct, incorrect }
