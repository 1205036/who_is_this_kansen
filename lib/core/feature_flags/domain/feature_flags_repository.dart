import 'package:flutter/foundation.dart';

import 'feature_flag.dart';

/// Reads feature-flag values and (in debug) manages local overrides.
///
/// Resolution order: debug-menu override → remote (Tier 3, deferred) →
/// [FeatureFlag.defaultValue]. Overrides are honoured only under [kDebugMode];
/// release builds always fall through to the default. Implements [Listenable]
/// so the debug menu rebuilds when an override changes.
abstract interface class FeatureFlagsRepository implements Listenable {
  /// Load persisted overrides into memory. No-op in release builds.
  Future<void> load();

  /// Resolved value for [flag].
  T valueOf<T>(FeatureFlag<T> flag);

  /// Whether a debug override is currently applied to [flag].
  bool hasOverride(FeatureFlag flag);

  /// Set a debug override for [flag]. No-op in release builds.
  Future<void> setOverride<T>(FeatureFlag<T> flag, T value);

  /// Remove the debug override for [flag], reverting to default.
  Future<void> clearOverride(FeatureFlag flag);

  /// Remove all debug overrides.
  Future<void> clearAllOverrides();
}
