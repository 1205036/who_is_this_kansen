import 'package:flutter/foundation.dart';

/// Compile-time debug gates (Tier 1 of the feature-flag system, PLAN item 26).
///
/// Every flag resolves from a `const` expression so release builds statically
/// tree-shake any gated code out — a flag defaulting to [kDebugMode] can never
/// run in a production build. Use this only for developer-facing tooling that
/// must never reach players. Runtime-toggleable flags are a later tier behind
/// `FeatureFlagsRepository`.
abstract final class DebugFlags {
  /// Nag on app start when the bundled catalog is past its staleness threshold
  /// so a hand-maintained roster can't silently drift (PLAN item 24).
  static const bool catalogStalenessReminder = kDebugMode;
}
