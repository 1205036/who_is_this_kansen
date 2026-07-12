import 'feature_flag.dart';

/// Multi-value example: how the silhouette resolves into full art.
enum RevealStyle { dissolve, fade, wipe }

/// Central registry of every runtime feature flag (PLAN item 26).
///
/// Add a flag here, then read it anywhere via
/// `getIt<FeatureFlagsRepository>().valueOf(FeatureFlags.<flag>)`. Flags are
/// toggled in debug via the long-press-logo menu; release resolves to
/// [FeatureFlag.defaultValue].
abstract final class FeatureFlags {
  /// Reserved to gate the scrollable Kansen detail Screen 2 (PLAN item 20)
  /// while it is under construction. Not consumed yet.
  static const BoolFlag newKansenDetailScreen = BoolFlag(
    key: 'new_kansen_detail_screen',
    label: 'New Kansen detail (Screen 2)',
    description:
        'Gate the scrollable wiki-style detail surface (PLAN item 20). '
        'Reserved — not consumed yet.',
  );

  /// Multi-value demo: correct-answer reveal animation. Not consumed yet.
  static const EnumFlag<RevealStyle> revealStyle = EnumFlag<RevealStyle>(
    key: 'reveal_style',
    label: 'Reveal style',
    description:
        'Correct-answer silhouette → art transition. Reserved — not consumed yet.',
    defaultValue: RevealStyle.dissolve,
    values: RevealStyle.values,
  );

  /// Every registered flag, in menu order.
  static const List<FeatureFlag> all = <FeatureFlag>[
    newKansenDetailScreen,
    revealStyle,
  ];
}
