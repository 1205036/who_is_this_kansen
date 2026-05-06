import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_this_kansen/core/presentation/widgets/surface_buttons.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';
import 'package:who_is_this_kansen/kansen/presentation/widgets/kansen_hint_row.dart';
import 'package:who_is_this_kansen/kansen/presentation/widgets/kansen_hint_type.dart';
import 'package:who_is_this_kansen/quiz/presentation/bloc/quiz_prompt_cubit.dart';
import 'package:who_is_this_kansen/quiz/presentation/widgets/prompt_stage.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.mode,
    required this.difficulty,
    required this.kansen,
    required this.onCorrectAnswer,
    required this.onNext,
    required this.onOpenDetail,
  });

  final QuizMode mode;
  final QuizDifficulty difficulty;
  final KansenViewModel kansen;
  final Future<void> Function(KansenViewModel kansen) onCorrectAnswer;
  final VoidCallback onNext;
  final VoidCallback onOpenDetail;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _revealController;
  late final TextEditingController _answerController;

  @override
  void initState() {
    super.initState();
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1650),
    );
    _answerController = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant QuizScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.kansen != widget.kansen) {
      _revealController.value = 0;
      _answerController.clear();
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizState = context.watch<QuizPromptCubit<KansenViewModel>>().state;
    final revealed = quizState.isRevealed;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = KansenThemeTokens.of(context);
    // Difficulty -> hint surface mapping:
    //   Easy   = faction (alone above) + variant family + rarity + ship class
    //   Medium = faction (alone above) + ship class
    //   Hard   = nothing
    final visibleHints = switch (widget.difficulty) {
      QuizDifficulty.easy => KansenHintType.values,
      QuizDifficulty.medium => const [
        KansenHintType.faction,
        KansenHintType.shipClass,
      ],
      QuizDifficulty.hard => const <KansenHintType>[],
    };
    final showFaction = visibleHints.contains(KansenHintType.faction);
    final otherHints = visibleHints
        .where((hint) => hint != KansenHintType.faction)
        .toList(growable: false);

    if (revealed && _revealController.value == 0) {
      _revealController.forward(from: 0);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
      children: [
        // AnimatedSwitcher cross-fades the entire PromptStage when the kansen
        // changes (Submit -> Next). The outgoing stage shows the just-unlocked
        // kansen fading away; the incoming stage starts in its awaiting state
        // (silhouette only, no name), so the next answer is never rendered at
        // any visible opacity. Same-kansen transitions (e.g. revealed flipping
        // after Submit) keep the same key and don't cross-fade — the existing
        // reveal animation handles them in place.
        //
        // Transition shape: longer ease-in-out fade + a subtle scale/blur
        // breath so the handoff reads as a real transition rather than a
        // flat opacity blend. Outgoing: fade out + gently scale down to 0.96;
        // incoming: fade in + gently scale up from 0.96 to 1.0.
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 520),
          reverseDuration: const Duration(milliseconds: 380),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          layoutBuilder: (currentChild, previousChildren) {
            return Stack(
              alignment: Alignment.topCenter,
              children: [...previousChildren, ?currentChild],
            );
          },
          transitionBuilder: (child, animation) {
            final eased = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            );
            final scale = Tween<double>(
              begin: 0.96,
              end: 1.0,
            ).animate(eased);
            final slide = Tween<Offset>(
              begin: const Offset(0, 0.025),
              end: Offset.zero,
            ).animate(eased);
            return FadeTransition(
              opacity: eased,
              child: SlideTransition(
                position: slide,
                child: ScaleTransition(scale: scale, child: child),
              ),
            );
          },
          child: PromptStage(
            key: ValueKey('prompt-${widget.kansen.id}'),
            kansen: widget.kansen,
            revealed: revealed,
            revealAnimation: _revealController,
          ),
        ),
        const SizedBox(height: 14),
        // Faction hint sits alone on its own row in the space the mode pill
        // used to occupy; the remaining hints (variant family / rarity /
        // ship class — subset depending on difficulty) live on the row below.
        // Left-aligned to match the chip row underneath.
        if (showFaction) ...[
          KansenHintRow(
            kansen: widget.kansen,
            visibleHints: const [KansenHintType.faction],
          ),
          const SizedBox(height: 10),
        ],
        if (otherHints.isNotEmpty) ...[
          KansenHintRow(kansen: widget.kansen, visibleHints: otherHints),
          const SizedBox(height: 14),
        ],
        TextField(
          controller: _answerController,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            if (revealed) return;
            final correct = context
                .read<QuizPromptCubit<KansenViewModel>>()
                .submitGuess(_answerController.text);
            if (correct) widget.onCorrectAnswer(widget.kansen);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withValues(alpha: isDark ? 0.08 : 0.64),
            hintText: t.quiz.answerHint,
            prefixIcon: const Icon(CupertinoIcons.text_cursor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: tokens.hairline.withValues(alpha: 0.12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: Text(
            quizState.message,
            key: ValueKey(quizState.message),
            style: TextStyle(color: tokens.ink.withValues(alpha: 0.68)),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: SurfaceActionButton(
                onPressed: revealed
                    ? widget.onOpenDetail
                    : () {
                        final correct = context
                            .read<QuizPromptCubit<KansenViewModel>>()
                            .submitGuess(_answerController.text);
                        if (correct) widget.onCorrectAnswer(widget.kansen);
                      },
                icon: Icon(
                  revealed
                      ? CupertinoIcons.sparkles
                      : CupertinoIcons.check_mark_circled,
                ),
                label: revealed ? t.quiz.details : t.quiz.submit,
              ),
            ),
            const SizedBox(width: 10),
            SurfaceIconButton(
              onPressed: widget.onNext,
              icon: const Icon(CupertinoIcons.forward_fill),
              tooltip: t.quiz.nextPrompt,
            ),
          ],
        ),
      ],
    );
  }
}
