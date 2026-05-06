import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';
import 'package:who_is_this_kansen/quiz/presentation/bloc/quiz_prompt_state.dart';
import 'package:who_is_this_kansen/quiz/presentation/models/quiz_mode.dart';

export 'package:who_is_this_kansen/quiz/presentation/bloc/quiz_prompt_state.dart';
export 'package:who_is_this_kansen/quiz/presentation/models/quiz_difficulty.dart';
export 'package:who_is_this_kansen/quiz/presentation/models/quiz_mode.dart';

class QuizPromptCubit<T extends QuizPromptAnswer>
    extends Cubit<QuizPromptState<T>> {
  QuizPromptCubit({
    required List<T> prompts,
    this.mode = QuizMode.discovery,
    Set<String> unlockedKansenIds = const {},
    Random? random,
  }) : _allPrompts = List.unmodifiable(prompts),
       _unlockedKansenIds = {...unlockedKansenIds},
       super(
         QuizPromptState<T>(
           prompts: List.unmodifiable(
             _buildInitialPrompts(
               prompts,
               mode,
               unlockedKansenIds,
               random ?? Random(),
             ),
           ),
           message: switch (mode) {
             QuizMode.discovery => t.quiz.discoveryModeHint,
             QuizMode.random => t.quiz.randomModeHint,
           },
         ),
       );

  final List<T> _allPrompts;
  final QuizMode mode;
  final Set<String> _unlockedKansenIds;

  void showNext() {
    final prompts = _activePrompts();
    if (prompts.isEmpty) {
      emit(
        QuizPromptState<T>(prompts: prompts, message: t.quiz.discoveryComplete),
      );
      return;
    }

    emit(
      QuizPromptState<T>(
        prompts: prompts,
        activeIndex: (state.activeIndex + 1) % prompts.length,
        message: switch (mode) {
          QuizMode.discovery => t.quiz.discoveryModeHint,
          QuizMode.random => t.quiz.randomModeHint,
        },
      ),
    );
  }

  void recordUnlocked(String kansenId) {
    _unlockedKansenIds.add(kansenId);
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

  List<T> _activePrompts() {
    return switch (mode) {
      QuizMode.discovery => List.unmodifiable(
        _allPrompts.where((prompt) => !_unlockedKansenIds.contains(prompt.id)),
      ),
      QuizMode.random => state.prompts,
    };
  }

  static List<T> _buildInitialPrompts<T extends QuizPromptAnswer>(
    List<T> prompts,
    QuizMode mode,
    Set<String> unlockedKansenIds,
    Random random,
  ) {
    return switch (mode) {
      QuizMode.discovery =>
        prompts
            .where((prompt) => !unlockedKansenIds.contains(prompt.id))
            .toList(),
      QuizMode.random => [...prompts]..shuffle(random),
    };
  }
}
