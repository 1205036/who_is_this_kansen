import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/feature_flag.dart';
import '../domain/feature_flags.dart';
import '../domain/feature_flags_repository.dart';

/// Persists debug overrides in [SharedPreferencesAsync] and resolves flag
/// values. Overrides apply only under [kDebugMode]; release builds ignore any
/// persisted override and fall through to [FeatureFlag.defaultValue].
@LazySingleton(as: FeatureFlagsRepository)
class SharedPreferencesFeatureFlagsRepository extends ChangeNotifier
    implements FeatureFlagsRepository {
  SharedPreferencesFeatureFlagsRepository(this._prefs);

  final SharedPreferencesAsync _prefs;

  /// In-memory cache of `flag.key -> encoded override`, keeping reads sync.
  final Map<String, String> _overrides = {};

  static String _prefsKey(FeatureFlag flag) =>
      'feature_flag_override.${flag.key}';

  @override
  Future<void> load() async {
    if (!kDebugMode) return;
    _overrides.clear();
    for (final flag in FeatureFlags.all) {
      final raw = await _prefs.getString(_prefsKey(flag));
      if (raw != null) _overrides[flag.key] = raw;
    }
    notifyListeners();
  }

  @override
  T valueOf<T>(FeatureFlag<T> flag) {
    if (kDebugMode) {
      final raw = _overrides[flag.key];
      if (raw != null) return flag.parse(raw);
    }
    // Tier 3 remote source resolves here in the future.
    return flag.defaultValue;
  }

  @override
  bool hasOverride(FeatureFlag flag) =>
      kDebugMode && _overrides.containsKey(flag.key);

  @override
  Future<void> setOverride<T>(FeatureFlag<T> flag, T value) async {
    if (!kDebugMode) return;
    final encoded = flag.format(value);
    _overrides[flag.key] = encoded;
    notifyListeners();
    await _prefs.setString(_prefsKey(flag), encoded);
  }

  @override
  Future<void> clearOverride(FeatureFlag flag) async {
    if (!kDebugMode) return;
    if (_overrides.remove(flag.key) != null) notifyListeners();
    await _prefs.remove(_prefsKey(flag));
  }

  @override
  Future<void> clearAllOverrides() async {
    if (!kDebugMode) return;
    if (_overrides.isEmpty) return;
    _overrides.clear();
    notifyListeners();
    for (final flag in FeatureFlags.all) {
      await _prefs.remove(_prefsKey(flag));
    }
  }
}
