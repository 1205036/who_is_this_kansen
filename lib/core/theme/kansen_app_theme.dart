import 'package:flutter/material.dart';

class KansenAppTheme {
  const KansenAppTheme._();

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff4f6576),
        brightness: Brightness.light,
        surface: const Color(0xfff5f7f9),
      ),
      extensions: const [KansenThemeTokens.light],
      fontFamily: '.SF Pro Display',
      scaffoldBackgroundColor: Color(0xfff4f6f8),
      useMaterial3: true,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff8fa4b6),
        brightness: Brightness.dark,
        surface: const Color(0xff10151c),
      ),
      extensions: const [KansenThemeTokens.dark],
      fontFamily: '.SF Pro Display',
      scaffoldBackgroundColor: Color(0xff090d12),
      useMaterial3: true,
    );
  }
}

class KansenThemeTokens extends ThemeExtension<KansenThemeTokens> {
  const KansenThemeTokens({
    required this.ink,
    required this.hairline,
    required this.backdropGradient,
    required this.backdropLine,
    required this.segmentThumb,
    required this.stageGradient,
    required this.cardSurface,
    required this.detailSurface,
  });

  static const light = KansenThemeTokens(
    ink: Color(0xff101820),
    hairline: Color(0xff213044),
    backdropGradient: [Color(0xfff7f9fb), Color(0xffedf2f6), Color(0xffe5edf2)],
    backdropLine: Color(0xff213044),
    segmentThumb: Color(0xffffffff),
    stageGradient: [Color(0xffeef3f6), Color(0xffdfe8ee)],
    cardSurface: Color(0xfff6f8fa),
    detailSurface: Color(0xfff8fafb),
  );

  static const dark = KansenThemeTokens(
    ink: Color(0xffffffff),
    hairline: Color(0xffffffff),
    backdropGradient: [Color(0xff0a1118), Color(0xff11151b), Color(0xff071015)],
    backdropLine: Color(0xffffffff),
    segmentThumb: Color(0xffd9e0e7),
    stageGradient: [Color(0xff151e27), Color(0xff071017)],
    cardSurface: Color(0xff111821),
    detailSurface: Color(0xff10151c),
  );

  final Color ink;
  final Color hairline;
  final List<Color> backdropGradient;
  final Color backdropLine;
  final Color segmentThumb;
  final List<Color> stageGradient;
  final Color cardSurface;
  final Color detailSurface;

  static KansenThemeTokens of(BuildContext context) {
    return Theme.of(context).extension<KansenThemeTokens>()!;
  }

  @override
  KansenThemeTokens copyWith({
    Color? ink,
    Color? hairline,
    List<Color>? backdropGradient,
    Color? backdropLine,
    Color? segmentThumb,
    List<Color>? stageGradient,
    Color? cardSurface,
    Color? detailSurface,
  }) {
    return KansenThemeTokens(
      ink: ink ?? this.ink,
      hairline: hairline ?? this.hairline,
      backdropGradient: backdropGradient ?? this.backdropGradient,
      backdropLine: backdropLine ?? this.backdropLine,
      segmentThumb: segmentThumb ?? this.segmentThumb,
      stageGradient: stageGradient ?? this.stageGradient,
      cardSurface: cardSurface ?? this.cardSurface,
      detailSurface: detailSurface ?? this.detailSurface,
    );
  }

  @override
  KansenThemeTokens lerp(ThemeExtension<KansenThemeTokens>? other, double t) {
    if (other is! KansenThemeTokens) return this;
    return KansenThemeTokens(
      ink: Color.lerp(ink, other.ink, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
      backdropGradient: _lerpColors(
        backdropGradient,
        other.backdropGradient,
        t,
      ),
      backdropLine: Color.lerp(backdropLine, other.backdropLine, t)!,
      segmentThumb: Color.lerp(segmentThumb, other.segmentThumb, t)!,
      stageGradient: _lerpColors(stageGradient, other.stageGradient, t),
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      detailSurface: Color.lerp(detailSurface, other.detailSurface, t)!,
    );
  }

  List<Color> _lerpColors(List<Color> a, List<Color> b, double t) {
    return List<Color>.generate(
      a.length,
      (index) => Color.lerp(a[index], b[index], t)!,
    );
  }
}
