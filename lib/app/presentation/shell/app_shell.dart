import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_is_this_kansen/app/presentation/shell/app_tab.dart';
import 'package:who_is_this_kansen/app/presentation/shell/widgets/app_backdrop.dart';
import 'package:who_is_this_kansen/app/presentation/shell/widgets/app_top_bar.dart';
import 'package:who_is_this_kansen/app/presentation/shell/widgets/unlock_toast.dart';
import 'package:who_is_this_kansen/catalog/catalog.dart';
import 'package:who_is_this_kansen/core/presentation/widgets/catalog_load_state.dart';
import 'package:who_is_this_kansen/kansen/presentation/mappers/kansen_catalog_mapper.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';
import 'package:who_is_this_kansen/kansen_detail/presentation/screens/kansen_detail_screen.dart';
import 'package:who_is_this_kansen/kansendex/presentation/screens/kansendex_screen.dart';
import 'package:who_is_this_kansen/progress/progress.dart';
import 'package:who_is_this_kansen/quiz/presentation/bloc/quiz_prompt_cubit.dart';
import 'package:who_is_this_kansen/quiz/presentation/screens/quiz_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  var _tab = AppTab.quiz;
  var _toastGeneration = 0;
  KansenViewModel? _toastKansen;
  late final Future<List<KansenViewModel>> _kansenFuture;
  late final UnlockProgressCubit _unlockProgressCubit;

  @override
  void initState() {
    super.initState();
    _kansenFuture = LoadKansenCatalog(
      AssetBundleKansenCatalogRepository(assetBundle: rootBundle),
    )().then(const KansenCatalogMapper().fromCatalog);
    final progressRepository = SharedPreferencesUnlockProgressRepository(
      preferences: SharedPreferencesAsync(),
    );
    _unlockProgressCubit = UnlockProgressCubit(
      loadUnlockProgress: LoadUnlockProgress(progressRepository),
      unlockKansen: UnlockKansen(progressRepository),
    )..load();
  }

  @override
  void dispose() {
    _unlockProgressCubit.close();
    super.dispose();
  }

  void _showUnlockToast(KansenViewModel kansen) {
    final generation = _toastGeneration + 1;
    setState(() {
      _toastGeneration = generation;
      _toastKansen = kansen;
    });

    Future<void>.delayed(const Duration(milliseconds: 1900), () {
      if (!mounted || _toastGeneration != generation) return;
      setState(() => _toastKansen = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _unlockProgressCubit,
      child: Scaffold(
        body: Stack(
          children: [
            const AppBackdrop(),
            SafeArea(
              child: Column(
                children: [
                  AppTopBar(
                    selected: _tab,
                    onSelected: (tab) => setState(() => _tab = tab),
                    themeMode: widget.themeMode,
                    onThemeModeChanged: widget.onThemeModeChanged,
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 360),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child: switch (_tab) {
                        AppTab.quiz => FutureBuilder<List<KansenViewModel>>(
                          key: const ValueKey('quiz'),
                          future: _kansenFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return CatalogLoadError(error: snapshot.error);
                            }
                            final kansen = snapshot.data;
                            if (kansen == null || kansen.isEmpty) {
                              return const CatalogLoading();
                            }
                            return BlocProvider(
                              create: (_) => QuizPromptCubit<KansenViewModel>(
                                prompts: kansen,
                              ),
                              child:
                                  BlocBuilder<
                                    QuizPromptCubit<KansenViewModel>,
                                    QuizPromptState<KansenViewModel>
                                  >(
                                    builder: (context, state) {
                                      final active = state.activePrompt;
                                      if (active == null) {
                                        return const CatalogLoading();
                                      }
                                      return QuizScreen(
                                        kansen: active,
                                        onCorrectAnswer: (kansen) async {
                                          final result = await context
                                              .read<UnlockProgressCubit>()
                                              .unlock(kansen.id);
                                          if (result?.added ?? false) {
                                            _showUnlockToast(kansen);
                                          }
                                        },
                                        onOpenDetail: () {
                                          Navigator.of(context).push(
                                            PageRouteBuilder<void>(
                                              opaque: false,
                                              barrierColor: Colors.black
                                                  .withValues(alpha: 0.34),
                                              pageBuilder:
                                                  (
                                                    context,
                                                    animation,
                                                    secondaryAnimation,
                                                  ) {
                                                    return FadeTransition(
                                                      opacity: animation,
                                                      child: KansenDetailScreen(
                                                        kansen: active,
                                                      ),
                                                    );
                                                  },
                                            ),
                                          );
                                        },
                                        onNext: context
                                            .read<
                                              QuizPromptCubit<KansenViewModel>
                                            >()
                                            .showNext,
                                      );
                                    },
                                  ),
                            );
                          },
                        ),
                        AppTab.dex => KansendexScreen(
                          key: const ValueKey('dex'),
                          kansenFuture: _kansenFuture,
                          onSelected: (kansen) {
                            Navigator.of(context).push(
                              PageRouteBuilder<void>(
                                opaque: false,
                                barrierColor: Colors.black.withValues(
                                  alpha: 0.34,
                                ),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: KansenDetailScreen(
                                          kansen: kansen,
                                        ),
                                      );
                                    },
                              ),
                            );
                          },
                        ),
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.paddingOf(context).top + 58,
              left: 18,
              right: 18,
              child: IgnorePointer(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: _toastKansen == null
                      ? const SizedBox.shrink()
                      : Align(
                          key: ValueKey(_toastKansen!.id),
                          alignment: Alignment.topCenter,
                          child: UnlockToast(kansen: _toastKansen!),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
