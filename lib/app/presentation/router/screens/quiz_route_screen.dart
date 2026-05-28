import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:who_is_this_kansen/app/presentation/notifications/unlock_toast_cubit.dart';
import 'package:who_is_this_kansen/app/presentation/router/app_routes.dart';
import 'package:who_is_this_kansen/catalog/presentation/kansen_catalog_provider.dart';
import 'package:who_is_this_kansen/core/di/service_locator.dart';
import 'package:who_is_this_kansen/core/presentation/widgets/catalog_load_state.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';
import 'package:who_is_this_kansen/progress/progress.dart';
import 'package:who_is_this_kansen/quiz/presentation/bloc/quiz_prompt_cubit.dart';
import 'package:who_is_this_kansen/quiz/presentation/bloc/quiz_prompt_cubit_factory.dart';
import 'package:who_is_this_kansen/quiz/presentation/screens/quiz_screen.dart';

/// Route-level wrapper that loads the catalog, scopes a fresh
/// `QuizPromptCubit` for the session, and delegates rendering to the pure
/// `QuizScreen`. Lives on the quiz route so the cubit's lifecycle ends when
/// the player navigates away from `/quiz`.
class QuizRouteScreen extends StatelessWidget {
  const QuizRouteScreen({super.key, required this.session});

  final QuizSessionExtra session;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<KansenViewModel>>(
      future: getIt<KansenCatalogProvider>().future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CatalogLoadError(error: snapshot.error);
        }
        final kansen = snapshot.data;
        if (kansen == null || kansen.isEmpty) {
          return const CatalogLoading();
        }
        return BlocBuilder<UnlockProgressCubit, UnlockProgressState>(
          builder: (context, progressState) {
            return BlocProvider(
              create: (_) => getIt<QuizPromptCubitFactory>().create(
                prompts: kansen,
                mode: session.mode,
                unlockedKansenIds: progressState.progress.unlockedKansenIds,
              ),
              child: BlocBuilder<
                QuizPromptCubit<KansenViewModel>,
                QuizPromptState<KansenViewModel>
              >(
                builder: (context, state) {
                  final active = state.activePrompt;
                  if (active == null) return const CatalogLoading();
                  return QuizScreen(
                    mode: session.mode,
                    difficulty: session.difficulty,
                    kansen: active,
                    onCorrectAnswer: (kansen) async {
                      final quizCubit = context
                          .read<QuizPromptCubit<KansenViewModel>>();
                      final result = await context
                          .read<UnlockProgressCubit>()
                          .unlock(kansen.id);
                      if (result?.added ?? false) {
                        quizCubit.recordUnlocked(kansen.id);
                        getIt<UnlockToastCubit>().announce(kansen);
                      }
                    },
                    onOpenDetail: () =>
                        context.push(AppRoutes.detailFor(active.id), extra: active),
                    onNext: context
                        .read<QuizPromptCubit<KansenViewModel>>()
                        .showNext,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
