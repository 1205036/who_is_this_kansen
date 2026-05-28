import 'package:who_is_this_kansen/quiz/presentation/bloc/quiz_prompt_cubit.dart';

/// Centralised route paths and typed `extra` payload classes for `go_router`.
/// Path strings are defined here so call sites don't sprinkle string
/// literals across screens.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const landing = '/';
  static const difficulty = '/difficulty';
  static const quiz = '/quiz';
  static const dex = '/dex';
  static const detail = '/detail/:id';

  static String detailFor(String kansenId) => '/detail/$kansenId';
}

/// Carries the chosen quiz mode from landing → difficulty.
class DifficultySelectionExtra {
  const DifficultySelectionExtra({required this.mode});
  final QuizMode mode;
}

/// Carries the full session config from difficulty → quiz.
class QuizSessionExtra {
  const QuizSessionExtra({required this.mode, required this.difficulty});
  final QuizMode mode;
  final QuizDifficulty difficulty;
}
