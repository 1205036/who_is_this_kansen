import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_this_kansen/core/presentation/widgets/surface_buttons.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';
import 'package:who_is_this_kansen/kansen/presentation/widgets/kansen_hint_row.dart';
import 'package:who_is_this_kansen/quiz/presentation/bloc/quiz_prompt_cubit.dart';
import 'package:who_is_this_kansen/quiz/presentation/widgets/prompt_stage.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.mode,
    required this.kansen,
    required this.onCorrectAnswer,
    required this.onNext,
    required this.onOpenDetail,
  });

  final QuizMode mode;
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

    if (revealed && _revealController.value == 0) {
      _revealController.forward(from: 0);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
      children: [
        PromptStage(
          kansen: widget.kansen,
          revealed: revealed,
          revealAnimation: _revealController,
        ),
        const SizedBox(height: 14),
        Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.58),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: tokens.hairline.withValues(alpha: 0.12),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(
                switch (widget.mode) {
                  QuizMode.discovery => t.quiz.modeDiscovery,
                  QuizMode.random => t.quiz.modeRandom,
                },
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        KansenHintRow(kansen: widget.kansen),
        const SizedBox(height: 14),
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
