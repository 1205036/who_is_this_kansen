import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_prompt_state.freezed.dart';

@freezed
abstract class QuizPromptState<T> with _$QuizPromptState<T> {
  const QuizPromptState._();

  const factory QuizPromptState({
    required List<T> prompts,
    @Default(0) int activeIndex,
    @Default(QuizAnswerStatus.awaitingAnswer) QuizAnswerStatus answerStatus,
    @Default('') String message,
  }) = _QuizPromptState<T>;

  T? get activePrompt {
    if (prompts.isEmpty) return null;
    return prompts[activeIndex % prompts.length];
  }

  bool get isRevealed => answerStatus == QuizAnswerStatus.correct;
}

abstract interface class QuizPromptAnswer {
  String get answerName;
}

enum QuizAnswerStatus { awaitingAnswer, correct, incorrect }
