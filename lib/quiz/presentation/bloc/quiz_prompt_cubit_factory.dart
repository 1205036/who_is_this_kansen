import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';
import 'package:who_is_this_kansen/quiz/presentation/bloc/quiz_prompt_cubit.dart';

/// DI-registered factory that produces a fresh `QuizPromptCubit` per quiz
/// session. The cubit itself stays out of the locator because it's generic
/// and takes runtime parameters; the factory is the registered seam, so
/// adapters or cross-cutting concerns (logging, analytics) can be added here
/// without touching the screen.
@lazySingleton
class QuizPromptCubitFactory {
  const QuizPromptCubitFactory();

  QuizPromptCubit<KansenViewModel> create({
    required List<KansenViewModel> prompts,
    QuizMode mode = QuizMode.discovery,
    Set<String> unlockedKansenIds = const {},
    Random? random,
  }) {
    return QuizPromptCubit<KansenViewModel>(
      prompts: prompts,
      mode: mode,
      unlockedKansenIds: unlockedKansenIds,
      random: random,
    );
  }
}
