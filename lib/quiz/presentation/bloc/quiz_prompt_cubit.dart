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
    QuizMode mode = QuizMode.discovery,
    Set<String> unlockedKansenIds = const {},
    Random? random,
  }) : this._(
         mode: mode,
         unlockedKansenIds: unlockedKansenIds,
         shuffledOrder: List<T>.unmodifiable(
           [...prompts]..shuffle(random ?? Random()),
         ),
       );

  // The shuffled order is computed once and lives on the cubit so subsequent
  // showNext() calls keep iterating through the same randomized sequence.
  // Discovery mode filters that order by `_unlockedKansenIds` on every
  // advance, so each correctly-guessed kansen is naturally dropped from the
  // pool without disturbing the relative order of the remainder.
  QuizPromptCubit._({
    required this.mode,
    required Set<String> unlockedKansenIds,
    required List<T> shuffledOrder,
  }) : _shuffledOrder = shuffledOrder,
       _unlockedKansenIds = {...unlockedKansenIds},
       super(
         QuizPromptState<T>(
           prompts: List.unmodifiable(
             switch (mode) {
               QuizMode.discovery => shuffledOrder
                   .where((prompt) => !unlockedKansenIds.contains(prompt.id))
                   .toList(),
               QuizMode.random => shuffledOrder,
             },
           ),
           message: switch (mode) {
             QuizMode.discovery => t.quiz.discoveryModeHint,
             QuizMode.random => t.quiz.randomModeHint,
           },
         ),
       );

  final List<T> _shuffledOrder;
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
        _shuffledOrder.where(
          (prompt) => !_unlockedKansenIds.contains(prompt.id),
        ),
      ),
      QuizMode.random => state.prompts,
    };
  }
}
