import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const KansenApp());
}

const _assetRoot = 'research/generated_images';

bool _isDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

Color _ink(BuildContext context, [double opacity = 1]) {
  return (_isDark(context) ? Colors.white : const Color(0xff101820)).withValues(
    alpha: opacity,
  );
}

Color _glass(BuildContext context, {double dark = 0.08, double light = 0.72}) {
  return (_isDark(context) ? Colors.white : Colors.white).withValues(
    alpha: _isDark(context) ? dark : light,
  );
}

Color _hairline(BuildContext context) {
  return (_isDark(context) ? Colors.white : const Color(0xff213044)).withValues(
    alpha: _isDark(context) ? 0.12 : 0.12,
  );
}

Color _rarityAccent(String rarity) {
  return switch (rarity.toLowerCase()) {
    'decisive' => const Color(0xff7fd7c6),
    'ultra rare' => const Color(0xffc9a7ff),
    'priority' => const Color(0xff7bb6e8),
    'super rare' => const Color(0xffe4bd67),
    'elite' => const Color(0xffb7a3d9),
    'rare' => const Color(0xff86aee8),
    'normal' => const Color(0xffa7b0b8),
    _ => const Color(0xffaeb8c2),
  };
}

List<Color> _rarityGradient(String rarity) {
  return switch (rarity.toLowerCase()) {
    'decisive' => const [
      Color(0xff7fd7c6),
      Color(0xff8bb8ff),
      Color(0xffd1b2ff),
    ],
    'ultra rare' => const [
      Color(0xffffaebc),
      Color(0xffffe18f),
      Color(0xff91e6d1),
      Color(0xffbca7ff),
    ],
    'priority' => const [Color(0xff7bb6e8), Color(0xffd6b6ff)],
    'super rare' => const [Color(0xfff0d083), Color(0xffba8744)],
    'elite' => const [Color(0xffd1c1ee), Color(0xff9279c2)],
    'rare' => const [Color(0xffa8c6f3), Color(0xff638fd2)],
    'normal' => const [Color(0xffc0c7ce), Color(0xff848e98)],
    _ => const [Color(0xffc2ccd4), Color(0xff8d98a2)],
  };
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
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff4f6576),
          brightness: Brightness.light,
          surface: const Color(0xfff5f7f9),
        ),
        fontFamily: '.SF Pro Display',
        scaffoldBackgroundColor: const Color(0xfff4f6f8),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff8fa4b6),
          brightness: Brightness.dark,
          surface: const Color(0xff10151c),
        ),
        fontFamily: '.SF Pro Display',
        scaffoldBackgroundColor: const Color(0xff090d12),
        useMaterial3: true,
      ),
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
  var _activeIndex = 0;

  KansenSample get _active => kansenSamples[_activeIndex];

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
                      PrototypeTab.quiz => QuizPrototype(
                        key: const ValueKey('quiz'),
                        sample: _active,
                        onNext: () {
                          setState(() {
                            _activeIndex =
                                (_activeIndex + 1) % kansenSamples.length;
                          });
                        },
                        onOpenDetail: () => _showKansen(_active),
                      ),
                      PrototypeTab.dex => DexPrototype(
                        key: const ValueKey('dex'),
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
                thumbColor: _isDark(context)
                    ? const Color(0xffd9e0e7)
                    : const Color(0xffffffff),
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
  var _revealed = false;
  var _message =
      'Variant, rarity, and class hints are visible in Default mode.';

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
      _revealed = false;
      _message =
          'Variant, rarity, and class hints are visible in Default mode.';
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    _revealController.dispose();
    super.dispose();
  }

  void _submit() {
    final answer = _answerController.text.trim();
    if (answer.toLowerCase() == widget.sample.name.toLowerCase()) {
      setState(() {
        _revealed = true;
        _message = 'Unlocked in Kansendex';
      });
      _revealController.forward(from: 0);
    } else {
      setState(() {
        _message = 'Exact name required, case ignored';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sample = widget.sample;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
      children: [
        _PromptStage(
          sample: sample,
          revealed: _revealed,
          revealAnimation: _revealController,
        ),
        const SizedBox(height: 14),
        _HintRow(sample: sample),
        const SizedBox(height: 14),
        TextField(
          controller: _answerController,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
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
            _message,
            key: ValueKey(_message),
            style: TextStyle(color: _ink(context, 0.68)),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                onPressed: _revealed ? widget.onOpenDetail : _submit,
                icon: Icon(
                  _revealed
                      ? CupertinoIcons.sparkles
                      : CupertinoIcons.check_mark_circled,
                ),
                label: _revealed ? 'Open Detail' : 'Submit Guess',
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
              colors: _isDark(context)
                  ? const [Color(0xff151e27), Color(0xff071017)]
                  : const [Color(0xffeef3f6), Color(0xffdfe8ee)],
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
                              colors: _rarityGradient(widget.sample.rarity),
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
  const DexPrototype({super.key, required this.onSelected});

  final ValueChanged<KansenSample> onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: kansenSamples.length,
      itemBuilder: (context, index) {
        final sample = kansenSamples[index];
        return _DexCard(
          sample: sample,
          locked: index > 2,
          onTap: () => onSelected(sample),
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
            color: _isDark(context)
                ? const Color(0xff111821)
                : const Color(0xfff6f8fa),
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
                      color: _rarityAccent(widget.sample.rarity),
                    ),
                  );
                },
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: _RarityEdge(
                  colors: _rarityGradient(widget.sample.rarity),
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
                      '${widget.sample.rarity}  ${widget.sample.shipClass}',
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
      backgroundColor: Colors.black.withValues(alpha: 0.58),
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
                    color:
                        (_isDark(context)
                                ? const Color(0xff10151c)
                                : const Color(0xfff8fafb))
                            .withValues(alpha: 0.9),
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
          label: sample.family,
        ),
        _HintChip(icon: CupertinoIcons.star_fill, label: sample.rarity),
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
              ? const [Color(0xff0a1118), Color(0xff11151b), Color(0xff071015)]
              : const [Color(0xfff7f9fb), Color(0xffedf2f6), Color(0xffe5edf2)],
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
    final paint = Paint()
      ..color = (isDark ? Colors.white : const Color(0xff213044)).withValues(
        alpha: isDark ? 0.035 : 0.045,
      );
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

class KansenSample {
  const KansenSample({
    required this.name,
    required this.family,
    required this.rarity,
    required this.shipClass,
    required this.portraitAsset,
    required this.skillAssets,
  });

  final String name;
  final String family;
  final String rarity;
  final String shipClass;
  final String portraitAsset;
  final List<String> skillAssets;
}

const kansenSamples = [
  KansenSample(
    name: 'Bismarck Zwei',
    family: 'Zwei',
    rarity: 'Ultra Rare',
    shipClass: 'Battleship',
    portraitAsset: '$_assetRoot/portrait_detail__Bismarck_Zwei__q86.webp',
    skillAssets: [
      '$_assetRoot/skill_icon__Skill_10680__q82.webp',
      '$_assetRoot/skill_icon__Skill_10690__q82.webp',
    ],
  ),
  KansenSample(
    name: 'Ägir',
    family: 'Base',
    rarity: 'Decisive',
    shipClass: 'Large Cruiser',
    portraitAsset: '$_assetRoot/portrait_detail__A_gir__q86.webp',
    skillAssets: [
      '$_assetRoot/skill_icon__Skill_151150__q82.webp',
      '$_assetRoot/skill_icon__Skill_151160__q82.webp',
    ],
  ),
  KansenSample(
    name: 'Roon µ',
    family: 'Muse',
    rarity: 'Super Rare',
    shipClass: 'Heavy Cruiser',
    portraitAsset: '$_assetRoot/portrait_detail__Roon__q86.webp',
    skillAssets: [
      '$_assetRoot/skill_icon__Skill_11320__q82.webp',
      '$_assetRoot/skill_icon__Skill_29310__q82.webp',
    ],
  ),
  KansenSample(
    name: 'Hindenburg',
    family: 'Base',
    rarity: 'Decisive',
    shipClass: 'Heavy Cruiser',
    portraitAsset: '$_assetRoot/portrait_detail__Hindenburg__q86.webp',
    skillAssets: [
      '$_assetRoot/skill_icon__Skill_11440__q82.webp',
      '$_assetRoot/skill_icon__Skill_11460__q82.webp',
    ],
  ),
  KansenSample(
    name: 'Little Prinz Eugen',
    family: 'Little',
    rarity: 'Elite',
    shipClass: 'Heavy Cruiser',
    portraitAsset: '$_assetRoot/portrait_detail__Little_Prinz_Eugen__q86.webp',
    skillAssets: [
      '$_assetRoot/skill_icon__Skill_151150__q82.webp',
      '$_assetRoot/skill_icon__Skill_151160__q82.webp',
    ],
  ),
  KansenSample(
    name: 'Graf Zeppelin',
    family: 'Base',
    rarity: 'Super Rare',
    shipClass: 'Aircraft Carrier',
    portraitAsset: '$_assetRoot/portrait_detail__Graf_Zeppelin__q86.webp',
    skillAssets: [
      '$_assetRoot/skill_icon__Skill_10680__q82.webp',
      '$_assetRoot/skill_icon__Skill_10690__q82.webp',
    ],
  ),
  KansenSample(
    name: 'Z23',
    family: 'Base',
    rarity: 'Elite',
    shipClass: 'Destroyer',
    portraitAsset: '$_assetRoot/portrait_detail__Z23__q86.webp',
    skillAssets: [
      '$_assetRoot/skill_icon__Skill_11320__q82.webp',
      '$_assetRoot/skill_icon__Skill_29310__q82.webp',
    ],
  ),
  KansenSample(
    name: 'U-47',
    family: 'Base',
    rarity: 'Super Rare',
    shipClass: 'Submarine',
    portraitAsset: '$_assetRoot/portrait_detail__U-47__q86.webp',
    skillAssets: [
      '$_assetRoot/skill_icon__Skill_11440__q82.webp',
      '$_assetRoot/skill_icon__Skill_11460__q82.webp',
    ],
  ),
];
