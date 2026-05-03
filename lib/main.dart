import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_this_kansen/catalog/catalog.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/core/theme/kansen_theme_colors.dart';
import 'package:who_is_this_kansen/quiz/presentation/bloc/quiz_prompt_cubit.dart';

void main() {
  runApp(const KansenApp());
}

bool _isDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

Color _ink(BuildContext context, [double opacity = 1]) {
  return KansenThemeTokens.of(context).ink.withValues(alpha: opacity);
}

Color _glass(BuildContext context, {double dark = 0.08, double light = 0.72}) {
  return (_isDark(context) ? Colors.white : Colors.white).withValues(
    alpha: _isDark(context) ? dark : light,
  );
}

Color _hairline(BuildContext context) {
  return KansenThemeTokens.of(
    context,
  ).hairline.withValues(alpha: _isDark(context) ? 0.12 : 0.12);
}

class KansenApp extends StatefulWidget {
  const KansenApp({super.key});

  @override
  State<KansenApp> createState() => _KansenAppState();
}

class _KansenAppState extends State<KansenApp> {
  var _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Who Is This Kansen',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: KansenAppTheme.light(),
      darkTheme: KansenAppTheme.dark(),
      home: PrototypeShell(
        themeMode: _themeMode,
        onThemeModeChanged: (themeMode) {
          setState(() => _themeMode = themeMode);
        },
      ),
    );
  }
}

class PrototypeShell extends StatefulWidget {
  const PrototypeShell({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<PrototypeShell> createState() => _PrototypeShellState();
}

class _PrototypeShellState extends State<PrototypeShell> {
  var _tab = PrototypeTab.quiz;
  late final Future<List<KansenSample>> _catalogSamplesFuture;

  @override
  void initState() {
    super.initState();
    _catalogSamplesFuture = LoadKansenCatalog(
      AssetBundleKansenCatalogRepository(assetBundle: rootBundle),
    )().then(_samplesFromCatalog);
  }

  void _showKansen(KansenSample sample) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.34),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: DetailOverlay(sample: sample),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _AppBackdrop(),
          SafeArea(
            child: Column(
              children: [
                _TopBar(
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
                      PrototypeTab.quiz => FutureBuilder<List<KansenSample>>(
                        key: const ValueKey('quiz'),
                        future: _catalogSamplesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return _CatalogLoadError(error: snapshot.error);
                          }
                          final samples = snapshot.data;
                          if (samples == null || samples.isEmpty) {
                            return const _CatalogLoading();
                          }
                          return BlocProvider(
                            create: (_) =>
                                QuizPromptCubit<KansenSample>(prompts: samples),
                            child:
                                BlocBuilder<
                                  QuizPromptCubit<KansenSample>,
                                  QuizPromptState<KansenSample>
                                >(
                                  builder: (context, state) {
                                    final active = state.activePrompt;
                                    if (active == null) {
                                      return const _CatalogLoading();
                                    }
                                    return QuizPrototype(
                                      sample: active,
                                      onNext: context
                                          .read<QuizPromptCubit<KansenSample>>()
                                          .showNext,
                                      onOpenDetail: () => _showKansen(active),
                                    );
                                  },
                                ),
                          );
                        },
                      ),
                      PrototypeTab.dex => DexPrototype(
                        key: const ValueKey('dex'),
                        samplesFuture: _catalogSamplesFuture,
                        onSelected: _showKansen,
                      ),
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum PrototypeTab { quiz, dex }

List<KansenSample> _samplesFromCatalog(KansenCatalog catalog) {
  final assetSetsById = catalog.assetSetsById;
  final assetsById = catalog.assetsById;

  return catalog.entries.map((entry) {
    final assetSet = assetSetsById[entry.assetSetId];
    final portraitAsset = assetsById[assetSet?.portraitAssetId]?.path;
    final skillAssets = assetSet?.skillIconAssetIds
        .map((assetId) => assetsById[assetId]?.path)
        .whereType<String>()
        .toList();

    return KansenSample(
      name: entry.answerName,
      family: entry.variantFamily,
      rarity: entry.rarity,
      rarityLabel: entry.rarityLabel,
      shipClass: entry.shipTypeLabel,
      portraitAsset: portraitAsset ?? '',
      skillAssets: skillAssets ?? const [],
    );
  }).toList();
}

class _CatalogLoading extends StatelessWidget {
  const _CatalogLoading();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(color: _ink(context, 0.72)),
    );
  }
}

class _CatalogLoadError extends StatelessWidget {
  const _CatalogLoadError({required this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Could not load generated catalog\n$error',
          textAlign: TextAlign.center,
          style: TextStyle(color: _ink(context, 0.72)),
        ),
      ),
    );
  }
}

class _ThemeAction extends StatelessWidget {
  const _ThemeAction({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheetAction(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
          if (selected) ...[
            const SizedBox(width: 8),
            const Icon(CupertinoIcons.check_mark, size: 17),
          ],
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.selected,
    required this.onSelected,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final PrototypeTab selected;
  final ValueChanged<PrototypeTab> onSelected;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  IconData get _themeIcon {
    return switch (themeMode) {
      ThemeMode.light => CupertinoIcons.sun_max,
      ThemeMode.dark => CupertinoIcons.moon,
      ThemeMode.system => CupertinoIcons.device_phone_portrait,
    };
  }

  void _showThemePicker(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text('Appearance'),
          actions: [
            _ThemeAction(
              label: 'System',
              icon: CupertinoIcons.device_phone_portrait,
              selected: themeMode == ThemeMode.system,
              onPressed: () {
                onThemeModeChanged(ThemeMode.system);
                Navigator.of(context).pop();
              },
            ),
            _ThemeAction(
              label: 'Light',
              icon: CupertinoIcons.sun_max,
              selected: themeMode == ThemeMode.light,
              onPressed: () {
                onThemeModeChanged(ThemeMode.light);
                Navigator.of(context).pop();
              },
            ),
            _ThemeAction(
              label: 'Dark',
              icon: CupertinoIcons.moon,
              selected: themeMode == ThemeMode.dark,
              onPressed: () {
                onThemeModeChanged(ThemeMode.dark);
                Navigator.of(context).pop();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _IconSurfaceButton(
                onPressed: () => _showThemePicker(context),
                icon: Icon(_themeIcon),
                tooltip: 'Appearance',
                size: 32,
              ),
              const SizedBox(width: 8),
              CupertinoSlidingSegmentedControl<PrototypeTab>(
                groupValue: selected,
                backgroundColor: _glass(context, dark: 0.08, light: 0.56),
                thumbColor: KansenThemeTokens.of(context).segmentThumb,
                children: const {
                  PrototypeTab.quiz: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(CupertinoIcons.question_circle, size: 18),
                  ),
                  PrototypeTab.dex: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(CupertinoIcons.square_grid_2x2, size: 18),
                  ),
                },
                onValueChanged: (value) {
                  if (value != null) onSelected(value);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Who Is This Kansen',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class QuizPrototype extends StatefulWidget {
  const QuizPrototype({
    super.key,
    required this.sample,
    required this.onNext,
    required this.onOpenDetail,
  });

  final KansenSample sample;
  final VoidCallback onNext;
  final VoidCallback onOpenDetail;

  @override
  State<QuizPrototype> createState() => _QuizPrototypeState();
}

class _QuizPrototypeState extends State<QuizPrototype>
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
  void didUpdateWidget(covariant QuizPrototype oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sample != widget.sample) {
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
    final sample = widget.sample;
    final quizState = context.watch<QuizPromptCubit<KansenSample>>().state;
    final revealed = quizState.isRevealed;
    if (revealed && _revealController.value == 0) {
      _revealController.forward(from: 0);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
      children: [
        _PromptStage(
          sample: sample,
          revealed: revealed,
          revealAnimation: _revealController,
        ),
        const SizedBox(height: 14),
        _HintRow(sample: sample),
        const SizedBox(height: 14),
        TextField(
          controller: _answerController,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => context
              .read<QuizPromptCubit<KansenSample>>()
              .submitGuess(_answerController.text),
          decoration: InputDecoration(
            filled: true,
            fillColor: _glass(context, dark: 0.08, light: 0.64),
            hintText: 'Type exact kansen name',
            prefixIcon: const Icon(CupertinoIcons.text_cursor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: _hairline(context)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: Text(
            quizState.message,
            key: ValueKey(quizState.message),
            style: TextStyle(color: _ink(context, 0.68)),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                onPressed: revealed
                    ? widget.onOpenDetail
                    : () => context
                          .read<QuizPromptCubit<KansenSample>>()
                          .submitGuess(_answerController.text),
                icon: Icon(
                  revealed
                      ? CupertinoIcons.sparkles
                      : CupertinoIcons.check_mark_circled,
                ),
                label: revealed ? 'Open Detail' : 'Submit Guess',
              ),
            ),
            const SizedBox(width: 10),
            _IconSurfaceButton(
              onPressed: widget.onNext,
              icon: const Icon(CupertinoIcons.forward_fill),
              tooltip: 'Next prompt',
            ),
          ],
        ),
      ],
    );
  }
}

class _PromptStage extends StatefulWidget {
  const _PromptStage({
    required this.sample,
    required this.revealed,
    required this.revealAnimation,
  });

  final KansenSample sample;
  final bool revealed;
  final Animation<double> revealAnimation;

  @override
  State<_PromptStage> createState() => _PromptStageState();
}

class _PromptStageState extends State<_PromptStage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _idleController;

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _idleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.82,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: _hairline(context)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: KansenThemeTokens.of(context).stageGradient,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                animation: _idleController,
                builder: (context, child) {
                  final drift = math.sin(_idleController.value * math.pi) * 8;
                  return Transform.translate(
                    offset: Offset(drift * 0.25, -drift * 0.18),
                    child: child,
                  );
                },
                child: CustomPaint(painter: _StageLightPainter()),
              ),
              AnimatedBuilder(
                animation: Listenable.merge([
                  _idleController,
                  widget.revealAnimation,
                ]),
                builder: (context, child) {
                  final pulse =
                      1 + math.sin(_idleController.value * math.pi) * 0.018;
                  final artOpacity = Curves.easeInOutCubic.transform(
                    widget.revealAnimation.value.clamp(0, 1),
                  );
                  return Transform.scale(
                    scale: pulse,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _SilhouetteImage(asset: widget.sample.portraitAsset),
                        ClipPath(
                          clipper: _RevealClipper(widget.revealAnimation.value),
                          child: Opacity(
                            opacity: widget.revealed ? 1 : artOpacity,
                            child: _KansenArt(
                              asset: widget.sample.portraitAsset,
                            ),
                          ),
                        ),
                        IgnorePointer(
                          child: CustomPaint(
                            painter: _UnlockBurstPainter(
                              progress: widget.revealAnimation.value,
                              colors: KansenThemeColors.rarityGradient(
                                widget.sample.rarity,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: AnimatedOpacity(
                  opacity: widget.revealed ? 1 : 0,
                  duration: const Duration(milliseconds: 420),
                  child: Text(
                    widget.sample.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DexPrototype extends StatelessWidget {
  const DexPrototype({
    super.key,
    required this.samplesFuture,
    required this.onSelected,
  });

  final Future<List<KansenSample>> samplesFuture;
  final ValueChanged<KansenSample> onSelected;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<KansenSample>>(
      future: samplesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _CatalogLoadError(error: snapshot.error);
        }
        final samples = snapshot.data;
        if (samples == null || samples.isEmpty) {
          return const _CatalogLoading();
        }
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemCount: samples.length,
          itemBuilder: (context, index) {
            final sample = samples[index];
            return _DexCard(
              sample: sample,
              locked: index > 2,
              onTap: () => onSelected(sample),
            );
          },
        );
      },
    );
  }
}

class _DexCard extends StatefulWidget {
  const _DexCard({
    required this.sample,
    required this.locked,
    required this.onTap,
  });

  final KansenSample sample;
  final bool locked;
  final VoidCallback onTap;

  @override
  State<_DexCard> createState() => _DexCardState();
}

class _DexCardState extends State<_DexCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glossController;

  @override
  void initState() {
    super.initState();
    _glossController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _glossController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: _hairline(context)),
            color: KansenThemeTokens.of(context).cardSurface,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              widget.locked
                  ? _SilhouetteImage(asset: widget.sample.portraitAsset)
                  : Hero(
                      tag: widget.sample.name,
                      child: _KansenArt(asset: widget.sample.portraitAsset),
                    ),
              AnimatedBuilder(
                animation: _glossController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _GlossPainter(
                      progress: _glossController.value,
                      color: KansenThemeColors.rarityAccent(
                        widget.sample.rarity,
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: _RarityEdge(
                  colors: KansenThemeColors.rarityGradient(
                    widget.sample.rarity,
                  ),
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.locked ? '????' : widget.sample.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                      ),
                    ),
                    Text(
                      '${widget.sample.rarityLabel}  ${widget.sample.shipClass}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: _ink(context, 0.62),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RarityEdge extends StatelessWidget {
  const _RarityEdge({required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(
              alpha: _isDark(context) ? 0.22 : 0.16,
            ),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: const SizedBox(width: 3.5),
    );
  }
}

class DetailOverlay extends StatefulWidget {
  const DetailOverlay({super.key, required this.sample});

  final KansenSample sample;

  @override
  State<DetailOverlay> createState() => _DetailOverlayState();
}

class _DetailOverlayState extends State<DetailOverlay> {
  Offset _pointer = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final center = Offset(size.width / 2, size.height / 2);
    final delta =
        (_pointer == Offset.zero ? Offset.zero : _pointer - center) / 80;

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.9),
      body: SafeArea(
        child: GestureDetector(
          onPanUpdate: (details) =>
              setState(() => _pointer = details.localPosition),
          child: Stack(
            children: [
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(delta.dx, delta.dy),
                  child: Hero(
                    tag: widget.sample.name,
                    child: _KansenArt(asset: widget.sample.portraitAsset),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 12,
                child: IconButton.filledTonal(
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(CupertinoIcons.xmark),
                ),
              ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 18,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: KansenThemeTokens.of(
                      context,
                    ).detailSurface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _hairline(context)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.sample.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _HintRow(sample: widget.sample),
                        const SizedBox(height: 12),
                        Row(
                          children: widget.sample.skillAssets.map((asset) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  asset,
                                  width: 44,
                                  height: 44,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HintRow extends StatelessWidget {
  const _HintRow({required this.sample});

  final KansenSample sample;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _HintChip(
          icon: CupertinoIcons.square_stack_3d_up,
          label: sample.family.label,
        ),
        _HintChip(icon: CupertinoIcons.star_fill, label: sample.rarityLabel),
        _HintChip(
          icon: CupertinoIcons.shield_lefthalf_fill,
          label: sample.shipClass,
        ),
      ],
    );
  }
}

class _HintChip extends StatelessWidget {
  const _HintChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _glass(context, dark: 0.08, light: 0.62),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _hairline(context)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: _ink(context, 0.72)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  final VoidCallback onPressed;
  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(48, 48),
      borderRadius: BorderRadius.circular(8),
      onPressed: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _glass(context, dark: 0.12, light: 0.72),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _hairline(context)),
        ),
        child: SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconTheme(
                data: IconThemeData(color: _ink(context), size: 20),
                child: icon,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: _ink(context),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconSurfaceButton extends StatelessWidget {
  const _IconSurfaceButton({
    required this.onPressed,
    required this.icon,
    required this.tooltip,
    this.size = 48,
  });

  final VoidCallback onPressed;
  final Widget icon;
  final String tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size(size, size),
        borderRadius: BorderRadius.circular(8),
        onPressed: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _glass(context, dark: 0.1, light: 0.68),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _hairline(context)),
          ),
          child: SizedBox.square(
            dimension: size,
            child: IconTheme(
              data: IconThemeData(color: _ink(context), size: size * 0.4),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}

class _KansenArt extends StatelessWidget {
  const _KansenArt({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: BoxFit.contain,
      alignment: Alignment.center,
      filterQuality: FilterQuality.high,
    );
  }
}

class _SilhouetteImage extends StatelessWidget {
  const _SilhouetteImage({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff030608), Color(0xff101a23)],
        ).createShader(bounds);
      },
      child: Image.asset(
        asset,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

class _RevealClipper extends CustomClipper<Path> {
  const _RevealClipper(this.progress);

  final double progress;

  @override
  Path getClip(Size size) {
    final eased = Curves.easeInOutCubicEmphasized.transform(
      progress.clamp(0, 1),
    );
    final radius =
        math.sqrt(size.width * size.width + size.height * size.height) * eased;
    return Path()..addOval(
      Rect.fromCircle(
        center: Offset(size.width * 0.5, size.height * 0.48),
        radius: radius,
      ),
    );
  }

  @override
  bool shouldReclip(covariant _RevealClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}

class _StageLightPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.24),
        radius: 0.72,
        colors: [
          const Color(0xff4bb4ff).withValues(alpha: 0.24),
          const Color(0xff33d0a7).withValues(alpha: 0.09),
          Colors.transparent,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.045)
      ..strokeWidth = 1;
    for (var y = size.height * 0.14; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 18), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _UnlockBurstPainter extends CustomPainter {
  const _UnlockBurstPainter({required this.progress, required this.colors});

  final double progress;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    final eased = Curves.easeOutCubic.transform(progress.clamp(0, 1));
    final fade = math.sin(progress * math.pi);
    final center = Offset(size.width * 0.5, size.height * 0.46);
    final radius = math.max(size.width, size.height) * (0.18 + eased * 0.62);
    final accent = colors.first;

    final bloom = Paint()
      ..shader = RadialGradient(
        colors: [
          accent.withValues(alpha: 0.18 * fade),
          colors.last.withValues(alpha: 0.1 * fade),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bloom);

    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 + 3 * fade
      ..color = accent.withValues(alpha: 0.36 * fade);
    canvas.drawCircle(center, radius * 0.78, ring);

    final sparklePaint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 18; i += 1) {
      final seed = i * 0.61803398875;
      final angle = seed * math.pi * 2 + eased * math.pi * 0.45;
      final distance =
          radius * (0.22 + (i % 5) * 0.115 + eased * (0.18 + (i % 3) * 0.04));
      final position =
          center + Offset(math.cos(angle), math.sin(angle)) * distance;
      final localPhase = ((progress * 1.55) - (i % 6) * 0.08).clamp(0.0, 1.0);
      final sparkleFade = math.sin(localPhase * math.pi).clamp(0.0, 1.0);
      if (sparkleFade <= 0) continue;

      final color = colors[i % colors.length];
      final sparkleSize = (2.2 + (i % 4) * 0.75) * sparkleFade;
      sparklePaint.color = color.withValues(alpha: 0.72 * sparkleFade);
      _drawSparkle(canvas, position, sparkleSize, sparklePaint);
    }
  }

  void _drawSparkle(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path()
      ..moveTo(center.dx, center.dy - radius * 1.75)
      ..lineTo(center.dx + radius * 0.42, center.dy - radius * 0.42)
      ..lineTo(center.dx + radius * 1.75, center.dy)
      ..lineTo(center.dx + radius * 0.42, center.dy + radius * 0.42)
      ..lineTo(center.dx, center.dy + radius * 1.75)
      ..lineTo(center.dx - radius * 0.42, center.dy + radius * 0.42)
      ..lineTo(center.dx - radius * 1.75, center.dy)
      ..lineTo(center.dx - radius * 0.42, center.dy - radius * 0.42)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _UnlockBurstPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.colors != colors;
  }
}

class _GlossPainter extends CustomPainter {
  const _GlossPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final x = (size.width * 2.4 * progress) - size.width * 0.8;
    final path = Path()
      ..moveTo(x, 0)
      ..lineTo(x + size.width * 0.32, 0)
      ..lineTo(x - size.width * 0.08, size.height)
      ..lineTo(x - size.width * 0.4, size.height)
      ..close();
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          color.withValues(alpha: 0.18),
          Colors.white.withValues(alpha: 0.08),
          Colors.transparent,
        ],
      ).createShader(path.getBounds());
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _GlossPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class _AppBackdrop extends StatelessWidget {
  const _AppBackdrop();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _isDark(context)
              ? KansenThemeTokens.dark.backdropGradient
              : KansenThemeTokens.light.backdropGradient,
        ),
      ),
      child: CustomPaint(
        painter: _BackdropPainter(isDark: _isDark(context)),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _BackdropPainter extends CustomPainter {
  const _BackdropPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final tokens = isDark ? KansenThemeTokens.dark : KansenThemeTokens.light;
    final paint = Paint()
      ..color = tokens.backdropLine.withValues(alpha: isDark ? 0.035 : 0.045);
    for (var x = -size.height; x < size.width; x += 34) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BackdropPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}

class KansenSample implements QuizPromptAnswer {
  const KansenSample({
    required this.name,
    required this.family,
    required this.rarity,
    required this.rarityLabel,
    required this.shipClass,
    required this.portraitAsset,
    required this.skillAssets,
  });

  final String name;
  @override
  String get answerName => name;
  final KansenVariantFamily family;
  final KansenRarity rarity;
  final String rarityLabel;
  final String shipClass;
  final String portraitAsset;
  final List<String> skillAssets;
}
